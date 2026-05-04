<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - TuneHub</title>
    
    <style>
        /* ===== EXACT THEME VARIABLES (Matches Index & Login) ===== */
        :root {
            --bg-base: #000000;
            --bg-surface: #121212;
            --bg-highlight: #1a1a1a;
            --text-primary: #ffffff;
            --text-secondary: #b3b3b3;
            --brand-green: #1db954;
            --brand-green-hover: #1ed760;
            --accent-purple: #8b5cf6;
            --border: rgba(255,255,255,0.08);
            --shadow-lg: rgba(0,0,0,0.5);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        
        body {
            font-family: 'Circular', -apple-system, BlinkMacSystemFont, 'Inter', 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: var(--bg-base);
            color: var(--text-primary);
            line-height: 1.5;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        /* ===== AMBIENT BACKGROUND ===== */
        body::before {
            content: ''; position: fixed; top: -20%; right: -20%; width: 60%; height: 120%;
            background: radial-gradient(circle, rgba(139,92,246,0.12) 0%, transparent 70%);
            pointer-events: none; z-index: -1;
        }
        body::after {
            content: ''; position: fixed; bottom: -30%; left: -10%; width: 50%; height: 90%;
            background: radial-gradient(circle, rgba(29,185,84,0.08) 0%, transparent 70%);
            pointer-events: none; z-index: -1;
        }

        /* ===== GLASS HEADER ===== */
        header {
            background: rgba(0, 0, 0, 0.95);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            padding: 1rem 3rem;
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid var(--border);
        }
        .nav-c { max-width: 1600px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.8rem; font-weight: 800; background: linear-gradient(135deg, var(--brand-green), var(--accent-purple)); -webkit-background-clip: text; background-clip: text; color: transparent; display: flex; align-items: center; gap: 0.6rem; }
        nav { display: flex; gap: 2rem; align-items: center; }
        nav a { color: var(--text-secondary); text-decoration: none; font-weight: 600; font-size: 0.95rem; transition: color 0.2s; }
        nav a:hover { color: var(--text-primary); }

        /* ===== WRAPPER ===== */
        .register-wrapper { flex: 1; display: flex; align-items: center; justify-content: center; padding: 3rem 1.5rem; }

        /* ===== AUTH CARD ===== */
        .auth-card {
            background: var(--bg-surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 2.5rem;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 16px 40px var(--shadow-lg);
        }
        .auth-card h2 { font-size: 2rem; font-weight: 800; margin-bottom: 0.4rem; text-align: center; letter-spacing: -0.5px; }
        .subtitle { text-align: center; color: var(--text-secondary); font-size: 0.95rem; margin-bottom: 1.8rem; }

        /* ===== FORM ELEMENTS ===== */
        .form-group { margin-bottom: 1.1rem; }
        .form-group label { display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.4rem; }
        .form-group input {
            width: 100%;
            padding: 0.85rem 1rem;
            background: var(--bg-highlight);
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 1rem;
            transition: all 0.2s ease;
        }
        .form-group input:focus {
            outline: none;
            border-color: var(--brand-green);
            box-shadow: 0 0 0 3px rgba(29,185,84,0.25);
        }
        .form-group input::placeholder { color: var(--text-secondary); }

        /* ===== ALERTS ===== */
        .alert { padding: 0.85rem 1rem; border-radius: 8px; margin-bottom: 1.2rem; font-size: 0.9rem; font-weight: 500; border: 1px solid; }
        .alert-error { background: rgba(220, 38, 38, 0.12); border-color: rgba(220, 38, 38, 0.3); color: #fca5a5; }
        .alert-success { background: rgba(34, 197, 94, 0.12); border-color: rgba(34, 197, 94, 0.3); color: #86efac; }

        /* ===== BUTTON ===== */
        .btn-register {
            width: 100%;
            padding: 1rem;
            background: var(--brand-green);
            color: #000000;
            border: none;
            border-radius: 500px;
            font-size: 1.05rem;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 0.5rem;
            letter-spacing: -0.3px;
        }
        .btn-register:hover { background: var(--brand-green-hover); transform: translateY(-2px) scale(1.02); box-shadow: 0 8px 20px rgba(29,185,84,0.35); }
        .btn-register:active { transform: translateY(0) scale(1); }

        /* ===== CARD FOOTER ===== */
        .card-footer { text-align: center; margin-top: 1.8rem; padding-top: 1.5rem; border-top: 1px solid var(--border); color: var(--text-secondary); font-size: 0.9rem; }
        .card-footer a { color: var(--brand-green); text-decoration: none; font-weight: 700; transition: color 0.2s; }
        .card-footer a:hover { color: var(--brand-green-hover); text-decoration: underline; }

        /* ===== PAGE FOOTER ===== */
        footer { background: var(--bg-surface); padding: 2.5rem 2rem 1.5rem; margin-top: auto; border-top: 1px solid var(--border); text-align: center; }
        footer p { color: var(--text-secondary); font-size: 0.85rem; }
        footer a { color: var(--text-secondary); text-decoration: none; margin: 0 0.5rem; transition: color 0.2s; }
        footer a:hover { color: var(--text-primary); }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            header { padding: 1rem; }
            .nav-c { flex-direction: column; gap: 1rem; }
            nav { width: 100%; justify-content: center; flex-wrap: wrap; }
            .auth-card { padding: 2rem 1.5rem; }
        }
    </style>
</head>
<body>
    <header>
        <div class="nav-c">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/login">Log in</a>
            </nav>
        </div>
    </header>

    <main class="register-wrapper">
        <div class="auth-card">
            <h2>Sign up for free</h2>
            <p class="subtitle">Create your account and start building playlists</p>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" 
                           value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" 
                           required pattern="[a-zA-Z0-9_]{3,20}" title="3-20 alphanumeric characters" placeholder="john_doe">
                </div>
                
                <div class="form-group">
                    <label for="email">Email address</label>
                    <input type="email" id="email" name="email" 
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" 
                           required placeholder="you@example.com">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required minlength="6" placeholder="Min 6 characters">
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6" placeholder="Re-enter password">
                </div>
                
                <button type="submit" class="btn-register">Sign Up</button>
            </form>
            
            <div class="card-footer">
                Already have an account? <a href="${pageContext.request.contextPath}/login">Log in here</a>
            </div>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 TuneHub. Built for music lovers. 
            <a href="${pageContext.request.contextPath}/WEB-INF/Pages/about.jsp">About</a> | 
            <a href="${pageContext.request.contextPath}/WEB-INF/Pages/contact.jsp">Contact</a>
        </p>
    </footer>
</body>
</html>