package com.tunehub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.tunehub.config.DBConfig;
import com.tunehub.model.Song;
import com.tunehub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/songs")
public class SongController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean isAuthenticated(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private String sanitize(String s) {
        return s == null ? "" : s.trim().replaceAll("[<>\"'&]", "");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthenticated(request, response)) return;

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        String title = sanitize(request.getParameter("title"));
        String artist = sanitize(request.getParameter("artist"));
        String album = sanitize(request.getParameter("album"));

        if (title.isEmpty() || artist.isEmpty()) {
            request.setAttribute("error", "Title and Artist are required.");
            loadUserSongs(request, currentUser.getId());
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBConfig.getConnection();
            
            ps = conn.prepareStatement(
                "INSERT INTO songs (title, artist, album, uploaded_by) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, title);
            ps.setString(2, artist);
            ps.setString(3, album.isEmpty() ? null : album);
            ps.setInt(4, currentUser.getId());
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                request.setAttribute("success", "Song \"" + title + "\" added successfully!");
            } else {
                request.setAttribute("error", "Failed to add song.");
            }
            
            loadUserSongs(request, currentUser.getId());
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            loadUserSongs(request, currentUser.getId());
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(request, response);
        } finally {
            if (ps != null) try { ps.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }
    
    private void loadUserSongs(HttpServletRequest request, int userId) {
        try (Connection conn = DBConfig.getConnection()) {
            List<Song> songs = new ArrayList<>();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT id, title, artist, album FROM songs WHERE uploaded_by = ? ORDER BY created_at DESC"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Song s = new Song();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setArtist(rs.getString("artist"));
                s.setAlbum(rs.getString("album"));
                songs.add(s);
            }
            rs.close(); ps.close();
            request.setAttribute("userSongs", songs);
        } catch (Exception e) { e.printStackTrace(); }
    }
}