package com.tunehub.controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import com.tunehub.model.User;

@WebFilter("/*")
public class AuthFilter implements Filter {
    public void init(FilterConfig config) {}
    public void destroy() {}

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        String path = request.getRequestURI().substring(request.getContextPath().length());

        // Allow public pages & auth endpoints
        boolean isPublic = path.equals("/") || path.equals("/index") || path.equals("/login") || 
                           path.equals("/register") || path.equals("/reset-password") || 
                           path.startsWith("/css/") || path.startsWith("/js/");
        
        if (isPublic) { chain.doFilter(req, res); return; }

        // Check session
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?msg=Please log in");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = user.getRole();

        // Role-based redirect protection
        if (path.startsWith("/admin") && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/profile?error=Unauthorized");
            return;
        }
        if (path.startsWith("/profile") && "admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }

        // Session activity refresh
        session.setAttribute("user", user);
        chain.doFilter(req, res);
    }
}