package com.tunehub.controller;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.util.*;

import com.tunehub.config.DBConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.ResultSet;

/**
 * Servlet implementation class AdminController
 */
@WebServlet("/AdminController")
public class AdminController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("LoginController");
            return;
        }

        try (Connection con = DBConfig.getConnection()) {

            // Collect users
            List<Map<String,String>> users = new ArrayList<>();
            ResultSet rsU = con.createStatement().executeQuery("SELECT * FROM users");
            while (rsU.next()) {
                Map<String,String> u = new LinkedHashMap<>();
                u.put("id",    String.valueOf(rsU.getInt("id")));
                u.put("name",  rsU.getString("name"));
                u.put("email", rsU.getString("email"));
                u.put("role",  rsU.getString("role"));
                users.add(u);
            }

            // Collect songs
            List<Map<String,String>> songs = new ArrayList<>();
            ResultSet rsS = con.createStatement().executeQuery("SELECT * FROM songs");
            while (rsS.next()) {
                Map<String,String> s = new LinkedHashMap<>();
                s.put("id",     String.valueOf(rsS.getInt("id")));
                s.put("title",  rsS.getString("title"));
                s.put("artist", rsS.getString("artist"));
                s.put("genre",  rsS.getString("genre"));
                songs.add(s);
            }

            request.setAttribute("users", users);
            request.setAttribute("songs", songs);

            // BUG FIX: use capital "Pages" to match actual folder name
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/Pages/admin.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Something went wrong. Please contact the administrator.");
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
