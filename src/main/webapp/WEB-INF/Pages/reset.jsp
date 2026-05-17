<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - TuneHub</title>
    <style>
        :root { --bg: #000000; --sf: #121212; --sf2: #1a1a1a; --t: #f0f0f0; --t2: #a0a0a0; --p: #8b5cf6; --g: #10b981; --b: rgba(255,255,255,0.08); }
        *{box-sizing:border-box;margin:0;padding:0} body{font-family:system-ui,sans-serif;background:var(--bg);color:var(--t);min-height:100vh;display:flex;flex-direction:column}
        header{background:rgba(0,0,0,0.95);padding:1rem 2rem;border-bottom:1px solid var(--b)}
        .nav{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center}
        .logo{font-size:1.8rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:1rem}nav a{color:var(--t2);text-decoration:none;padding:0.5rem 1rem;border-radius:8px}nav a:hover{color:var(--t)}
        .container{max-width:450px;margin:3rem auto;padding:0 1.5rem;flex:1}
        .card{background:var(--sf);border:1px solid var(--b);border-radius:12px;padding:2rem}
        .card h2{text-align:center;margin-bottom:1.5rem;color:var(--p)}
        .fg{margin-bottom:1rem}.fg label{display:block;font-size:0.9rem;color:var(--t2);margin-bottom:0.4rem}
        .fg input{width:100%;padding:0.8rem;background:var(--sf2);border:1px solid var(--b);border-radius:8px;color:var(--t);font-size:1rem}
        .fg input:focus{outline:none;border-color:var(--p)}
        .btn{width:100%;padding:0.9rem;background:var(--p);color:#fff;border:none;border-radius:8px;font-weight:600;cursor:pointer;margin-top:0.5rem}
        .btn:hover{background:#7c3aed}
        .alert{padding:0.8rem;border-radius:8px;margin-bottom:1rem;font-size:0.9rem}
        .alert-e{background:rgba(239,68,68,0.15);color:#fca5a5}.alert-o{background:rgba(16,185,129,0.15);color:#6ee7b7}
        footer{text-align:center;padding:2rem;color:var(--t2);font-size:0.85rem;border-top:1px solid var(--b);margin-top:auto}
        footer a{color:var(--p);text-decoration:none}
    </style>
</head>
<body>
    <header>
        <div class="nav">
            <div class="logo">🎵 TuneHub</div>
            <nav>
    <a href="${pageContext.request.contextPath}/">Home</a>
    <a href="${pageContext.request.contextPath}/profile">← Back to Dashboard</a>
    <a href="${pageContext.request.contextPath}/logout" onclick="return confirm('Are you sure you want to log out?')">Logout</a>
</nav> </div>
    </header>

    <div class="container">
        <div class="card">
            <h2>Reset Password</h2>
            <% if(request.getAttribute("error")!=null){ %><div class="alert alert-e"><%=request.getAttribute("error")%></div><% } %>
            <% if(request.getAttribute("success")!=null){ %><div class="alert alert-o"><%=request.getAttribute("success")%></div><% } %>
            
            <form action="${pageContext.request.contextPath}/reset-password" method="post">
                <div class="fg">
                    <label for="email">Registered Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="fg">
                    <label for="token">Reset Token</label>
                    <input type="text" id="token" name="token" placeholder="Enter token provided by admin/email" required>
                </div>
                <div class="fg">
                    <label for="newPass">New Password</label>
                    <input type="password" id="newPass" name="newPass" minlength="6" required>
                </div>
                <div class="fg">
                    <label for="confirmPass">Confirm New Password</label>
                    <input type="password" id="confirmPass" name="confirmPass" minlength="6" required>
                </div>
                <button type="submit" class="btn">Reset Password</button>
            </form>
            
            <p style="text-align:center;margin-top:1rem;color:var(--t2);font-size:0.9rem">
                Remember your password? <a href="${pageContext.request.contextPath}/login" style="font-weight:600;">Back to Login</a>
            </p>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 TuneHub. Built for coursework & music lovers.</p>
    </footer>
</body>
</html>