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

@WebServlet("/admin")
public class AdminController extends HttpServlet {

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=Please login first");
            return false;
        }
        User u = (User) session.getAttribute("user");
        if (!"admin".equals(u.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=Unauthorized");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdmin(request, response)) return;

        String action = request.getParameter("action");
        
        try (Connection conn = DBConfig.getConnection()) {
            if ("deleteUser".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id = ?");
                ps.setInt(1, id);
                ps.executeUpdate();
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }
            if ("deleteSong".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement ps = conn.prepareStatement("DELETE FROM songs WHERE id = ?");
                ps.setInt(1, id);
                ps.executeUpdate();
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }

            List<User> users = new ArrayList<>();
            PreparedStatement ps1 = conn.prepareStatement(
                "SELECT id, username, email, role, created_at FROM users ORDER BY created_at DESC");
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                User u = new User();
                u.setId(rs1.getInt("id"));
                u.setUsername(rs1.getString("username"));
                u.setEmail(rs1.getString("email"));
                u.setRole(rs1.getString("role"));
                u.setCreatedAt(rs1.getTimestamp("created_at"));
                users.add(u);
            }

            List<Song> songs = new ArrayList<>();
            PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM songs ORDER BY created_at DESC");
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                Song s = new Song();
                s.setId(rs2.getInt("id"));
                s.setTitle(rs2.getString("title"));
                s.setArtist(rs2.getString("artist"));
                s.setAlbum(rs2.getString("album"));
                s.setDuration(rs2.getInt("duration"));
                s.setFilePath(rs2.getString("file_path"));
                s.setUploadedBy(rs2.getInt("uploaded_by"));
                s.setCreatedAt(rs2.getTimestamp("created_at"));
                songs.add(s);
            }

            request.setAttribute("users", users);
            request.setAttribute("songs", songs);
            request.getRequestDispatcher("/WEB-INF/Pages/dashboard-admin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard");
            request.getRequestDispatcher("/WEB-INF/Pages/dashboard-admin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}