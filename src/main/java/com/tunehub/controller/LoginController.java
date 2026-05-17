package com.tunehub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;

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

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String identifier =
                req.getParameter("identifier") != null
                ? req.getParameter("identifier").trim()
                : "";

        String password =
                req.getParameter("password") != null
                ? req.getParameter("password")
                : "";

        // Validation
        if (identifier.isEmpty() || password.isEmpty()) {

            req.setAttribute(
                    "error",
                    "Please enter username/email and password."
            );

            req.getRequestDispatcher("/WEB-INF/Pages/login.jsp")
               .forward(req, res);

            return;
        }

        try (Connection connection = DBConfig.getConnection()) {

            // Find User
            String query =
                    "SELECT * FROM users " +
                    "WHERE username=? OR email=?";

            PreparedStatement statement =
                    connection.prepareStatement(query);

            statement.setString(1, identifier);
            statement.setString(2, identifier);

            ResultSet result = statement.executeQuery();

            // User Not Found
            if (!result.next()) {

                req.setAttribute("error", "User not found.");

                req.getRequestDispatcher("/WEB-INF/Pages/login.jsp")
                   .forward(req, res);

                return;
            }

            // Create User Object
            User user = new User();

            user.setId(result.getInt("user_id"));
            user.setUsername(result.getString("username"));
            user.setEmail(result.getString("email"));
            user.setPasswordHash(result.getString("password"));
            user.setRole(result.getString("role"));
            user.setFailedAttempts(result.getInt("failed_attempts"));
            user.setLockedUntil(result.getTimestamp("locked_until"));

            // Check Account Lock
            if (user.getLockedUntil() != null
                    && new Date().before(user.getLockedUntil())) {

                req.setAttribute(
                        "error",
                        "Account locked. Try again later."
                );

                req.getRequestDispatcher("/WEB-INF/Pages/login.jsp")
                   .forward(req, res);

                return;
            }

            // Password Match
            if (password.equals(user.getPasswordHash())) {

                String resetQuery =
                        "UPDATE users " +
                        "SET failed_attempts=0, locked_until=NULL " +
                        "WHERE user_id=?";

                PreparedStatement resetStatement =
                        connection.prepareStatement(resetQuery);

                resetStatement.setInt(1, user.getId());

                resetStatement.executeUpdate();

                HttpSession session = req.getSession(true);

                session.setAttribute("user", user);

                // 30 minutes
                session.setMaxInactiveInterval(1800);

                // Redirect Based on Role
                if ("admin".equals(user.getRole())) {

                    res.sendRedirect(
                            req.getContextPath() + "/admin"
                    );

                } else {

                    res.sendRedirect(
                            req.getContextPath() + "/profile"
                    );
                }

            }

            // Invalid Password
            else {

                int attempts = user.getFailedAttempts() + 1;

                Timestamp lockUntil = null;

                if (attempts >= 3) {

                    lockUntil = new Timestamp(
                            System.currentTimeMillis()
                            + (15 * 60 * 1000)
                    );
                }

                String updateQuery =
                        "UPDATE users " +
                        "SET failed_attempts=?, locked_until=? " +
                        "WHERE user_id=?";

                PreparedStatement updateStatement =
                        connection.prepareStatement(updateQuery);

                updateStatement.setInt(1, attempts);
                updateStatement.setTimestamp(2, lockUntil);
                updateStatement.setInt(3, user.getId());

                updateStatement.executeUpdate();

                String errorMessage;

                if (lockUntil != null) {

                    errorMessage =
                            "Too many attempts. Locked for 15 mins.";

                } else {

                    errorMessage =
                            "Invalid password. "
                            + (3 - attempts)
                            + " tries left.";
                }

                req.setAttribute("error", errorMessage);

                req.getRequestDispatcher("/WEB-INF/Pages/login.jsp")
                   .forward(req, res);
            }

        } catch (Exception e) {

            req.setAttribute("error", "System error");

            req.getRequestDispatcher("/WEB-INF/Pages/login.jsp")
               .forward(req, res);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session != null
                && session.getAttribute("user") != null) {

            User user = (User) session.getAttribute("user");

            if ("admin".equals(user.getRole())) {

                res.sendRedirect(
                        req.getContextPath() + "/admin"
                );

            } else {

                res.sendRedirect(
                        req.getContextPath() + "/profile"
                );
            }

        } else {

            req.getRequestDispatcher("/WEB-INF/Pages/login.jsp")
               .forward(req, res);
        }
    }
}