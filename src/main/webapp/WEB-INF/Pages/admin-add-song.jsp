<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Add Song - Admin</title>
    <style>
        :root{--bg:#0a0a0a;--sf:#141414;--sf2:#1f1f1f;--t:#f0f0f0;--t2:#a0a0a0;--p:#8b5cf6;--g:#10b981;--b:rgba(255,255,255,0.08);--rd:12px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:system-ui,sans-serif;background:var(--bg);color:var(--t);min-height:100vh;display:flex;flex-direction:column}
        header{background:rgba(10,10,10,0.95);backdrop-filter:blur(16px);border-bottom:1px solid var(--b);padding:1rem 2rem;position:sticky;top:0}
        .nav{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center}
        .logo{font-size:1.5rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:1rem}
        nav a{color:var(--t2);text-decoration:none;padding:0.5rem 1rem;border-radius:8px;transition:0.2s}
        nav a:hover{color:var(--t);background:var(--sf)}
        .container{max-width:600px;margin:3rem auto;padding:0 1.5rem;flex:1}
        .card{background:var(--sf);border:1px solid var(--b);border-radius:var(--rd);padding:2rem}
        .form-group{margin-bottom:1.2rem}
        label{display:block;font-size:0.9rem;color:var(--t2);margin-bottom:0.4rem}
        input,textarea{width:100%;padding:0.8rem;background:var(--sf2);border:1px solid var(--b);border-radius:8px;color:var(--t);font-size:1rem}
        input:focus,textarea:focus{outline:none;border-color:var(--p)}
        .btn{padding:0.8rem 1.5rem;border:none;border-radius:8px;cursor:pointer;font-weight:600;transition:0.2s;color:#fff;background:var(--p)}
        .btn:hover{opacity:0.9}
        .btn-s{background:transparent;border:1px solid var(--b);color:var(--t)}
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
		    padding: 0.5rem;
    </style>
</head>
<body>
    <header>
        <div class="nav">
            <div class="logo">👑 Admin</div>
            <nav>
                <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </nav>
        </div>
    </header>
    
    <div class="container">
        <div class="card">
            <h2 style="margin-bottom:1.5rem">🎵 Add New Song</h2>
            <form action="${pageContext.request.contextPath}/admin" method="post">
                <input type="hidden" name="action" value="saveSong">
                
                <div class="form-group">
                    <label>Title *</label>
                    <input type="text" name="title" required placeholder="e.g. Anti-Hero">
                </div>
                
                <div class="form-group">
                    <label>Artist *</label>
                    <input type="text" name="artist" required placeholder="e.g. Taylor Swift">
                </div>
                
                <div class="form-group">
                    <label>Album</label>
                    <input type="text" name="album" placeholder="e.g. Midnights">
                </div>
                
                <div class="form-group">
                    <label>Album Cover URL</label>
                    <input type="url" name="file_path" placeholder="https://example.com/cover.jpg">
                    <small style="color:var(--t2);display:block;margin-top:0.3rem">Paste a direct image URL (JPG/PNG)</small>
                </div>
                
                <div style="display:flex;gap:0.8rem;margin-top:1.5rem">
                    <a href="${pageContext.request.contextPath}/admin" class="btn btn-s" style="flex:1;text-align:center">Cancel</a>
                    <button type="submit" class="btn" style="flex:2">Save Song</button>
                </div>
            </form>
        </div>
    </div>
    
    <div class="footer">&copy; 2026 TuneHub</div>
</body>
</html>