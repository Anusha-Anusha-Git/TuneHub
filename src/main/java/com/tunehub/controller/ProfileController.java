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
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    private boolean isAuthenticated(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=Please login first");
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
        
        if (!isAuthenticated(request, response)) return;

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/WEB-INF/Pages/profile.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConfig.getConnection()) {
            List<Song> mySongs = new ArrayList<>();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM songs WHERE uploaded_by = ? ORDER BY created_at DESC");
            ps.setInt(1, currentUser.getId());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Song s = new Song();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setArtist(rs.getString("artist"));
                s.setAlbum(rs.getString("album"));
                s.setDuration(rs.getInt("duration"));
                s.setFilePath(rs.getString("file_path"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                mySongs.add(s);
            }
            request.setAttribute("userSongs", mySongs);
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load profile");
            request.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAuthenticated(request, response)) return;

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        String username = sanitize(request.getParameter("username"));
        String email = sanitize(request.getParameter("email"));

        if (username.isEmpty() || email.isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/WEB-INF/Pages/profile.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConfig.getConnection()) {
            PreparedStatement check = conn.prepareStatement(
                "SELECT COUNT(*) FROM users WHERE (username = ? OR email = ?) AND id != ?");
            check.setString(1, username);
            check.setString(2, email);
            check.setInt(3, currentUser.getId());
            ResultSet rs = check.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                request.setAttribute("error", "Username or email already taken");
                request.setAttribute("user", currentUser);
                request.getRequestDispatcher("/WEB-INF/Pages/profile.jsp").forward(request, response);
                return;
            }

            PreparedStatement update = conn.prepareStatement(
                "UPDATE users SET username = ?, email = ? WHERE id = ?");
            update.setString(1, username);
            update.setString(2, email);
            update.setInt(3, currentUser.getId());

            if (update.executeUpdate() > 0) {
                currentUser.setUsername(username);
                currentUser.setEmail(email);
                session.setAttribute("user", currentUser);
                request.setAttribute("success", "Profile updated!");
                request.setAttribute("user", currentUser);
                request.getRequestDispatcher("/WEB-INF/Pages/profile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update profile");
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/WEB-INF/Pages/profile.jsp").forward(request, response);
        }
    }
}