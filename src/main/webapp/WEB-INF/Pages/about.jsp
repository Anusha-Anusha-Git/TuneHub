<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About - TuneHub</title>
    <style>
        :root{--bg:#000;--sf:#121212;--sf2:#1a1a1a;--t:#fff;--t2:#b3b3b3;--g:#1db954;--p:#8b5cf6;--b:rgba(255,255,255,0.08);--rd:16px}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:'Inter',system-ui,sans-serif;background:var(--bg);color:var(--t);line-height:1.6;min-height:100vh}
        header{background:rgba(0,0,0,0.95);backdrop-filter:blur(20px);padding:1rem 3rem;position:sticky;top:0;z-index:1000;border-bottom:1px solid var(--b)}
        .nav{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center}
        .logo{font-size:1.8rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:2rem}nav a{color:var(--t2);text-decoration:none;font-weight:600;transition:0.2s}nav a:hover{color:var(--t)}
        .hero{max-width:1200px;margin:0 auto;padding:5rem 2rem 3rem;text-align:center}
        .hero h1{font-size:3rem;font-weight:900;margin-bottom:1rem;background:linear-gradient(135deg,#fff,#a5b4fc);-webkit-background-clip:text;color:transparent}
        .hero p{color:var(--t2);font-size:1.2rem;max-width:700px;margin:0 auto}
        .content{max-width:1200px;margin:0 auto;padding:0 2rem 4rem}
        .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:2rem;margin-top:2rem}
        .card{background:var(--sf);border:1px solid var(--b);border-radius:var(--rd);padding:2rem;transition:0.3s}
        .card:hover{transform:translateY(-4px);border-color:var(--g)}
        .card h3{color:var(--g);margin-bottom:1rem;font-size:1.3rem}
        .tech-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(120px,1fr));gap:1rem;margin-top:1rem}
        .tech-badge{background:var(--sf2);padding:0.8rem 1rem;border-radius:8px;text-align:center;font-weight:600;font-size:0.9rem}
        .timeline{position:relative;padding-left:2rem;margin:2rem 0}
        .timeline::before{content:'';position:absolute;left:0;top:0;bottom:0;width:2px;background:var(--b)}
        .timeline-item{position:relative;padding-bottom:2rem}
        .timeline-item::before{content:'';position:absolute;left:-2.4rem;top:0.3rem;width:12px;height:12px;border-radius:50%;background:var(--g)}
        .timeline-item h4{margin-bottom:0.3rem}
        .timeline-item p{color:var(--t2);font-size:0.95rem}
        footer{background:var(--sf);padding:3rem 2rem;text-align:center;color:var(--t2);border-top:1px solid var(--b)}
        footer a{color:var(--t2);text-decoration:none;margin:0 0.5rem}footer a:hover{color:var(--t)}
        @media(max-width:768px){header{padding:1rem}.nav{flex-direction:column;gap:1rem}.hero{padding:3rem 1rem}.hero h1{font-size:2.2rem}}
    </style>
</head>
<body>
    <header>
        <div class="nav">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/contact">Contact</a>
            </nav>
        </div>
    </header>

    <section class="hero">
        <h1>About TuneHub</h1>
        <p>A modern, secure music management platform built for the future of digital audio.</p>
    </section>

    <div class="content">
        <div class="grid">
            <div class="card">
                <h3>🎯 Mission</h3>
                <p style="color:var(--t2)">To empower music lovers and creators with an intuitive, powerful platform for organizing, discovering, and sharing music — all while maintaining enterprise-grade security and performance.</p>
            </div>
            <div class="card">
                <h3>🛠️ Technology</h3>
                <div class="tech-grid">
                    <div class="tech-badge">Java 8+</div>
                    <div class="tech-badge">JSP 2.3</div>
                    <div class="tech-badge">Servlets</div>
                    <div class="tech-badge">JDBC</div>
                    <div class="tech-badge">MySQL 8</div>
                    <div class="tech-badge">Tomcat 9/10</div>
                </div>
            </div>
        </div>

        <div class="card" style="margin-top:2rem">
            <h3>🚀 Development Timeline</h3>
            <div class="timeline">
                <div class="timeline-item">
                    <h4>Phase 1: Architecture</h4>
                    <p>Designed MVC structure, database schema, and security model.</p>
                </div>
                <div class="timeline-item">
                    <h4>Phase 2: Core Features</h4>
                    <p>Implemented authentication, role-based dashboards, and playlist management.</p>
                </div>
                <div class="timeline-item">
                    <h4>Phase 3: Polish & Testing</h4>
                    <p>Refined UI/UX, added responsive design, and performed security audits.</p>
                </div>
                <div class="timeline-item">
                    <h4>Phase 4: Deployment</h4>
                    <p>Prepared for production with optimized queries and error handling.</p>
                </div>
            </div>
        </div>

        <div class="grid" style="margin-top:2rem">
            <div class="card">
                <h3>🔐 Security First</h3>
                <ul style="color:var(--t2);padding-left:1.2rem">
                    <li>Session-based authentication with timeout</li>
                    <li>Input sanitization to prevent XSS</li>
                    <li>PreparedStatement for SQL injection protection</li>
                    <li>Role-based access control (RBAC)</li>
                </ul>
            </div>
            <div class="card">
                <h3>🎨 User Experience</h3>
                <ul style="color:var(--t2);padding-left:1.2rem">
                    <li>Spotify-inspired dark theme</li>
                    <li>Responsive design for all devices</li>
                    <li>Intuitive playlist creation & management</li>
                    <li>Real-time search & filtering</li>
                </ul>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 TuneHub. Built for music lovers. All rights reserved.</p>
        <p style="margin-top:0.5rem">
            <a href="${pageContext.request.contextPath}/">Home</a> | 
            <a href="${pageContext.request.contextPath}/contact">Contact</a>
        </p>
    </footer>
</body>
</html>