package com.tunehub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.tunehub.config.DBConfig;
import com.tunehub.model.Playlist;
import com.tunehub.model.Song;
import com.tunehub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean isAuthenticated(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private List<Playlist> loadPlaylists(Connection conn, int userId) throws Exception {
        List<Playlist> list = new ArrayList<>();
        PreparedStatement ps = conn.prepareStatement("SELECT playlist_id, name, description, is_public, user_id FROM playlists WHERE user_id = ? ORDER BY created_at DESC");
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        while(rs.next()) {
            Playlist p = new Playlist();
            p.setId(rs.getInt("playlist_id"));
            p.setName(rs.getString("name"));
            p.setDescription(rs.getString("description"));
            p.setPublic(rs.getBoolean("is_public"));
            p.setUserId(rs.getInt("user_id"));
            list.add(p);
        }
        rs.close(); ps.close();
        return list;
    }

    private List<Song> loadSongs(Connection conn) throws Exception {
        List<Song> list = new ArrayList<>();
        PreparedStatement ps = conn.prepareStatement("SELECT id, title, artist, album, file_path FROM songs ORDER BY created_at DESC");
        ResultSet rs = ps.executeQuery();
        while(rs.next()) {
            Song s = new Song();
            s.setId(rs.getInt("id"));
            s.setTitle(rs.getString("title"));
            s.setArtist(rs.getString("artist"));
            s.setAlbum(rs.getString("album"));
            s.setFilePath(rs.getString("file_path"));
            list.add(s);
        }
        rs.close(); ps.close();
        return list;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAuthenticated(request, response)) return;

        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("user");

        // ✅ Edit Profile Action
        if ("edit".equals(request.getParameter("action"))) {
            request.setAttribute("user", u);
            request.getRequestDispatcher("/WEB-INF/Pages/profile.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            conn = DBConfig.getConnection();
            List<Playlist> myPls = loadPlaylists(conn, u.getId());
            List<Song> allSongs = loadSongs(conn);

            request.setAttribute("user", u);
            request.setAttribute("userPlaylists", myPls);
            request.setAttribute("userSongs", allSongs);
            request.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?error=System error");
        } finally {
            if(conn!=null) try { conn.close(); } catch(Exception ignored){}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAuthenticated(request, response)) return;

        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("user");
        String username = request.getParameter("username");
        String email = request.getParameter("email");

        Connection conn = null;
        try {
            conn = DBConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE users SET username=?, email=? WHERE user_id=?");
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setInt(3, u.getId());
            ps.executeUpdate();
            
            // Update session user
            u.setUsername(username);
            u.setEmail(email);
            session.setAttribute("user", u);
            
            response.sendRedirect(request.getContextPath() + "/profile?msg=Profile updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile?action=edit&error=Update failed");
        } finally {
            if(conn!=null) try { conn.close(); } catch(Exception ignored){}
        }
    }
}