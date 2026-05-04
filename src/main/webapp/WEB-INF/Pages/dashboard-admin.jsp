<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*,java.util.*" %>
<%
    User cu = (User) session.getAttribute("user");
    if (cu == null || !"admin".equals(cu.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login?error=Unauthorized");
        return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
    List<Song> songs = (List<Song>) request.getAttribute("songs");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Admin - TuneHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
</head>
<body>
    <header>
        <div class="nav-c">
            <div class="logo">🎵 TuneHub <small>[ADMIN]</small></div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </nav>
        </div>
    </header>
    <div class="container">
        <h2>👑 Admin Dashboard</h2>
        <p>Welcome, <%= cu.getUsername() %>!</p>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-e"><%= request.getAttribute("error") %></div>
        <% } %>
        <div class="card mt2">
            <h3>👥 Users (<%= users != null ? users.size() : 0 %>)</h3>
            <div class="tc">
                <table>
                    <thead><tr><th>ID</th><th>Username</th><th>Email</th><th>Role</th><th>Actions</th></tr></thead>
                    <tbody>
                        <% if (users != null && !users.isEmpty()) { 
                            for (User u : users) { %>
                        <tr>
                            <td><%= u.getId() %></td>
                            <td><%= u.getUsername() %></td>
                            <td><%= u.getEmail() %></td>
                            <td><%= u.getRole() %></td>
                            <td>
                                <% if (!"admin".equals(u.getRole()) && u.getId() != cu.getId()) { %>
                                <form action="${pageContext.request.contextPath}/admin" method="post" style="display:inline" onsubmit="return confirm('Delete <%= u.getUsername() %>?')">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="id" value="<%= u.getId() %>">
                                    <button type="submit" class="btn btn-d" style="padding:.3rem .8rem;font-size:.9rem">Delete</button>
                                </form>
                                <% } %>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card mt2">
            <h3>🎵 Songs (<%= songs != null ? songs.size() : 0 %>)</h3>
            <div class="tc">
                <table>
                    <thead><tr><th>ID</th><th>Title</th><th>Artist</th><th>Actions</th></tr></thead>
                    <tbody>
                        <% if (songs != null && !songs.isEmpty()) { 
                            for (Song s : songs) { %>
                        <tr>
                            <td><%= s.getId() %></td>
                            <td><%= s.getTitle() %></td>
                            <td><%= s.getArtist() %></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin" method="post" style="display:inline" onsubmit="return confirm('Delete song?')">
                                    <input type="hidden" name="action" value="deleteSong">
                                    <input type="hidden" name="id" value="<%= s.getId() %>">
                                    <button type="submit" class="btn btn-d" style="padding:.3rem .8rem;font-size:.9rem">Delete</button>
                                </form>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <footer>
        <p>&copy; 2026 TuneHub | 
           <a href="${pageContext.request.contextPath}/about">About</a> | 
           <a href="${pageContext.request.contextPath}/contact">Contact</a>
        </p>
    </footer>
</body>
</html>