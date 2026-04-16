package com.tunehub.controller;

import jakarta.servlet.RequestDispatcher;
import com.tunehub.config.DBConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

/**
 * Servlet implementation class DashboardController
 */
@WebServlet("/DashboardController")
public class DashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DashboardController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession(false);

        // BUG FIX: check session properly before doing anything
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("LoginController");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection con = DBConfig.getConnection()) {

            // BUG FIX: collect results into a List<Map> BEFORE forwarding to JSP
            // (ResultSet closes when connection closes — JSP can't use it directly)
            String sql = "SELECT * FROM songs WHERE user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            List<Map<String, String>> songs = new ArrayList<>();
            while (rs.next()) {
                Map<String, String> song = new LinkedHashMap<>();
                song.put("id",       String.valueOf(rs.getInt("id")));
                song.put("title",    rs.getString("title"));
                song.put("artist",   rs.getString("artist"));
                song.put("album",    rs.getString("album"));
                song.put("genre",    rs.getString("genre"));
                song.put("duration", String.valueOf(rs.getInt("duration")));
                songs.add(song);
            }

            request.setAttribute("songs",     songs);
            request.setAttribute("songCount", songs.size());

            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/Pages/dashboard.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Could not load your library. Please try again.");
            request.getRequestDispatcher("/WEB-INF/Pages/dashboard.jsp").forward(request, response);
        }
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
