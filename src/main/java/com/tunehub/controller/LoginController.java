package com.tunehub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;
import com.tunehub.config.DBConfig;
import com.tunehub.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String id = req.getParameter("identifier") != null ? req.getParameter("identifier").trim() : "";
        String pwd = req.getParameter("password") != null ? req.getParameter("password") : "";

        if (id.isEmpty() || pwd.isEmpty()) {
            req.setAttribute("error", "Please enter username/email and password.");
            req.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(req, res);
            return;
        }

        Connection conn = null;
        try {
            conn = DBConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE username=? OR email=?");
            ps.setString(1, id);
            ps.setString(2, id);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                req.setAttribute("error", "User not found.");
                req.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(req, res);
                return;
            }

            User u = new User();
            u.setId(rs.getInt("user_id"));
            u.setUsername(rs.getString("username"));
            u.setEmail(rs.getString("email"));
            u.setPasswordHash(rs.getString("password"));
            u.setRole(rs.getString("role"));
            u.setFailedAttempts(rs.getInt("failed_attempts"));
            u.setLockedUntil(rs.getTimestamp("locked_until"));

            // 🔒 Check account lockout
            if (u.getLockedUntil() != null && new Date().before(u.getLockedUntil())) {
                req.setAttribute("error", "Account locked. Try again later.");
                req.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(req, res);
                return;
            }

            // ✅ Plain text password comparison
            if (pwd.equals(u.getPasswordHash())) {
                PreparedStatement reset = conn.prepareStatement("UPDATE users SET failed_attempts=0, locked_until=NULL WHERE user_id=?");
                reset.setInt(1, u.getId());
                reset.executeUpdate();

                HttpSession session = req.getSession(true);
                session.setAttribute("user", u);
                session.setMaxInactiveInterval(1800); // 30 mins

                if ("admin".equals(u.getRole())) {
                    res.sendRedirect(req.getContextPath() + "/admin");
                } else {
                    res.sendRedirect(req.getContextPath() + "/profile");
                }
            } else {
                int attempts = u.getFailedAttempts() + 1;
                Timestamp lockTime = (attempts >= 3) ? new Timestamp(System.currentTimeMillis() + 15 * 60 * 1000) : null;
                
                PreparedStatement update = conn.prepareStatement("UPDATE users SET failed_attempts=?, locked_until=? WHERE user_id=?");
                update.setInt(1, attempts);
                update.setTimestamp(2, lockTime);
                update.setInt(3, u.getId());
                update.executeUpdate();

                req.setAttribute("error", lockTime != null ? "Too many attempts. Locked for 15 mins." : "Invalid password. " + (3 - attempts) + " tries left.");
                req.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(req, res);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "System error: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(req, res);
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User u = (User) session.getAttribute("user");
            res.sendRedirect("admin".equals(u.getRole()) ? req.getContextPath() + "/admin" : req.getContextPath() + "/profile");
        } else {
            req.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(req, res);
        }
    }
}