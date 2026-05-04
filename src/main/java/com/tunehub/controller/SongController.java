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
 * Servlet implementation class SongController
 */
@WebServlet("/SongController ")
public class SongController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String title = request.getParameter("title");
        String artist = request.getParameter("artist");

        try {
            Connection con = DBConfig.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO songs(title, artist) VALUES(?,?)"
            );

            ps.setString(1, title);
            ps.setString(2, artist);

            ps.executeUpdate();

            response.sendRedirect("songs.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}


