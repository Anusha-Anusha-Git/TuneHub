<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About - TuneHub</title>
    
    <style>
        /* ===== EXACT SAME VARIABLES AS INDEX FOR CONSISTENCY ===== */
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
            --shadow-sm: rgba(0,0,0,0.3);
            --shadow-lg: rgba(0,0,0,0.5);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Circular', -apple-system, BlinkMacSystemFont, 'Inter', 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: var(--bg-base);
            color: var(--text-primary);
            line-height: 1.5;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ===== ANIMATED BACKGROUND BLOBS ===== */
        body::before {
            content: ''; position: fixed; top: -30%; right: -20%; width: 70%; height: 130%;
            background: radial-gradient(circle, rgba(139,92,246,0.12) 0%, transparent 70%);
            pointer-events: none; z-index: -1;
        }
        body::after {
            content: ''; position: fixed; bottom: -20%; left: -10%; width: 60%; height: 100%;
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
        nav a.btn-green { background: var(--brand-green); color: #000; padding: 0.75rem 2rem; border-radius: 500px; font-weight: 700; box-shadow: 0 4px 14px rgba(29,185,84,0.4); transition: all 0.3s; }
        nav a.btn-green:hover { background: var(--brand-green-hover); transform: translateY(-2px); box-shadow: 0 6px 20px rgba(29,185,84,0.5); }

        /* ===== MAIN CONTENT ===== */
        main { max-width: 1200px; margin: 0 auto; padding: 4rem 2rem; }
        
        .about-hero { text-align: center; margin-bottom: 3.5rem; }
        .about-hero h1 { font-size: 3.5rem; font-weight: 900; letter-spacing: -1.5px; margin-bottom: 1rem; background: linear-gradient(135deg, #fff, #a5b4fc); -webkit-background-clip: text; background-clip: text; color: transparent; }
        .about-hero p { font-size: 1.2rem; color: var(--text-secondary); max-width: 650px; margin: 0 auto; line-height: 1.6; }
        
        .about-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; margin-bottom: 3rem; }
        .info-card { background: var(--bg-surface); border-radius: 16px; padding: 2rem; border: 1px solid var(--border); transition: all 0.3s ease; position: relative; overflow: hidden; }
        .info-card:hover { transform: translateY(-4px); border-color: rgba(29,185,84,0.3); box-shadow: 0 12px 32px var(--shadow-lg); }
        .info-card h3 { font-size: 1.3rem; font-weight: 800; margin-bottom: 1rem; display: flex; align-items: center; gap: 0.6rem; }
        .info-card p { color: var(--text-secondary); line-height: 1.6; margin-bottom: 1rem; }
        .info-card ul { list-style: none; padding: 0; }
        .info-card li { color: var(--text-secondary); padding: 0.5rem 0; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 0.5rem; }
        .info-card li:last-child { border-bottom: none; }
        .info-card li::before { content: '✓'; color: var(--brand-green); font-weight: bold; }

        .tech-stack { background: var(--bg-surface); border-radius: 16px; padding: 2rem; border: 1px solid var(--border); margin-bottom: 3rem; }
        .tech-stack h3 { font-size: 1.3rem; font-weight: 800; margin-bottom: 1.2rem; }
        .badges { display: flex; flex-wrap: wrap; gap: 0.75rem; }
        .badge { background: rgba(255,255,255,0.08); color: var(--text-primary); padding: 0.5rem 1rem; border-radius: 500px; font-size: 0.9rem; font-weight: 600; border: 1px solid var(--border); transition: all 0.2s; }
        .badge:hover { background: rgba(255,255,255,0.15); transform: translateY(-2px); }

        .cta-box { text-align: center; padding: 2rem; background: linear-gradient(135deg, rgba(29,185,84,0.1), rgba(139,92,246,0.1)); border-radius: 16px; border: 1px solid var(--border); }
        .cta-box h3 { font-size: 1.5rem; margin-bottom: 1rem; }
        .btn { display: inline-flex; align-items: center; justify-content: center; padding: 1rem 2.5rem; border-radius: 500px; font-weight: 700; text-decoration: none; transition: all 0.3s; cursor: pointer; border: none; font-size: 1.05rem; }
        .btn-green { background: var(--brand-green); color: #000; box-shadow: 0 4px 14px rgba(29,185,84,0.4); }
        .btn-green:hover { background: var(--brand-green-hover); transform: translateY(-3px) scale(1.02); box-shadow: 0 8px 24px rgba(29,185,84,0.5); }

        /* ===== FOOTER ===== */
        footer { background: var(--bg-surface); padding: 3rem 2rem; margin-top: 4rem; border-top: 1px solid var(--border); }
        .footer-c { max-width: 1600px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 2rem; }
        .footer-col h4 { color: var(--text-primary); margin-bottom: 1rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; font-size: 0.9rem; }
        .footer-col a { display: block; color: var(--text-secondary); text-decoration: none; margin-bottom: 0.75rem; font-size: 0.95rem; transition: color 0.2s; }
        .footer-col a:hover { color: var(--text-primary); transform: translateX(3px); }
        .footer-bottom { max-width: 1600px; margin: 2rem auto 0; padding-top: 2rem; border-top: 1px solid var(--border); text-align: center; color: var(--text-secondary); font-size: 0.85rem; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            header { padding: 1rem; }
            .nav-c { flex-direction: column; gap: 1rem; }
            nav { width: 100%; justify-content: center; flex-wrap: wrap; }
            .about-hero h1 { font-size: 2.5rem; }
            main { padding: 2.5rem 1.5rem; }
            .about-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <header>
        <div class="nav-c">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <% if (session.getAttribute("user") != null) { %>
                    <a href="${pageContext.request.contextPath}/profile">Your Library</a>
                    <a href="${pageContext.request.contextPath}/logout">Log out</a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login">Log in</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-green">Sign up</a>
                <% } %>
            </nav>
        </div>
    </header>

    <main>
        <section class="about-hero">
            <h1>About TuneHub 🎧</h1>
            <p>Built for music lovers, engineered for developers. TuneHub is a modern, secure, and intuitive music management platform that bridges the gap between clean UI design and robust backend architecture.</p>
        </section>

        <section class="about-grid">
            <div class="info-card">
                <h3>🎯 What It Does</h3>
                <p>TuneHub lets users organize tracks, create personalized playlists, and manage a centralized music catalog. Administrators maintain full control over users and content through a dedicated dashboard.</p>
                <ul>
                    <li>Role-based dashboards (Admin & User)</li>
                    <li>Secure session & authentication flow</li>
                    <li>Database-driven song & user management</li>
                    <li>Responsive, accessibility-ready interface</li>
                </ul>
            </div>
            <div class="info-card">
                <h3>🛠️ How It's Built</h3>
                <p>Designed following strict MVC architecture, TuneHub separates business logic, data access, and presentation layers. Every query uses prepared statements, and passwords are hashed with salted SHA-256.</p>
                <ul>
                    <li>Java Servlets as Controllers</li>
                    <li>JSP Views protected in WEB-INF</li>
                    <li>JDBC with connection pooling</li>
                    <li>Zero external UI frameworks</li>
                </ul>
            </div>
        </section>

        <section class="tech-stack">
            <h3>⚙️ Technology Stack</h3>
            <div class="badges">
                <span class="badge">Java 8+</span>
                <span class="badge">JSP 2.3</span>
                <span class="badge">Jakarta/Servlets</span>
                <span class="badge">JDBC</span>
                <span class="badge">MySQL 8</span>
                <span class="badge">HTML5 / CSS3</span>
                <span class="badge">Tomcat 9/10</span>
                <span class="badge">SHA-256 + Salt</span>
            </div>
        </section>

        <section class="cta-box">
            <h3>Ready to explore your music library?</h3>
            <a href="${pageContext.request.contextPath}/" class="btn btn-green">← Back to Home</a>
        </section>
    </main>

    <footer>
        <div class="footer-c">
            <div class="footer-col">
                <h4>Company</h4>
                <a href="#">About</a>
                <a href="#">Careers</a>
                <a href="#">For the Record</a>
            </div>
            <div class="footer-col">
                <h4>Communities</h4>
                <a href="#">For Artists</a>
                <a href="#">Developers</a>
                <a href="#">Advertising</a>
            </div>
            <div class="footer-col">
                <h4>Useful Links</h4>
                <a href="#">Support</a>
                <a href="#">Free Mobile App</a>
                <a href="#">Contact</a>
            </div>
            <div class="footer-col">
                <h4>TuneHub Plans</h4>
                <a href="#">Free</a>
                <a href="#">Premium</a>
                <a href="#">Student</a>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 TuneHub. Built for coursework & music lovers. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>