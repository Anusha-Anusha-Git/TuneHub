<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*,java.util.*" %>
<%
    List<Playlist> publicPlaylists = (List<Playlist>) request.getAttribute("publicPlaylists");
    List<Song> searchResults = (List<Song>) request.getAttribute("searchResults");
    String searchQuery = (String) request.getAttribute("searchQuery");
    User cu = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TuneHub - Home</title>
    <style>
        :root { --bg-base: #000000; --bg-surface: #121212; --bg-highlight: #1a1a1a; --text-primary: #ffffff; --text-secondary: #b3b3b3; --brand-green: #1db954; --brand-green-hover: #1ed760; --accent-purple: #8b5cf6; --border: rgba(255,255,255,0.08); --radius: 12px; }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', system-ui, sans-serif; background: var(--bg-base); color: var(--text-primary); line-height: 1.5; min-height: 100vh; overflow-x: hidden; }
        header { background: rgba(0,0,0,0.95); backdrop-filter: blur(20px); padding: 1rem 3rem; position: sticky; top: 0; z-index: 1000; border-bottom: 1px solid var(--border); }
        .nav-c { max-width: 1600px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.8rem; font-weight: 800; background: linear-gradient(135deg, var(--brand-green), var(--accent-purple)); -webkit-background-clip: text; background-clip: text; color: transparent; }
        nav { display: flex; gap: 2rem; align-items: center; }
        nav a { color: var(--text-secondary); text-decoration: none; font-weight: 600; transition: 0.2s; }
        nav a:hover { color: var(--text-primary); }
        nav a.btn-green { background: var(--brand-green); color: #000; padding: 0.75rem 2rem; border-radius: 500px; font-weight: 700; box-shadow: 0 4px 14px rgba(29,185,84,0.4); }
        nav a.btn-green:hover { background: var(--brand-green-hover); transform: translateY(-2px); }
        .hero { max-width: 1600px; margin: 0 auto; padding: 4rem 3rem 2rem; text-align: center; }
        .hero h1 { font-size: 3.5rem; font-weight: 900; margin-bottom: 1rem; background: linear-gradient(135deg, #fff, #a5b4fc); -webkit-background-clip: text; background-clip: text; color: transparent; }
        .hero p { color: var(--text-secondary); font-size: 1.2rem; max-width: 650px; margin: 0 auto 2rem; }
        .search-bar { max-width: 500px; margin: 0 auto 2rem; display: flex; gap: 0.5rem; }
        .search-bar input { flex: 1; padding: 1rem; background: var(--bg-highlight); border: 1px solid var(--border); border-radius: 500px; color: var(--text-primary); font-size: 1rem; }
        .search-bar button { padding: 1rem 2rem; background: var(--brand-green); color: #000; border: none; border-radius: 500px; font-weight: 700; cursor: pointer; }
        main { max-width: 1600px; margin: 0 auto; padding: 2rem 3rem 4rem; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; margin-top: 2.5rem; }
        .section-header h2 { font-size: 1.8rem; font-weight: 800; }
        .card-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1.5rem; }
        .card { background: var(--bg-surface); border-radius: var(--radius); padding: 1.5rem; transition: 0.3s; border: 1px solid var(--border); cursor: pointer; }
        .card:hover { transform: translateY(-4px); background: var(--bg-highlight); box-shadow: 0 8px 24px rgba(0,0,0,0.4); }
        .card-cover { width: 100%; aspect-ratio: 1; border-radius: 8px; margin-bottom: 1rem; position: relative; overflow: hidden; background: var(--bg-highlight); }
        .card-cover img { width: 100%; height: 100%; object-fit: cover; }
        .card-title { font-weight: 700; font-size: 1.05rem; margin-bottom: 0.3rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .card-desc { font-size: 0.9rem; color: var(--text-secondary); line-height: 1.4; }
        .play-btn { position: absolute; bottom: 0.8rem; right: 0.8rem; width: 48px; height: 48px; background: var(--brand-green); color: #000; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; opacity: 0; transform: translateY(10px); transition: 0.3s; box-shadow: 0 4px 12px rgba(0,0,0,0.3); }
        .card:hover .play-btn { opacity: 1; transform: translateY(0); }
        .badge { display: inline-block; background: var(--bg-highlight); padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.8rem; color: var(--text-secondary); margin-right: 0.4rem; margin-bottom: 0.4rem; }
        .contact-row { display: flex; align-items: center; gap: 0.8rem; padding: 0.7rem; background: var(--bg-highlight); border-radius: 8px; margin-bottom: 0.6rem; }
        .contact-row a { color: var(--text-primary); text-decoration: none; }
        .contact-row a:hover { color: var(--brand-green); }
        footer { background: var(--bg-surface); padding: 4rem 3rem 2rem; margin-top: 4rem; border-top: 1px solid var(--border); text-align: center; color: var(--text-secondary); font-size: 0.9rem; }
        @media (max-width: 768px) { header { padding: 1rem; } .nav-c { flex-direction: column; gap: 1rem; } nav { width: 100%; justify-content: center; flex-wrap: wrap; } .hero { padding: 2rem 1rem; } .hero h1 { font-size: 2.2rem; } main { padding: 1.5rem; } .card-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 480px) { .card-grid { grid-template-columns: 1fr; } .search-bar { flex-direction: column; } }
    </style>
</head>
<body>
    <header>
        <div class="nav-c">
            <div class="logo">🎵 TuneHub</div>
            <nav>
    <a href="${pageContext.request.contextPath}/">Home</a>
    <% if (session.getAttribute("user") != null) { %>
        <a href="${pageContext.request.contextPath}/profile">Dashboard</a>
        <a href="${pageContext.request.contextPath}/reset">Edit Profile</a>
        <a href="${pageContext.request.contextPath}/logout" onclick="return confirm('Are you sure you want to log out?')">Logout</a>
    <% } else { %>
        <a href="${pageContext.request.contextPath}/login">Log in</a>
        <a href="${pageContext.request.contextPath}/register">Sign up</a>
    <% } %>
</nav>
        </div>
    </header>

    <section class="hero">
        <h1>Listening is everything</h1>
        <p>Millions of songs. No credit card needed. Start your musical journey today with TuneHub.</p>
        <form action="${pageContext.request.contextPath}/search" method="get" class="search-bar">
            <input type="text" name="q" placeholder="What do you want to listen to?" value="<%= searchQuery != null ? searchQuery : "" %>">
            <button type="submit">🔍 Search</button>
        </form>
        <% if (cu == null) { %>
            <div style="display:flex;gap:1rem;justify-content:center">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-green">Get TuneHub Free</a>
                <a href="${pageContext.request.contextPath}/login" style="padding:1rem 2.5rem;border-radius:500px;font-weight:700;background:rgba(255,255,255,0.1);color:#fff;text-decoration:none;transition:0.2s">Log In</a>
            </div>
        <% } %>
    </section>

    <main>
        <!-- 🔍 SEARCH RESULTS -->
        <% if (searchResults != null && searchQuery != null && !searchQuery.isEmpty()) { %>
        <div class="section-header">
            <h2>🔍 Results for "<%= searchQuery %>"</h2>
            <a href="${pageContext.request.contextPath}/" style="color:var(--text-secondary);text-decoration:none;font-size:0.9rem">Clear search</a>
        </div>
        <% if (!searchResults.isEmpty()) { %>
        <div class="card-grid">
            <% for (Song s : searchResults) { %>
            <div class="card" style="cursor:pointer" onclick="window.location.href='${pageContext.request.contextPath}/playlist/detail?id=0'">
                <div class="card-cover">
                    <% if (s.getFilePath() != null && !s.getFilePath().isEmpty()) { %>
                        <img src="<%= s.getFilePath() %>" alt="<%= s.getTitle() %>">
                    <% } else { %>
                        <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;font-size:2rem;background:linear-gradient(135deg,var(--bg-highlight),var(--bg-surface))">🎵</div>
                    <% } %>
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title"><%= s.getTitle() %></div>
                <div class="card-desc"><%= s.getArtist() %><%= s.getAlbum() != null ? " • " + s.getAlbum() : "" %></div>
            </div>
            <% } %>
        </div>
        <% } else { %>
            <div style="text-align:center;padding:3rem;color:var(--text-secondary)">No results found. Try a different song or artist.</div>
        <% } %>
        <% } %>

        <!-- 📋 PUBLIC PLAYLISTS -->
        <% if (publicPlaylists != null && !publicPlaylists.isEmpty()) { %>
        <div class="section-header">
            <h2>📋 Public Playlists</h2>
        </div>
        <div class="card-grid">
            <% for (Playlist p : publicPlaylists) { %>
            <div class="card" style="cursor:pointer" onclick="window.location.href='${pageContext.request.contextPath}/playlist/detail?id=<%=p.getId()%>'">
                <div class="card-cover" style="background:linear-gradient(135deg, rgba(139,92,246,0.3), rgba(236,72,153,0.2));display:flex;align-items:center;justify-content:center">
                    <span style="font-size:3rem">📋</span>
                    <div class="play-btn" style="opacity:1;transform:translateY(0)">▶</div>
                </div>
                <div class="card-title"><%= p.getName() %></div>
                <% if (p.getDescription() != null && !p.getDescription().isEmpty()) { %>
                    <div class="card-desc"><%= p.getDescription() %></div>
                <% } %>
                <small style="color:var(--text-secondary);font-size:0.8rem">by User #<%= p.getUserId() %></small>
            </div>
            <% } %>
        </div>
        <% } %>

        <!-- 🌟 ABOUT & CONTACT CARDS (WITH REDIRECTS) -->
        <div class="section-header"><h2>🌟 About & Contact</h2></div>
        <div class="card-grid" style="grid-template-columns:repeat(auto-fit,minmax(320px,1fr))">
            <!-- About Card - CLICKABLE -->
            <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/about'">
                <h3 style="color:var(--text-primary);margin-bottom:0.5rem">🎵 About TuneHub</h3>
                <p style="color:var(--text-secondary);line-height:1.6;margin-bottom:1rem">
                    TuneHub is a modern, secure music management platform built with Java, JSP, Servlets & MySQL. 
                    Designed for both admins and users, it features role-based dashboards, dynamic playlist management, 
                    and a responsive Spotify-inspired interface.
                </p>
                <div style="display:flex;flex-wrap:wrap;gap:0.5rem">
                    <span class="badge">Java 8+</span><span class="badge">JSP/Servlets</span>
                    <span class="badge">MySQL</span><span class="badge">MVC Architecture</span>
                </div>
                <small style="color:var(--brand-green);font-weight:600;margin-top:0.5rem;display:block">Click to learn more →</small>
            </div>

            <!-- Contact Card - CLICKABLE -->
            <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/contact'">
                <h3 style="color:var(--text-primary);margin-bottom:0.5rem">📬 Contact Support</h3>
                <p style="color:var(--text-secondary);margin-bottom:1rem">Have questions, feedback, or need help? Reach out below.</p>
                <div class="contact-row">
                    <span>✉️</span> <span>support@tunehub.com</span>
                </div>
                <div class="contact-row">
                    <span>📍</span> <span style="color:var(--text-secondary)">TuneHub HQ, Digital Campus</span>
                </div>
                <div class="contact-row">
                    <span>⏱️</span> <span style="color:var(--text-secondary)">Response within 24 hours</span>
                </div>
                <small style="color:var(--brand-green);font-weight:600;margin-top:0.5rem;display:block">Click to contact us →</small>
            </div>

            <!-- Features Card -->
            <div class="card">
                <h3 style="color:var(--text-primary);margin-bottom:0.5rem">⚡ Why TuneHub?</h3>
                <ul style="color:var(--text-secondary);list-style:none;padding:0;margin:0">
                    <li style="padding:0.4rem 0;border-bottom:1px solid var(--border)">🔐 Secure role-based access & session management</li>
                    <li style="padding:0.4rem 0;border-bottom:1px solid var(--border)">📋 Create, share & manage custom playlists instantly</li>
                    <li style="padding:0.4rem 0;border-bottom:1px solid var(--border)">🎨 Spotify-inspired dark UI & responsive design</li>
                    <li style="padding:0.4rem 0">🚀 Optimized queries & clean MVC architecture</li>
                </ul>
            </div>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 TuneHub. Built for music lovers. All rights reserved.</p>
    </footer>
</body>
</html>