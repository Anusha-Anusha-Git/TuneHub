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
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String q = req.getParameter("q");
        
        if (q == null || q.trim().isEmpty()) {
            // ✅ Stay on current page, don't redirect
            req.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(req, res);
            return;
        }

        String query = q.trim();
        List<Song> results = new ArrayList<>();
        Connection c = null; PreparedStatement ps = null; ResultSet rs = null;

        try {
            c = DBConfig.getConnection();
            ps = c.prepareStatement("SELECT id, title, artist, album, file_path FROM songs WHERE title LIKE ? OR artist LIKE ?");
            ps.setString(1, "%"+query+"%");
            ps.setString(2, "%"+query+"%");
            rs = ps.executeQuery();
            while(rs.next()) {
                Song s = new Song();
                s.setId(rs.getInt("id")); s.setTitle(rs.getString("title"));
                s.setArtist(rs.getString("artist")); s.setAlbum(rs.getString("album"));
                s.setFilePath(rs.getString("file_path"));
                results.add(s);
            }
            
            req.setAttribute("results", results);
            req.setAttribute("query", query);
            // ✅ Forward to dashboard with search mode
            req.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(req, res);
        } finally {
            try { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(c!=null) c.close(); } catch(Exception ignored){}
        }
    }
}