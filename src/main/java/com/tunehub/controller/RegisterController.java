package com.tunehub.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.tunehub.config.DBConfig;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String u = req.getParameter("username") != null ? req.getParameter("username").trim() : "";
        String e = req.getParameter("email") != null ? req.getParameter("email").trim() : "";
        String p = req.getParameter("password") != null ? req.getParameter("password") : "";
        String c = req.getParameter("confirm") != null ? req.getParameter("confirm") : "";
        String r = req.getParameter("role");

        // ✅ Validation
        if(u.length() < 3 || !u.matches("^[a-zA-Z0-9_]+$")) {
            fwd(req,res,u,e,"Username: 3+ alphanumeric chars only."); return;
        }
        if(e.isEmpty() || !e.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            fwd(req,res,u,e,"Invalid email format."); return;
        }
        if(p.length() < 6 || !p.equals(c)) {
            fwd(req,res,u,e,"Password must be 6+ chars and match."); return;
        }
        if(r == null || (!r.equals("user") && !r.equals("admin"))) {
            fwd(req,res,u,e,"Invalid role selection."); return;
        }

        try(Connection conn = DBConfig.getConnection()) {
            PreparedStatement chk = conn.prepareStatement("SELECT 1 FROM users WHERE username=? OR email=?");
            chk.setString(1, u); chk.setString(2, e);
            if(chk.executeQuery().next()) { fwd(req,res,u,e,"Username or Email already exists."); return; }

            // ✅ Store plain text password
            PreparedStatement ins = conn.prepareStatement("INSERT INTO users(username,email,password,role,failed_attempts,locked_until) VALUES(?,?,?,?,0,NULL)");
            ins.setString(1, u); ins.setString(2, e); ins.setString(3, p); ins.setString(4, r);
            if(ins.executeUpdate()>0) res.sendRedirect(req.getContextPath()+"/login?msg=Registration successful");
            else fwd(req,res,u,e,"Registration failed.");
        } catch(Exception ex) { fwd(req,res,u,e,"Database error."); }
    }

    private void fwd(HttpServletRequest r, HttpServletResponse s, String u, String e, String err) throws ServletException, IOException {
        r.setAttribute("error",err); r.setAttribute("username",u); r.setAttribute("email",e);
        r.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(r,s);
    }

    @Override protected void doGet(HttpServletRequest r, HttpServletResponse s) throws ServletException, IOException {
        r.getRequestDispatcher("/WEB-INF/Pages/register.jsp").forward(r,s);
    }
}