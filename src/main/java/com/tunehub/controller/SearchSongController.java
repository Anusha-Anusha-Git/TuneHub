package com.tunehub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.tunehub.config.DBConfig;
import com.tunehub.model.Song;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/search")
public class SearchSongController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String q = req.getParameter("q");
        
        // 1️⃣ FIX: Empty search → Stay on Homepage
        if (q == null || q.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String query = q.trim();
        List<Song> results = new ArrayList<>();
        Connection c = null;
        
        try {
            c = DBConfig.getConnection();
            // Search Title OR Artist
            PreparedStatement ps = c.prepareStatement(
                "SELECT id, title, artist, album, file_path FROM songs WHERE title LIKE ? OR artist LIKE ?"
            );
            ps.setString(1, "%" + query + "%");
            ps.setString(2, "%" + query + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Song s = new Song();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setArtist(rs.getString("artist"));
                s.setAlbum(rs.getString("album"));
                s.setFilePath(rs.getString("file_path"));
                results.add(s);
            }
            rs.close(); ps.close();
        } catch (Exception e) { e.printStackTrace(); }
        finally { if (c != null) try { c.close(); } catch (Exception ignored) {} }

        // 2️⃣ FIX: Set attributes for BOTH pages (Index & Dashboard) to prevent errors
        req.setAttribute("results", results);          // For dashboard
        req.setAttribute("query", query);              // For dashboard
        req.setAttribute("searchResults", results);    // For index
        req.setAttribute("searchQuery", query);        // For index

        // 3️⃣ FIX: Smart Routing - Go back to where the user was
        String referer = req.getHeader("referer");
        
        // If user came from the dashboard (/profile), send them back there
        if (referer != null && referer.contains("/profile")) {
            req.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(req, res);
        } 
        // Otherwise (Homepage or direct link), show on Homepage
        else {
            req.getRequestDispatcher("/WEB-INF/Pages/index.jsp").forward(req, res);
        }
    }
}