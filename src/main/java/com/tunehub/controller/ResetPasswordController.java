package com.tunehub.controller;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.tunehub.config.DBConfig;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/Pages/reset.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Please enter your email.");
            doGet(req, res);
            return;
        }

        try (Connection conn = DBConfig.getConnection()) {
            PreparedStatement check = conn.prepareStatement("SELECT * FROM users WHERE email=?");
            check.setString(1, email.trim());
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                // Generate simple 6-char alphanumeric token
                String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
                SecureRandom rnd = new SecureRandom();
                StringBuilder token = new StringBuilder(6);
                for (int i = 0; i < 6; i++) {
                    token.append(chars.charAt(rnd.nextInt(chars.length())));
                }
                String tokenStr = token.toString();

                PreparedStatement update = conn.prepareStatement("UPDATE users SET reset_token=? WHERE email=?");
                update.setString(1, tokenStr);
                update.setString(2, email.trim());
                update.executeUpdate();

                req.setAttribute("success", "Reset token generated: " + tokenStr + " (Demo: use this to reset)");
            } else {
                req.setAttribute("error", "Email not found in our records.");
            }
            req.getRequestDispatcher("/WEB-INF/Pages/reset.jsp").forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "System error: " + e.getMessage());
            doGet(req, res);
        }
    }
}