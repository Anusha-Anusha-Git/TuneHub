<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*" %>
<%
    User cu = (User) session.getAttribute("user");
    if (cu == null) {
        response.sendRedirect(request.getContextPath() + "/login?error=Please login first");
        return;
    }
    String un = request.getParameter("username") != null ? (String) request.getParameter("username") : cu.getUsername();
    String em = request.getParameter("email") != null ? (String) request.getParameter("email") : cu.getEmail();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Profile - TuneHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
</head>
<body>
    <header>
        <div class="nav-c">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/profile">Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </nav>
        </div>
    </header>
    <div class="container">
        <div class="auth-f" style="max-width:500px">
            <h2>✏️ Edit Profile</h2>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-e"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-o"><%= request.getAttribute("success") %></div>
            <% } %>
            <form action="${pageContext.request.contextPath}/profile" method="post">
                <div class="fg">
                    <label>Username *</label>
                    <input type="text" name="username" value="<%= un %>" required pattern="[a-zA-Z0-9_]{3,20}">
                </div>
                <div class="fg">
                    <label>Email *</label>
                    <input type="email" name="email" value="<%= em %>" required>
                </div>
                <div class="fg">
                    <label>Member Since</label>
                    <input type="text" value="<%= cu.getCreatedAt() != null ? cu.getCreatedAt().toString().substring(0,10) : "N/A" %>" disabled style="background:var(--g)">
                </div>
                <div class="flx">
                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-s" style="flex:1;margin-right:.5rem">Cancel</a>
                    <button type="submit" class="btn" style="flex:2">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
    <footer><p>&copy; 2026 TuneHub</p></footer>
</body>
</html>