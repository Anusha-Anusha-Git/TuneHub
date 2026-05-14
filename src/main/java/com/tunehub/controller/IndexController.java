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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet({"/", "/index", "/home", "/about", "/contact"})
public class IndexController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        if ("/about".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/Pages/about.jsp").forward(request, response);
            return;
        }
        if ("/contact".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/Pages/contact.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        try {
            conn = DBConfig.getConnection();
            
            // ✅ SAFELY FETCH PUBLIC PLAYLISTS
            List<Playlist> publicPlaylists = new ArrayList<>();
            try {
                PreparedStatement plsPs = conn.prepareStatement(
                    "SELECT playlist_id, name, description, user_id FROM playlists WHERE is_public = 1 ORDER BY created_at DESC LIMIT 6"
                );
                ResultSet rs = plsPs.executeQuery();
                while (rs.next()) {
                    Playlist p = new Playlist();
                    p.setId(rs.getInt("playlist_id"));
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setUserId(rs.getInt("user_id"));
                    publicPlaylists.add(p);
                }
                rs.close(); plsPs.close();
            } catch(Exception e) {
                // Fallback: fetch all playlists if column name differs
                PreparedStatement fallback = conn.prepareStatement("SELECT playlist_id, name, description, user_id FROM playlists LIMIT 6");
                ResultSet rs = fallback.executeQuery();
                while(rs.next()) {
                    Playlist p = new Playlist();
                    p.setId(rs.getInt("playlist_id")); p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description")); p.setUserId(rs.getInt("user_id"));
                    publicPlaylists.add(p);
                }
                rs.close(); fallback.close();
            }
            request.setAttribute("publicPlaylists", publicPlaylists);
            
            // Load featured songs
            List<Song> featured = new ArrayList<>();
            PreparedStatement songsPs = conn.prepareStatement("SELECT id, title, artist, album, file_path FROM songs ORDER BY created_at DESC LIMIT 6");
            ResultSet songsRs = songsPs.executeQuery();
            while (songsRs.next()) {
                Song s = new Song();
                s.setId(songsRs.getInt("id")); s.setTitle(songsRs.getString("title"));
                s.setArtist(songsRs.getString("artist")); s.setAlbum(songsRs.getString("album"));
                s.setFilePath(songsRs.getString("file_path"));
                featured.add(s);
            }
            songsRs.close(); songsPs.close();
            request.setAttribute("featuredSongs", featured);
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if(conn!=null) try { conn.close(); } catch(Exception ignored){}
        }
        
        request.getRequestDispatcher("/WEB-INF/Pages/index.jsp").forward(request, response);
    }
}