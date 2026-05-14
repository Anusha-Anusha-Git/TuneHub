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
    <title>Profile</title>
    <style>
        :root{--bg:#0a0a0a;--sf:#141414;--sf2:#1f1f1f;--t:#f0f0f0;--t2:#a0a0a0;--p:#8b5cf6;--g:#10b981;--r:#ef4444;--b:rgba(255,255,255,0.08);--rd:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:system-ui,sans-serif;background:var(--bg);color:var(--t);min-height:100vh;display:flex;flex-direction:column}
        header{background:rgba(10,10,10,0.95);backdrop-filter:blur(16px);border-bottom:1px solid var(--b);padding:1rem 2rem;position:sticky;top:0}
        .nav{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center}
        .logo{font-size:1.5rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:1rem}
        nav a{color:var(--t2);text-decoration:none;padding:0.5rem 1rem;border-radius:8px;transition:0.2s}
        nav a:hover{color:var(--t);background:var(--sf)}
        .container{max-width:500px;margin:3rem auto;padding:0 1.5rem;flex:1}
        .card{background:var(--sf);border:1px solid var(--b);border-radius:var(--rd);padding:2rem}
        input{width:100%;padding:0.8rem;background:var(--sf2);border:1px solid var(--b);border-radius:8px;color:var(--t);margin-bottom:1rem}
        input:focus{outline:none;border-color:var(--p)}
        input:disabled{opacity:0.6}
        .btn{padding:0.8rem;border:none;border-radius:8px;cursor:pointer;font-weight:500;color:#fff;background:var(--p);width:100%}
        .btn:hover{opacity:0.9}
        .btn-s{background:transparent;border:1px solid var(--b);color:var(--t)}
        .alert{padding:0.8rem;border-radius:8px;margin-bottom:1rem}
        .alert-e{background:rgba(239,68,68,0.15);color:#fca5a5}
        .alert-o{background:rgba(16,185,129,0.15);color:#6ee7b7}
        .footer{text-align:center;padding:2rem;color:var(--t2);font-size:0.85rem;margin-top:auto;border-top:1px solid var(--b)}
        
                select {
		    -webkit-appearance: none;
		    -moz-appearance: none;
		    appearance: none;
		    background: var(--sf2) url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23a0a0a0' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E") no-repeat right 0.75rem center/1rem;
		    background-color: var(--sf2);
		    padding-right: 2rem;
		    cursor: pointer;
		    transition: border-color 0.2s;
		}
		select:focus {
		    border-color: var(--p);
		    outline: none;
		}
		select option {
		    background: var(--sf);
		    color: var(--t);
		    padding: 0.5rem;@media(max-width:768px){.nav{flex-direction:column;gap:1rem;text-align:center}nav{width:100%;justify-content:center}}
    </style>
</head>
<body>
    <header>
        <div class="nav">
            <div class="logo">👤 Edit Profile</div>
            <nav>
                <a href="${pageContext.request.contextPath}/profile">← Back</a>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </nav>
        </div>
    </header>
    
    <div class="container">
        <div class="card">
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-e"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-o"><%= request.getAttribute("success") %></div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/profile" method="post">
                <label>Username *</label>
                <input type="text" name="username" value="<%= un %>" required pattern="[a-zA-Z0-9_]{3,20}">
                
                <label>Email *</label>
                <input type="email" name="email" value="<%= em %>" required>
                
                <label>Joined</label>
                <input type="text" value="<%= cu.getCreatedAt() != null ? cu.getCreatedAt().toString().substring(0,10) : "N/A" %>" disabled>
                
                <div style="display:flex;gap:0.5rem;margin-top:1rem">
                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-s">Cancel</a>
                    <button type="submit" class="btn">Save</button>
                </div>
            </form>
        </div>
    </div>
    
    <div class="footer">&copy; 2026 TuneHub</div>
</body>
</html>