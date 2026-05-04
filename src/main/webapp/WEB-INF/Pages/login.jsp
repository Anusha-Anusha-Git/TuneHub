<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - TuneHub</title>
    
    <style>
        /* ===== EXACT THEME VARIABLES (Matches Index) ===== */
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
        .nav-c {
            max-width: 1600px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--brand-green), var(--accent-purple));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }
        nav { display: flex; gap: 2rem; align-items: center; }
        nav a {
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: color 0.2s;
        }
        nav a:hover { color: var(--text-primary); }

        /* ===== LOGIN WRAPPER ===== */
        .login-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 1.5rem;
        }

        /* ===== LOGIN CARD ===== */
        .login-card {
            background: var(--bg-surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 2.5rem;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 16px 40px var(--shadow-lg);
        }
        .login-card h2 {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            text-align: center;
            letter-spacing: -0.5px;
        }
        .subtitle {
            text-align: center;
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin-bottom: 2rem;
        }

        /* ===== FORM ELEMENTS ===== */
        .form-group { margin-bottom: 1.2rem; }
        .form-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }
        .form-group input[type="text"],
        .form-group input[type="password"] {
            width: 100%;
            padding: 0.9rem 1rem;
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

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }
        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-secondary);
            cursor: pointer;
        }
        .checkbox-label input {
            accent-color: var(--brand-green);
            width: 16px; height: 16px;
            cursor: pointer;
        }
        .forgot-link {
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        .forgot-link:hover { color: var(--brand-green); text-decoration: underline; }

        /* ===== BUTTON ===== */
        .btn-login {
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
            letter-spacing: -0.3px;
        }
        .btn-login:hover {
            background: var(--brand-green-hover);
            transform: translateY(-2px) scale(1.02);
            box-shadow: 0 8px 20px rgba(29,185,84,0.35);
        }
        .btn-login:active { transform: translateY(0) scale(1); }

        /* ===== ALERTS ===== */
        .alert {
            padding: 0.85rem 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            font-weight: 500;
            border: 1px solid;
        }
        .alert-error {
            background: rgba(220, 38, 38, 0.12);
            border-color: rgba(220, 38, 38, 0.3);
            color: #fca5a5;
        }
        .alert-success {
            background: rgba(34, 197, 94, 0.12);
            border-color: rgba(34, 197, 94, 0.3);
            color: #86efac;
        }

        /* ===== CARD FOOTER ===== */
        .card-footer {
            text-align: center;
            margin-top: 1.8rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border);
            color: var(--text-secondary);
            font-size: 0.9rem;
        }
        .card-footer a {
            color: var(--brand-green);
            text-decoration: none;
            font-weight: 700;
            transition: color 0.2s;
        }
        .card-footer a:hover { color: var(--brand-green-hover); text-decoration: underline; }

        /* ===== PAGE FOOTER ===== */
        footer {
            background: var(--bg-surface);
            padding: 2.5rem 2rem 1.5rem;
            margin-top: auto;
            border-top: 1px solid var(--border);
            text-align: center;
        }
        footer p { color: var(--text-secondary); font-size: 0.85rem; }
        footer a { color: var(--text-secondary); text-decoration: none; margin: 0 0.5rem; transition: color 0.2s; }
        footer a:hover { color: var(--text-primary); }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            header { padding: 1rem; }
            .nav-c { flex-direction: column; gap: 1rem; }
            nav { width: 100%; justify-content: center; flex-wrap: wrap; }
            .login-card { padding: 2rem 1.5rem; }
            .form-options { flex-direction: column; align-items: flex-start; gap: 0.8rem; }
        }
    </style>
</head>
<body>
    <header>
        <div class="nav-c">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/register">Register</a>
            </nav>
        </div>
    </header>

    <main class="login-wrapper">
        <div class="login-card">
            <h2>Sign in</h2>
            <p class="subtitle">Enter your credentials to access your library</p>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="identifier">Username or Email</label>
                    <input type="text" id="identifier" name="identifier" required placeholder="username or email">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required placeholder="••••••••">
                </div>
                
                <div class="form-options">
                    <label class="checkbox-label">
                        <input type="checkbox" name="remember"> Remember me
                    </label>
                    <a href="#" class="forgot-link">Forgot password?</a>
                </div>
                
                <button type="submit" class="btn-login">Log In</button>
            </form>
            
            <div class="card-footer">
                Don't have an account? <a href="${pageContext.request.contextPath}/register">Sign up for TuneHub</a>
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