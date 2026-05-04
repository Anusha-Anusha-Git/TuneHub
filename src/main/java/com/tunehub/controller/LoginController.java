package com.tunehub.controller;

import java.io.IOException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;

import com.tunehub.config.DBConfig;
import com.tunehub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static String hashPassword(String password, String salt) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt.getBytes());
        byte[] hashed = md.digest(password.getBytes());
        return Base64.getEncoder().encodeToString(hashed);
    }

    private static String sanitize(String s) {
        return s == null ? "" : s.trim().replaceAll("[<>\"'&]", "");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String identifier = sanitize(request.getParameter("identifier"));
        String password = request.getParameter("password");

        if (identifier.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Please fill in all fields");
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConfig.getConnection()) {
            String sql = "SELECT * FROM users WHERE (username = ? OR email = ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, identifier);
            ps.setString(2, identifier);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setSalt(rs.getString("salt"));
                user.setRole(rs.getString("role"));
                user.setFailedLoginAttempts(rs.getInt("failed_login_attempts"));
                user.setLocked(rs.getBoolean("locked"));

                if (user.isLocked()) {
                    request.setAttribute("error", "Account locked. Contact administrator.");
                    request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
                    return;
                }

                String inputHash = hashPassword(password, user.getSalt());
                if (inputHash.equals(user.getPasswordHash())) {
                    PreparedStatement reset = conn.prepareStatement(
                        "UPDATE users SET failed_login_attempts = 0, locked = false WHERE id = ?");
                    reset.setInt(1, user.getId());
                    reset.executeUpdate();

                    HttpSession session = request.getSession(true);
                    session.setAttribute("user", user);
                    session.setMaxInactiveInterval(30 * 60);

                    if ("admin".equals(user.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/admin");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/profile");
                    }
                } else {
                    int attempts = user.getFailedLoginAttempts() + 1;
                    boolean lock = attempts >= 3;
                    PreparedStatement update = conn.prepareStatement(
                        "UPDATE users SET failed_login_attempts = ?, locked = ? WHERE id = ?");
                    update.setInt(1, attempts);
                    update.setBoolean(2, lock);
                    update.setInt(3, user.getId());
                    update.executeUpdate();

                    String msg = "Invalid credentials. ";
                    msg += lock ? "Account locked. Contact administrator." : (3 - attempts) + " attempts remaining";
                    request.setAttribute("error", msg);
                    request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "User not found");
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Please try again.");
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User u = (User) session.getAttribute("user");
            String path = "admin".equals(u.getRole()) ? "/admin" : "/profile";
            response.sendRedirect(request.getContextPath() + path);
            return;
        }
        request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
    }
}