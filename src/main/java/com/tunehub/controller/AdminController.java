package com.tunehub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.tunehub.config.DBConfig;
import com.tunehub.model.Song;
import com.tunehub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin")
public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean check(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession s = req.getSession(false);
        if(s==null || s.getAttribute("user")==null) { res.sendRedirect(req.getContextPath()+"/login"); return false; }
        if(!"admin".equals(((User)s.getAttribute("user")).getRole())) { 
            res.sendRedirect(req.getContextPath()+"/login?error=Unauthorized"); return false; 
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if (!check(req, res)) return;

        String action = req.getParameter("action");
        
        // ✅ HANDLE ADMIN PROFILE EDIT → Use shared profile.jsp
        if ("editProfile".equals(action)) {
            req.setAttribute("fromAdmin", true); // Flag for profile.jsp to adjust form action
            req.getRequestDispatcher("/WEB-INF/Pages/profile.jsp").forward(req, res);
            return;
        }

        Connection c = null;
        try {
            c = DBConfig.getConnection();
            
            // ✅ HANDLE EDIT SONG ACTION
            if ("editSong".equals(action)) {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    PreparedStatement ps = c.prepareStatement("SELECT id, title, artist, album, file_path FROM songs WHERE id = ?");
                    ps.setInt(1, id);
                    ResultSet rs = ps.executeQuery();
                    if(rs.next()) {
                        Song editSong = new Song();
                        editSong.setId(rs.getInt("id"));
                        editSong.setTitle(rs.getString("title"));
                        editSong.setArtist(rs.getString("artist"));
                        editSong.setAlbum(rs.getString("album"));
                        editSong.setFilePath(rs.getString("file_path"));
                        req.setAttribute("editSong", editSong);
                    }
                    rs.close(); ps.close();
                } catch (Exception e) { e.printStackTrace(); }
            }

            // ✅ LOAD USERS
            List<User> users = new ArrayList<>();
            PreparedStatement psU = c.prepareStatement("SELECT user_id, username, email, role, created_at FROM users ORDER BY created_at DESC");
            ResultSet rsU = psU.executeQuery();
            while(rsU.next()){
                User u = new User();
                u.setId(rsU.getInt("user_id")); u.setUsername(rsU.getString("username"));
                u.setEmail(rsU.getString("email")); u.setRole(rsU.getString("role"));
                u.setCreatedAt(rsU.getTimestamp("created_at"));
                users.add(u);
            }
            rsU.close(); psU.close();
            req.setAttribute("users", users);

            // ✅ LOAD SONGS
            List<Song> songs = new ArrayList<>();
            PreparedStatement psS = c.prepareStatement("SELECT id, title, artist, album, file_path FROM songs ORDER BY created_at DESC");
            ResultSet rsS = psS.executeQuery();
            while(rsS.next()){
                Song s = new Song();
                s.setId(rsS.getInt("id")); s.setTitle(rsS.getString("title"));
                s.setArtist(rsS.getString("artist")); s.setAlbum(rsS.getString("album"));
                s.setFilePath(rsS.getString("file_path"));
                songs.add(s);
            }
            rsS.close(); psS.close();
            req.setAttribute("songs", songs);
            
            // ✅ LOAD PLAYLISTS MAP
            Map<Integer, List<String>> pMap = new HashMap<>();
            PreparedStatement psP = c.prepareStatement("SELECT user_id, name FROM playlists");
            ResultSet rsP = psP.executeQuery();
            while(rsP.next()) {
                pMap.computeIfAbsent(rsP.getInt("user_id"), k -> new ArrayList<>()).add(rsP.getString("name"));
            }
            rsP.close(); psP.close();
            req.setAttribute("userPlaylistsMap", pMap);

            req.getRequestDispatcher("/WEB-INF/Pages/dashboard-admin.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load dashboard");
            req.getRequestDispatcher("/WEB-INF/Pages/dashboard-admin.jsp").forward(req, res);
        } finally {
            if(c!=null) try { c.close(); } catch(Exception ignored){}
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if (!check(req, res)) return;
        String act = req.getParameter("action");
        Connection c = null; PreparedStatement ps = null;
        try {
            c = DBConfig.getConnection();
            
            // ✅ HANDLE ADMIN PROFILE UPDATE
            if("updateAdminProfile".equals(act)) {
                User admin = (User) req.getSession().getAttribute("user");
                String newU = req.getParameter("username").trim();
                String newE = req.getParameter("email").trim();
                
                if(newU.length()<3 || !newU.matches("^[a-zA-Z0-9_]{3,20}$") || !newE.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                    res.sendRedirect(req.getContextPath()+"/admin?action=editProfile&error=Invalid username/email format"); return;
                }
                
                PreparedStatement chk = c.prepareStatement("SELECT 1 FROM users WHERE (username=? OR email=?) AND user_id!=?");
                chk.setString(1,newU); chk.setString(2,newE); chk.setInt(3,admin.getId());
                if(chk.executeQuery().next()) { 
                    res.sendRedirect(req.getContextPath()+"/admin?action=editProfile&error=Username/Email taken"); return; 
                }
                chk.close();
                
                ps = c.prepareStatement("UPDATE users SET username=?, email=? WHERE user_id=?");
                ps.setString(1, newU); ps.setString(2, newE); ps.setInt(3, admin.getId());
                ps.executeUpdate();
                
                admin.setUsername(newU); admin.setEmail(newE);
                req.getSession().setAttribute("user", admin);
                res.sendRedirect(req.getContextPath()+"/admin?action=editProfile&success=Profile updated");
                return;
            }
            
            if("saveSong".equals(act)) {
                int id = 0; try{id=Integer.parseInt(req.getParameter("id"));}catch(Exception e){}
                String t=req.getParameter("title"), a=req.getParameter("artist"), al=req.getParameter("album"), fp=req.getParameter("file_path");
                if(id>0){
                    ps = c.prepareStatement("UPDATE songs SET title=?, artist=?, album=?, file_path=? WHERE id=?");
                    ps.setString(1,t); ps.setString(2,a); ps.setString(3,al); ps.setString(4,fp); ps.setInt(5,id);
                } else {
                    ps = c.prepareStatement("INSERT INTO songs (title, artist, album, file_path, uploaded_by) VALUES (?,?,?,?,?)");
                    ps.setString(1,t); ps.setString(2,a); ps.setString(3,al); ps.setString(4,fp); 
                    ps.setInt(5, ((User)req.getSession().getAttribute("user")).getId());
                }
                ps.executeUpdate();
            }
            if("deleteSong".equals(act)) {
                int id = Integer.parseInt(req.getParameter("id"));
                ps = c.prepareStatement("DELETE FROM songs WHERE id=?"); ps.setInt(1,id); ps.executeUpdate();
            }
            if("deleteUser".equals(act)) {
                int id = Integer.parseInt(req.getParameter("id"));
                ps = c.prepareStatement("DELETE FROM users WHERE user_id=?"); ps.setInt(1,id); ps.executeUpdate();
            }
            res.sendRedirect(req.getContextPath() + "/admin"); 
        } catch(Exception e) { e.printStackTrace(); res.sendRedirect(req.getContextPath() + "/admin?error=Failed"); }
        finally { try { if(ps!=null) ps.close(); if(c!=null) c.close(); } catch(Exception ignored){} }
    }
}