<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - TuneHub</title>
    <style>
        :root { --bg: #000000; --sf: #121212; --sf2: #1a1a1a; --t: #f0f0f0; --t2: #a0a0a0; --p: #8b5cf6; --g: #10b981; --r: #ef4444; --b: rgba(255,255,255,0.08); }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: system-ui, -apple-system, sans-serif; background: var(--bg); color: var(--t); line-height: 1.5; min-height: 100vh; display: flex; flex-direction: column; }
        
        header { background: rgba(0,0,0,0.95); backdrop-filter: blur(20px); padding: 1rem 2rem; border-bottom: 1px solid var(--b); position: sticky; top: 0; z-index: 100; }
        .nav-c { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.8rem; font-weight: 800; background: linear-gradient(135deg, var(--g), var(--p)); -webkit-background-clip: text; color: transparent; }
        nav { display: flex; gap: 1rem; }
        nav a { color: var(--t2); text-decoration: none; padding: 0.5rem 1rem; border-radius: 8px; transition: 0.2s; }
        nav a:hover { color: var(--t); }
        
        .container { max-width: 450px; margin: 3rem auto; padding: 0 1.5rem; flex: 1; }
        .card { background: var(--sf); border: 1px solid var(--b); border-radius: 16px; padding: 2rem; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        .card h2 { text-align: center; margin-bottom: 1.5rem; font-weight: 800; }
        
        .fg { margin-bottom: 1rem; }
        .fg label { display: block; font-size: 0.9rem; color: var(--t2); margin-bottom: 0.4rem; font-weight: 500; }
        .fg input, .fg select { width: 100%; padding: 0.85rem; background: var(--sf2); border: 1px solid var(--b); border-radius: 8px; color: var(--t); font-size: 1rem; transition: 0.2s; }
        .fg input:focus, .fg select:focus { outline: none; border-color: var(--p); box-shadow: 0 0 0 3px rgba(139,92,246,0.2); }
        
        /* ✅ BLACK DROPDOWN */
        select { -webkit-appearance: none; appearance: none; background: #000 url("image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='%23ffffff'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E") no-repeat right 0.7rem center/12px; }
        select option { background: #000; color: #fff; padding: 0.5rem; }
        
        .btn { width: 100%; padding: 0.9rem; background: var(--p); color: #fff; border: none; border-radius: 8px; font-weight: 700; font-size: 1rem; cursor: pointer; transition: 0.2s; margin-top: 0.5rem; }
        .btn:hover { background: #7c3aed; transform: translateY(-1px); }
        
        .alert { padding: 0.8rem; border-radius: 8px; margin-bottom: 1rem; font-size: 0.9rem; border-left: 4px solid; }
        .alert-e { background: rgba(239,68,68,0.15); color: #fca5a5; border-color: var(--r); }
        .alert-o { background: rgba(16,185,129,0.15); color: #6ee7b7; border-color: var(--g); }
        
        footer { text-align: center; padding: 2rem; color: var(--t2); font-size: 0.85rem; border-top: 1px solid var(--b); margin-top: auto; }
        footer a { color: var(--p); text-decoration: none; }
        footer a:hover { text-decoration: underline; }
        
        @media (max-width: 600px) { .container { margin: 1.5rem auto; } .card { padding: 1.5rem; } }
    </style>
</head>
<body>
    <header>
        <div class="nav-c">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/login">Login</a>
            </nav>
        </div>
    </header>

    <div class="container">
        <div class="card">
            <h2>Create Account</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-e"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getParameter("msg") != null) { %>
                <div class="alert alert-o"><%= request.getParameter("msg") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateForm()">
                <div class="fg">
                    <label for="username">Username *</label>
                    <input type="text" id="username" name="username" required pattern="[a-zA-Z0-9_]{3,20}" placeholder="3-20 alphanumeric chars">
                </div>
                
                <div class="fg">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" required placeholder="student@university.edu">
                </div>
                
                <div class="fg">
                    <label for="password">Password *</label>
                    <input type="password" id="password" name="password" minlength="6" required placeholder="Minimum 6 characters">
                </div>
                
                <div class="fg">
                    <label for="confirm">Confirm Password *</label>
                    <input type="password" id="confirm" name="confirm" minlength="6" required placeholder="Re-enter password">
                </div>
                
                <div class="fg">
                    <label for="role">Account Type</label>
                    <select id="role" name="role" required>
                        <option value="user">Student / Member</option>
                        <option value="admin">Administrator</option>
                    </select>
                </div>
                
                <button type="submit" class="btn">Create Account</button>
            </form>
            
            <p style="text-align:center; margin-top: 1.5rem; color: var(--t2); font-size: 0.9rem;">
                Already have an account? <a href="${pageContext.request.contextPath}/login" style="font-weight: 600;">Log In</a>
            </p>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 TuneHub. Built for coursework & music lovers.</p>
    </footer>

    <script>
        function validateForm() {
            const pwd = document.getElementById('password').value;
            const conf = document.getElementById('confirm').value;
            const user = document.getElementById('username').value;
            
            if (pwd.length < 6) {
                alert('Password must be at least 6 characters.');
                return false;
            }
            if (pwd !== conf) {
                alert('Passwords do not match.');
                return false;
            }
            if (!/^[a-zA-Z0-9_]{3,20}$/.test(user)) {
                alert('Username must be 3-20 alphanumeric characters or underscores.');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>