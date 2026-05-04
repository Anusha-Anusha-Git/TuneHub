package com.tunehub.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.tunehub.config.DBConfig;

/**
 * Servlet implementation class PlaylistController
 */
@WebServlet("/PlaylistController")
public class PlaylistController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String name = request.getParameter("name");

        try {
            Connection con = DBConfig.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO playlist(name) VALUES(?)"
            );

            ps.setString(1, name);
            ps.executeUpdate();

            response.sendRedirect("playlist.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}