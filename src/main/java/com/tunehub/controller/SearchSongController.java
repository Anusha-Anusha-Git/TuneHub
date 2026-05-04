package com.tunehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.tunehub.config.DBConfig;

/**
 * Servlet implementation class SearchSongController
 */
@WebServlet("/SearchSongController")
public class SearchSongController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String keyword = request.getParameter("keyword");

        try {
            Connection con = DBConfig.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM songs WHERE title LIKE ?"
            );

            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            request.setAttribute("songs", rs);
            request.getRequestDispatcher("songs.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}