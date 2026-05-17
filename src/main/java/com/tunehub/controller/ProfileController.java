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
import com.tunehub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean isAuthenticated(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if (!isAuthenticated(req, res)) {
            return;
        }

        String action = req.getParameter("action");

        if ("edit".equals(action)) {
            req.setAttribute("user", req.getSession().getAttribute("user"));
            req.getRequestDispatcher("/WEB-INF/Pages/profile.jsp")
               .forward(req, res);
            return;
        }

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        Connection connection = null;

        try {
            connection = DBConfig.getConnection();

            // Load User Playlists
            List<Playlist> playlists = new ArrayList<>();

            String playlistQuery =
                    "SELECT playlist_id, name, description, is_public " +
                    "FROM playlists " +
                    "WHERE user_id = ? " +
                    "ORDER BY created_at DESC";

            PreparedStatement playlistStmt =
                    connection.prepareStatement(playlistQuery);

            playlistStmt.setInt(1, user.getId());

            ResultSet playlistRs = playlistStmt.executeQuery();

            while (playlistRs.next()) {
                Playlist playlist = new Playlist();

                playlist.setId(playlistRs.getInt("playlist_id"));
                playlist.setName(playlistRs.getString("name"));
                playlist.setDescription(playlistRs.getString("description"));
                playlist.setPublic(playlistRs.getBoolean("is_public"));

                playlists.add(playlist);
            }

            playlistRs.close();
            playlistStmt.close();

            // Load Songs
            List<Song> songs = new ArrayList<>();

            String songQuery =
                    "SELECT id, title, artist, album, file_path " +
                    "FROM songs " +
                    "ORDER BY created_at DESC";

            PreparedStatement songStmt =
                    connection.prepareStatement(songQuery);

            ResultSet songRs = songStmt.executeQuery();

            while (songRs.next()) {
                Song song = new Song();

                song.setId(songRs.getInt("id"));
                song.setTitle(songRs.getString("title"));
                song.setArtist(songRs.getString("artist"));
                song.setAlbum(songRs.getString("album"));
                song.setFilePath(songRs.getString("file_path"));

                songs.add(song);
            }

            songRs.close();
            songStmt.close();

            req.setAttribute("user", user);
            req.setAttribute("userPlaylists", playlists);
            req.setAttribute("userSongs", songs);

            req.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp")
               .forward(req, res);

        } catch (Exception e) {

            req.setAttribute("error", "Load failed");

            req.getRequestDispatcher("/WEB-INF/Pages/dashboard-user.jsp")
               .forward(req, res);

        } finally {

            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (Exception ignored) {
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if (!isAuthenticated(req, res)) {
            return;
        }

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        String action = req.getParameter("action");

        // Update Profile
        if ("updateProfile".equals(action)) {

            String username = req.getParameter("username").trim();
            String email = req.getParameter("email").trim();

            boolean invalidUsername =
                    username.length() < 3 ||
                    !username.matches("^[a-zA-Z0-9_]{3,20}$");

            boolean invalidEmail =
                    !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");

            if (invalidUsername || invalidEmail) {

                res.sendRedirect(
                        req.getContextPath()
                        + "/profile?action=edit&error=Invalid username/email format"
                );

                return;
            }

            Connection connection = null;
            PreparedStatement statement = null;

            try {
                connection = DBConfig.getConnection();

                String checkQuery =
                        "SELECT 1 FROM users " +
                        "WHERE (username=? OR email=?) AND user_id!=?";

                PreparedStatement checkStmt =
                        connection.prepareStatement(checkQuery);

                checkStmt.setString(1, username);
                checkStmt.setString(2, email);
                checkStmt.setInt(3, user.getId());

                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {

                    res.sendRedirect(
                            req.getContextPath()
                            + "/profile?action=edit&error=Username/Email taken"
                    );

                    rs.close();
                    checkStmt.close();
                    return;
                }

                rs.close();
                checkStmt.close();

                String updateQuery =
                        "UPDATE users SET username=?, email=? WHERE user_id=?";

                statement = connection.prepareStatement(updateQuery);

                statement.setString(1, username);
                statement.setString(2, email);
                statement.setInt(3, user.getId());

                statement.executeUpdate();

                user.setUsername(username);
                user.setEmail(email);

                session.setAttribute("user", user);

                res.sendRedirect(
                        req.getContextPath()
                        + "/profile?action=edit&success=Profile updated"
                );

            } catch (Exception e) {

                res.sendRedirect(
                        req.getContextPath()
                        + "/profile?action=edit&error=Update failed"
                );

            } finally {

                try {
                    if (statement != null) {
                        statement.close();
                    }

                    if (connection != null) {
                        connection.close();
                    }

                } catch (Exception ignored) {
                }
            }

        }

        // Change Password
        else if ("changePassword".equals(action)) {

            String currentPassword =
                    req.getParameter("current_password");

            String newPassword =
                    req.getParameter("new_password");

            String confirmPassword =
                    req.getParameter("confirm_password");

            boolean invalidPassword =
                    currentPassword == null ||
                    newPassword == null ||
                    confirmPassword == null ||
                    !currentPassword.equals(user.getPasswordHash()) ||
                    newPassword.length() < 6 ||
                    !newPassword.equals(confirmPassword);

            if (invalidPassword) {

                res.sendRedirect(
                        req.getContextPath()
                        + "/profile?action=edit&error=Invalid password details"
                );

                return;
            }

            Connection connection = null;
            PreparedStatement statement = null;

            try {
                connection = DBConfig.getConnection();

                String updatePasswordQuery =
                        "UPDATE users SET password=? WHERE user_id=?";

                statement =
                        connection.prepareStatement(updatePasswordQuery);

                statement.setString(1, newPassword);
                statement.setInt(2, user.getId());

                statement.executeUpdate();

                user.setPasswordHash(newPassword);

                session.setAttribute("user", user);

                res.sendRedirect(
                        req.getContextPath()
                        + "/profile?action=edit&success=Password changed"
                );

            } catch (Exception e) {

                res.sendRedirect(
                        req.getContextPath()
                        + "/profile?action=edit&error=Password update failed"
                );

            } finally {

                try {
                    if (statement != null) {
                        statement.close();
                    }

                    if (connection != null) {
                        connection.close();
                    }

                } catch (Exception ignored) {
                }
            }

        } else {

            doGet(req, res);
        }
    }
}