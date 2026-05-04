<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*,java.util.*" %>
<%
    User cu = (User) session.getAttribute("user");
    if (cu == null) {
        response.sendRedirect(request.getContextPath() + "/login?error=Please login first");
        return;
    }
    List<Song> us = (List<Song>) request.getAttribute("userSongs");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Dashboard - TuneHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
</head>
<body>
    <header>
        <div class="nav-c">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/profile">Profile</a>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </nav>
        </div>
    </header>
    <div class="container">
        <h2>👋 Welcome, <%= cu.getUsername() %>!</h2>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-e"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-o"><%= request.getAttribute("success") %></div>
        <% } %>
        <div class="dash">
            <div class="card">
                <h3>👤 My Profile</h3>
                <p><b>Username:</b> <%= cu.getUsername() %></p>
                <p><b>Email:</b> <%= cu.getEmail() %></p>
                <p><b>Member since:</b> <%= cu.getCreatedAt() != null ? cu.getCreatedAt().toString().substring(0,10) : "N/A" %></p>
                <a href="${pageContext.request.contextPath}/profile?action=edit" class="btn btn-s mt1">Edit Profile</a>
            </div>
            <div class="card">
                <h3>🎵 My Songs (<%= us != null ? us.size() : 0 %>)</h3>
                <% if (us != null && !us.isEmpty()) { 
                    for (Song s : us) { %>
                <div style="padding:.75rem 0;border-bottom:1px solid var(--lav-l)">
                    <b><%= s.getTitle() %></b><br><small style="color:#666"><%= s.getArtist() %></small>
                </div>
                <% } } else { %>
                <p style="color:#666">No songs yet.</p>
                <% } %>
                <a href="#" class="btn mt1">+ Add Song</a>
            </div>
            <div class="card">
                <h3>⚡ Quick Links</h3>
                <div style="display:flex;flex-direction:column;gap:.5rem">
                    <a href="${pageContext.request.contextPath}/about" class="btn btn-s">About</a>
                    <a href="${pageContext.request.contextPath}/contact" class="btn btn-s">Contact</a>
                </div>
            </div>
        </div>
    </div>
    <footer><p>&copy; 2026 TuneHub</p></footer>
</body>
</html>