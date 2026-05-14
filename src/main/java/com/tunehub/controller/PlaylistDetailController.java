package com.tunehub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.tunehub.config.DBConfig;
import com.tunehub.model.Song;
import com.tunehub.model.Playlist;
import com.tunehub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/playlist/detail")
public class PlaylistDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User currentUser = (User) session.getAttribute("user");

        int playlistId;
        try { playlistId = Integer.parseInt(request.getParameter("id")); } 
        catch (Exception e) { response.sendRedirect(request.getContextPath() + "/profile"); return; }

        Connection conn = null;
        PreparedStatement psPls = null, psSongs = null;
        ResultSet rsPls = null, rsSongs = null;

        try {
            conn = DBConfig.getConnection();

            // 1️⃣ Fetch playlist details
            psPls = conn.prepareStatement(
                "SELECT p.playlist_id, p.name, p.description, p.user_id, p.is_public, " +
                "COUNT(ps.song_id) as song_count, u.username as owner_name " +
                "FROM playlists p JOIN users u ON p.user_id = u.user_id " +
                "LEFT JOIN playlist_songs ps ON p.playlist_id = ps.playlist_id " +
                "WHERE p.playlist_id = ? GROUP BY p.playlist_id"
            );
            psPls.setInt(1, playlistId);
            rsPls = psPls.executeQuery();

            if (!rsPls.next()) {
                request.setAttribute("error", "Playlist not found.");
                request.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(request, response);
                return;
            }

            Playlist pl = new Playlist();
            pl.setId(rsPls.getInt("playlist_id"));
            pl.setName(rsPls.getString("name"));
            pl.setDescription(rsPls.getString("description"));
            pl.setUserId(rsPls.getInt("user_id"));
            pl.setPublic(rsPls.getBoolean("is_public"));
            pl.setSongCount(rsPls.getInt("song_count")); // ✅ Now works with updated model
            pl.setCreatorName(rsPls.getString("owner_name")); // ✅ Now works

            // 🔒 Access control: FIXED int comparison (no .equals())
            int currentUserId = currentUser.getId();
            int playlistOwnerId = pl.getUserId();
            boolean isOwner = (currentUserId == playlistOwnerId);
            boolean isAdmin = "admin".equals(currentUser.getRole());
            
            if (!pl.isPublic() && !isOwner && !isAdmin) {
                response.sendRedirect(request.getContextPath() + "/profile?error=Unauthorized");
                return;
            }

            // 2️⃣ Fetch songs in this playlist
            List<Song> playlistSongs = new ArrayList<>();
            psSongs = conn.prepareStatement(
                "SELECT s.id, s.title, s.artist, s.album, s.file_path, s.duration " +
                "FROM playlist_songs ps JOIN songs s ON ps.song_id = s.id " +
                "WHERE ps.playlist_id = ? ORDER BY ps.added_at DESC"
            );
            psSongs.setInt(1, playlistId);
            rsSongs = psSongs.executeQuery();
            while (rsSongs.next()) {
                Song s = new Song();
                s.setId(rsSongs.getInt("id"));
                s.setTitle(rsSongs.getString("title"));
                s.setArtist(rsSongs.getString("artist"));
                s.setAlbum(rsSongs.getString("album"));
                s.setFilePath(rsSongs.getString("file_path"));
                s.setDuration(rsSongs.getInt("duration"));
                playlistSongs.add(s);
            }

            // ✅ Pass clean data to JSP
            request.setAttribute("playlist", pl);
            request.setAttribute("playlistSongs", playlistSongs);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/WEB-INF/Pages/playlist-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load playlist: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(request, response);
        } finally {
            if(rsSongs!=null)try{rsSongs.close();}catch(Exception i){}
            if(rsPls!=null)try{rsPls.close();}catch(Exception i){}
            if(psSongs!=null)try{psSongs.close();}catch(Exception i){}
            if(psPls!=null)try{psPls.close();}catch(Exception i){}
            if(conn!=null)try{conn.close();}catch(Exception i){}
        }
    }
}