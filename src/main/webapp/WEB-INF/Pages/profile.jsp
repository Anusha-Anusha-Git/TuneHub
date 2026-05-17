<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*" %>
<%
    User cu = (User) session.getAttribute("user");
    if (cu == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    
    // Determine if we're editing from admin dashboard
    Boolean fromAdmin = (Boolean) request.getAttribute("fromAdmin");
    String ctx = request.getContextPath();
    String backUrl = (fromAdmin != null && fromAdmin) ? ctx + "/admin" : ctx + "/profile";
    String formAction = (fromAdmin != null && fromAdmin) ? ctx + "/admin" : ctx + "/profile";
    String actionValue = (fromAdmin != null && fromAdmin) ? "updateAdminProfile" : 
                         (request.getParameter("action") != null && request.getParameter("action").equals("changePassword") ? "changePassword" : "updateProfile");
    String backText = (fromAdmin != null && fromAdmin) ? "Admin Dashboard" : "Dashboard";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Account Settings</title>
    <style>
        :root{--bg:#0a0a0a;--sf:#141414;--sf2:#1f1f1f;--t:#f0f0f0;--t2:#a0a0a0;--p:#8b5cf6;--g:#10b981;--r:#ef4444;--b:rgba(255,255,255,0.08);--rd:12px}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:system-ui,sans-serif;background:var(--bg);color:var(--t);min-height:100vh;display:flex;flex-direction:column}
        header{background:rgba(10,10,10,0.95);backdrop-filter:blur(16px);border-bottom:1px solid var(--b);padding:1rem 2rem;position:sticky;top:0}
        .nav{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center}.logo{font-size:1.5rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:1rem}nav a{color:var(--t2);text-decoration:none;padding:0.5rem 1rem;border-radius:8px}nav a:hover{color:var(--t);background:var(--sf)}
        .container{max-width:900px;margin:2rem auto;padding:0 1.5rem;flex:1}
        .two{display:grid;grid-template-columns:1fr 1fr;gap:1.5rem}@media(max-width:768px){.two{grid-template-columns:1fr}}
        .card{background:var(--sf);border:1px solid var(--b);border-radius:var(--rd);padding:2rem;margin-bottom:1.5rem}
        .card h2{color:var(--g);margin-bottom:1rem}
        .fg{margin-bottom:1rem}.fg label{display:block;font-size:0.9rem;color:var(--t2);margin-bottom:0.4rem}
        .fg input{width:100%;padding:0.8rem;background:var(--sf2);border:1px solid var(--b);border-radius:8px;color:var(--t)}.fg input:focus{outline:none;border-color:var(--p)}
        .btn{padding:0.8rem 1.5rem;border:none;border-radius:8px;cursor:pointer;font-weight:600;color:#fff;background:var(--p);width:100%}.btn:hover{opacity:0.9}
        .btn-danger{background:var(--r)}
        .alert{padding:0.8rem;border-radius:8px;margin-bottom:1rem;font-size:0.9rem}.alert-e{background:rgba(239,68,68,0.15);color:#fca5a5}.alert-o{background:rgba(16,185,129,0.15);color:#6ee7b7}
        footer{text-align:center;padding:2rem;color:var(--t2);font-size:0.85rem;margin-top:auto;border-top:1px solid var(--b)}
    </style>
</head>
<body>
    <header>
        <div class="nav">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="<%= backUrl %>">← Back to <%= backText %></a>
                <a href="<%= ctx %>/logout" onclick="return confirm('Are you sure you want to log out?')">Logout</a>
            </nav>
        </div>
    </header>

    <div class="container">
        <% String msg = request.getParameter("success"); String err = request.getParameter("error"); 
           if(msg!=null){ %><div class="alert alert-o"><%=msg%></div><% } 
           if(err!=null){ %><div class="alert alert-e"><%=err%></div><% } %>
        
        <div class="two">
            <!-- Update Login Details -->
            <div class="card">
                <h2>👤 Update Login Details</h2>
                <form action="<%= formAction %>" method="post">
                    <input type="hidden" name="action" value="<%= actionValue %>">
                    <div class="fg"><label>Username</label><input type="text" name="username" value="<%=cu.getUsername()%>" required pattern="[a-zA-Z0-9_]{3,20}"></div>
                    <div class="fg"><label>Email</label><input type="email" name="email" value="<%=cu.getEmail()%>" required></div>
                    <button type="submit" class="btn">Update Details</button>
                </form>
            </div>

            <!-- Change Password -->
            <div class="card">
                <h2>🔒 Change Password</h2>
                <form action="<%= formAction %>" method="post">
                    <input type="hidden" name="action" value="changePassword">
                    <div class="fg"><label>Current Password</label><input type="password" name="current_password" required></div>
                    <div class="fg"><label>New Password (min 6)</label><input type="password" name="new_password" minlength="6" required></div>
                    <div class="fg"><label>Confirm New Password</label><input type="password" name="confirm_password" minlength="6" required></div>
                    <button type="submit" class="btn btn-danger">Update Password</button>
                </form>
            </div>
        </div>
    </div>

    <footer>&copy; 2026 TuneHub</footer>
</body>
</html>