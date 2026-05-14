package com.tunehub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.tunehub.config.DBConfig;
import com.tunehub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/playlist")
public class PlaylistController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean auth(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession s = req.getSession(false);
        if(s==null || s.getAttribute("user")==null) { res.sendRedirect(req.getContextPath()+"/login"); return false; }
        return true;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if(!auth(req, res)) return;
        User u = (User) req.getSession().getAttribute("user");
        String act = req.getParameter("action");
        
        Connection c = null; PreparedStatement ps = null;
        try {
            c = DBConfig.getConnection();
            
            if("create".equals(act)) {
                String nm = req.getParameter("name");
                String desc = req.getParameter("description");
                boolean isPub = "true".equals(req.getParameter("is_public"));
                if(nm!=null && !nm.trim().isEmpty()){
                    ps = c.prepareStatement("INSERT INTO playlists (name, description, user_id, is_public) VALUES (?,?,?,?)");
                    ps.setString(1, nm.trim());
                    ps.setString(2, desc!=null?desc.trim():"");
                    ps.setInt(3, u.getId());
                    ps.setBoolean(4, isPub);
                    ps.executeUpdate();
                }
            }
            
            if("addSong".equals(act)) {
                String pid = req.getParameter("playlist_id");
                String sid = req.getParameter("song_id");
                if(pid!=null && sid!=null && !pid.isEmpty() && !sid.isEmpty()){
                    int playlistId = Integer.parseInt(pid);
                    // ✅ Check if playlist is admin-owned (default playlist)
                    PreparedStatement check = c.prepareStatement("SELECT user_id FROM playlists WHERE playlist_id = ?");
                    check.setInt(1, playlistId);
                    ResultSet rs = check.executeQuery();
                    if(rs.next()) {
                        int ownerId = rs.getInt("user_id");
                        // Only allow adding if user owns the playlist OR it's their own
                        if(ownerId == u.getId()) {
                            ps = c.prepareStatement("INSERT IGNORE INTO playlist_songs (playlist_id, song_id) VALUES (?,?)");
                            ps.setInt(1, playlistId);
                            ps.setInt(2, Integer.parseInt(sid));
                            ps.executeUpdate();
                        }
                    }
                    rs.close(); check.close();
                }
            }
            
            if("delete".equals(act)) {
                String pid = req.getParameter("playlist_id");
                if(pid!=null){
                    ps = c.prepareStatement("DELETE FROM playlists WHERE playlist_id = ? AND user_id = ?");
                    ps.setInt(1, Integer.parseInt(pid));
                    ps.setInt(2, u.getId());
                    ps.executeUpdate();
                }
            }
            
            res.sendRedirect(req.getContextPath() + "/profile");
            
        } catch(Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/profile?error=Operation failed");
        } finally {
            try { if(ps!=null) ps.close(); if(c!=null) c.close(); } catch(Exception ignored){}
        }
    }
}