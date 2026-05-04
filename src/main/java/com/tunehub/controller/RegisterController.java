package com.tunehub.controller;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;

import com.tunehub.config.DBConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static String hashPassword(String password, String salt) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt.getBytes());
        return Base64.getEncoder().encodeToString(md.digest(password.getBytes()));
    }

    private static String generateSalt() {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    private static boolean isValidEmail(String e) {
        return e != null && e.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    private static boolean isValidUsername(String u) {
        return u != null && u.matches("^[a-zA-Z0-9_]{3,20}$");
    }

    private static String sanitize(String s) {
        return s == null ? "" : s.trim().replaceAll("[<>\"'&]", "");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = sanitize(request.getParameter("username"));
        String email = sanitize(request.getParameter("email"));
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        if (!isValidUsername(username)) {
            request.setAttribute("error", "Username: 3-20 alphanumeric characters");
            forwardWithInput(request, response, username, email);
            return;
        }
        if (!isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email");
            forwardWithInput(request, response, username, email);
            return;
        }
        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            forwardWithInput(request, response, username, email);
            return;
        }
        if (!password.equals(confirm)) {
            request.setAttribute("error", "Passwords do not match");
            forwardWithInput(request, response, username, email);
            return;
        }

        try (Connection conn = DBConfig.getConnection()) {
            if (exists(conn, "username", username) || exists(conn, "email", email)) {
                request.setAttribute("error", "Username or email already taken");
                forwardWithInput(request, response, username, email);
                return;
            }

            String salt = generateSalt();
            String hash = hashPassword(password, salt);

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO users (username, email, password_hash, salt, role, created_at) VALUES (?, ?, ?, ?, 'user', NOW())");
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, hash);
            ps.setString(4, salt);

            if (ps.executeUpdate() > 0) {
                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed");
                forwardWithInput(request, response, username, email);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed. Please try again.");
            forwardWithInput(request, response, username, email);
        }
    }

    private boolean exists(Connection conn, String col, String val) throws Exception {
        PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE " + col + " = ?");
        ps.setString(1, val);
        ResultSet rs = ps.executeQuery();
        return rs.next() && rs.getInt(1) > 0;
    }

    private void forwardWithInput(HttpServletRequest request, HttpServletResponse response, String u, String e) 
            throws ServletException, IOException {
        request.setAttribute("username", u);
        request.setAttribute("email", e);
        request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(request, response);
    }
}