package com.tunehub.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.tunehub.config.DBConfig;

@WebServlet("/DeleteSongController")
public class DeleteSongController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            Connection con = DBConfig.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM songs WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
            response.sendRedirect("songs.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}