<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TuneHub - Home</title>
    
    <style>
        /* ===== PREMIUM RESET & VARIABLES ===== */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        
        :root {
            --bg-base: #000000;
            --bg-surface: #121212;
            --bg-highlight: #1a1a1a;
            --text-primary: #ffffff;
            --text-secondary: #b3b3b3;
            --brand-green: #1db954;
            --brand-green-hover: #1ed760;
            --accent-purple: #8b5cf6;
            --accent-pink: #ec4899;
            --border: rgba(255,255,255,0.08);
            --shadow-sm: rgba(0,0,0,0.3);
            --shadow-lg: rgba(0,0,0,0.5);
        }

        body {
            font-family: 'Circular', -apple-system, BlinkMacSystemFont, 'Inter', 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: var(--bg-base);
            color: var(--text-primary);
            line-height: 1.5;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ===== ANIMATED BACKGROUND ===== */
        body::before {
            content: '';
            position: fixed;
            top: -50%;
            right: -20%;
            width: 80%;
            height: 150%;
            background: radial-gradient(circle, rgba(139,92,246,0.15) 0%, transparent 70%);
            pointer-events: none;
            z-index: -1;
        }
        body::after {
            content: '';
            position: fixed;
            bottom: -30%;
            left: -10%;
            width: 60%;
            height: 100%;
            background: radial-gradient(circle, rgba(236,72,153,0.1) 0%, transparent 70%);
            pointer-events: none;
            z-index: -1;
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
            transition: all 0.3s ease;
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
            letter-spacing: -0.5px;
        }
        nav { display: flex; gap: 2rem; align-items: center; }
        nav a {
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.2s ease;
            position: relative;
        }
        nav a::after {
            content: '';
            position: absolute;
            bottom: -4px;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--brand-green);
            transition: width 0.3s ease;
        }
        nav a:hover { color: var(--text-primary); }
        nav a:hover::after { width: 100%; }
        nav a.btn-green {
            background: var(--brand-green);
            color: #000000;
            padding: 0.75rem 2rem;
            border-radius: 500px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 4px 14px rgba(29,185,84,0.4);
        }
        nav a.btn-green::after { display: none; }
        nav a.btn-green:hover { 
            background: var(--brand-green-hover); 
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(29,185,84,0.5);
        }

        /* ===== HERO SECTION WITH GLASS CARD ===== */
        .hero {
            max-width: 1600px;
            margin: 0 auto;
            padding: 4rem 3rem 3rem;
            position: relative;
        }
        .hero-card {
            background: linear-gradient(135deg, rgba(139,92,246,0.2), rgba(236,72,153,0.1));
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 24px;
            padding: 3.5rem;
            backdrop-filter: blur(20px);
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
        }
        .hero-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -20%;
            width: 80%;
            height: 200%;
            background: radial-gradient(circle, rgba(29,185,84,0.15) 0%, transparent 60%);
            transform: rotate(-15deg);
            pointer-events: none;
        }
        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 700px;
        }
        .hero h1 {
            font-size: 4rem;
            font-weight: 900;
            line-height: 1.05;
            margin-bottom: 1.2rem;
            letter-spacing: -2px;
            background: linear-gradient(135deg, #fff, #a5b4fc);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        .hero p {
            font-size: 1.25rem;
            color: var(--text-secondary);
            margin-bottom: 2.5rem;
            line-height: 1.6;
        }
        .hero-btns { 
            display: flex; 
            gap: 1.2rem; 
            flex-wrap: wrap; 
        }
        .btn {
            padding: 1rem 2.5rem;
            border-radius: 500px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            font-size: 1.05rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            letter-spacing: -0.3px;
        }
        .btn-green {
            background: var(--brand-green);
            color: #000000;
            box-shadow: 0 4px 14px rgba(29,185,84,0.4);
        }
        .btn-green:hover { 
            background: var(--brand-green-hover); 
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 8px 24px rgba(29,185,84,0.5);
        }
        .btn-outline {
            background: rgba(255,255,255,0.1);
            color: var(--text-primary);
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(10px);
        }
        .btn-outline:hover { 
            background: rgba(255,255,255,0.2);
            border-color: #ffffff;
            transform: translateY(-3px);
        }

        /* ===== MAIN CONTENT ===== */
        main { 
            max-width: 1600px; 
            margin: 0 auto; 
            padding: 2rem 3rem 4rem; 
        }
        
        /* ===== SECTION HEADERS ===== */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.8rem;
            margin-top: 2.5rem;
        }
        .section-header h2 { 
            font-size: 1.8rem; 
            font-weight: 800;
            letter-spacing: -0.5px;
        }
        .section-header a { 
            color: var(--text-secondary); 
            text-decoration: none; 
            font-size: 0.9rem; 
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: color 0.2s;
        }
        .section-header a:hover { 
            color: var(--text-primary);
            text-decoration: underline;
        }

        /* ===== PREMIUM CARD GRID ===== */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 2rem;
        }
        .card {
            background: var(--bg-surface);
            border-radius: 12px;
            padding: 1.2rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            cursor: pointer;
            overflow: hidden;
            border: 1px solid var(--border);
        }
        .card:hover { 
            background: var(--bg-highlight);
            transform: translateY(-6px);
            box-shadow: 0 12px 32px var(--shadow-lg);
        }
        
        .card-cover {
            width: 100%;
            aspect-ratio: 1;
            border-radius: 8px;
            margin-bottom: 1.2rem;
            position: relative;
            box-shadow: 0 8px 24px var(--shadow-sm);
            overflow: hidden;
        }
        .card-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .card:hover .card-cover img {
            transform: scale(1.05);
        }
        
        /* Green Play Button */
        .play-btn {
            position: absolute;
            bottom: 0.8rem;
            right: 0.8rem;
            width: 52px; 
            height: 52px;
            background: var(--brand-green);
            color: #000;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            opacity: 0;
            transform: translateY(12px);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 8px 16px rgba(0,0,0,0.4);
            cursor: pointer;
        }
        .card:hover .play-btn { 
            opacity: 1; 
            transform: translateY(0);
        }
        .play-btn:hover {
            transform: scale(1.1);
            background: var(--brand-green-hover);
        }
        
        .card-title {
            font-weight: 700;
            font-size: 1.05rem;
            margin-bottom: 0.35rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .card-desc {
            font-size: 0.9rem;
            color: var(--text-secondary);
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* ===== ARTIST CIRCLES ===== */
        .artist-row {
            display: flex;
            gap: 2.5rem;
            overflow-x: auto;
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
            scrollbar-width: none;
        }
        .artist-row::-webkit-scrollbar { display: none; }
        .artist {
            text-align: center;
            min-width: 150px;
            cursor: pointer;
            transition: transform 0.3s ease;
        }
        .artist:hover { transform: translateY(-8px); }
        .artist-avatar {
            width: 130px; 
            height: 130px;
            border-radius: 50%;
            margin: 0 auto 1rem;
            overflow: hidden;
            box-shadow: 0 8px 24px var(--shadow-lg);
            position: relative;
        }
        .artist-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .artist:hover .artist-avatar img {
            transform: scale(1.1);
        }
        .artist-name { 
            font-weight: 700; 
            font-size: 0.95rem;
            transition: color 0.2s;
        }
        .artist:hover .artist-name { color: var(--brand-green); }

        /* ===== FEATURES SECTION ===== */
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin: 3rem 0 4rem;
        }
        .feature-box {
            background: linear-gradient(135deg, rgba(255,255,255,0.05), rgba(255,255,255,0.02));
            padding: 2rem;
            border-radius: 16px;
            border: 1px solid var(--border);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .feature-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: linear-gradient(90deg, var(--brand-green), var(--accent-purple));
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        .feature-box:hover {
            transform: translateY(-4px);
            border-color: rgba(29,185,84,0.3);
            box-shadow: 0 12px 32px rgba(0,0,0,0.4);
        }
        .feature-box:hover::before { transform: scaleX(1); }
        .feature-box h3 { 
            margin-bottom: 0.75rem; 
            color: var(--text-primary);
            font-size: 1.2rem;
        }
        .feature-box p { 
            color: var(--text-secondary); 
            font-size: 0.95rem;
            line-height: 1.6;
        }

        /* ===== PREMIUM FOOTER ===== */
        footer {
            background: var(--bg-surface);
            padding: 4rem 3rem 2rem;
            margin-top: 4rem;
            border-top: 1px solid var(--border);
        }
        .footer-c { 
            max-width: 1600px; 
            margin: 0 auto; 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); 
            gap: 3rem; 
        }
        .footer-col h4 { 
            color: var(--text-primary); 
            margin-bottom: 1.2rem; 
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.95rem;
        }
        .footer-col a { 
            display: block; 
            color: var(--text-secondary); 
            text-decoration: none; 
            margin-bottom: 0.9rem; 
            font-size: 0.95rem; 
            transition: all 0.2s;
        }
        .footer-col a:hover { 
            color: var(--text-primary);
            transform: translateX(4px);
        }
        .footer-bottom { 
            max-width: 1600px; 
            margin: 3rem auto 0; 
            padding-top: 2.5rem; 
            border-top: 1px solid var(--border); 
            text-align: center; 
            color: var(--text-secondary); 
            font-size: 0.9rem;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            header { padding: 1rem 2rem; }
            .hero { padding: 3rem 2rem 2rem; }
            .hero-card { padding: 2.5rem; }
            .hero h1 { font-size: 3rem; }
            main { padding: 1.5rem 2rem 3rem; }
            .card-grid { grid-template-columns: repeat(3, 1fr); gap: 1.5rem; }
        }
        @media (max-width: 768px) {
            .nav-c { flex-direction: column; gap: 1.2rem; }
            nav { width: 100%; justify-content: center; flex-wrap: wrap; }
            .hero h1 { font-size: 2.4rem; }
            .hero-card { padding: 2rem; }
            .card-grid { grid-template-columns: repeat(2, 1fr); }
            .artist { min-width: 120px; }
            .artist-avatar { width: 110px; height: 110px; }
        }
        @media (max-width: 480px) {
            .hero h1 { font-size: 2rem; }
            .hero p { font-size: 1.1rem; }
            .hero-btns { flex-direction: column; }
            .btn { width: 100%; }
            .card-grid { grid-template-columns: 1fr; }
            .section-header h2 { font-size: 1.5rem; }
        }
    </style>
</head>
<body>
    <header>
        <div class="nav-c">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/search">Search</a>
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

    <section class="hero">
        <div class="hero-card">
            <div class="hero-content">
                <h1>Listening is everything</h1>
                <p>Millions of songs and podcasts. No credit card needed. Start your musical journey today with TuneHub's premium features.</p>
                <div class="hero-btns">
                    <% if (session.getAttribute("user") == null) { %>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-green">Get TuneHub Free</a>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Log In</a>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-green">Open Library</a>
                    <% } %>
                </div>
            </div>
        </div>
    </section>

    <main>
        <!-- Popular Artists -->
        <div class="section-header">
            <h2>Popular Artists</h2>
            <a href="#">Show all</a>
        </div>
        <div class="artist-row">
            <div class="artist">
                <div class="artist-avatar">
                    <img src="https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=400&fit=crop" alt="Artist">
                </div>
                <div class="artist-name">The Weeknd</div>
            </div>
            <div class="artist">
                <div class="artist-avatar">
                    <img src="https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&h=400&fit=crop" alt="Artist">
                </div>
                <div class="artist-name">Arctic Monkeys</div>
            </div>
            <div class="artist">
                <div class="artist-avatar">
                    <img src="https://images.unsplash.com/photo-1516280440614-6697288d5d38?w=400&h=400&fit=crop" alt="Artist">
                </div>
                <div class="artist-name">Dua Lipa</div>
            </div>
            <div class="artist">
                <div class="artist-avatar">
                    <img src="https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=400&h=400&fit=crop" alt="Artist">
                </div>
                <div class="artist-name">Daft Punk</div>
            </div>
            <div class="artist">
                <div class="artist-avatar">
                    <img src="https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=400&fit=crop" alt="Artist">
                </div>
                <div class="artist-name">Miles Davis</div>
            </div>
            <div class="artist">
                <div class="artist-avatar">
                    <img src="https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=400&h=400&fit=crop" alt="Artist">
                </div>
                <div class="artist-name">Billie Eilish</div>
            </div>
        </div>

        <!-- Made For You -->
        <div class="section-header">
            <h2>Made For You</h2>
            <a href="#">Show all</a>
        </div>
        <div class="card-grid">
            <div class="card">
                <div class="card-cover">
                    <img src="https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400&h=400&fit=crop" alt="Playlist">
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title">Chill Vibes</div>
                <div class="card-desc">Unwind with smooth lo-fi beats and ambient melodies.</div>
            </div>
            <div class="card">
                <div class="card-cover">
                    <img src="https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&h=400&fit=crop" alt="Playlist">
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title">Workout Energy</div>
                <div class="card-desc">High-tempo tracks to fuel your fitness routine.</div>
            </div>
            <div class="card">
                <div class="card-cover">
                    <img src="https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=400&fit=crop" alt="Playlist">
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title">Late Night Synth</div>
                <div class="card-desc">Neon dreams and retro synths for midnight drives.</div>
            </div>
            <div class="card">
                <div class="card-cover">
                    <img src="https://images.unsplash.com/photo-1446057032654-9d8885db76c6?w=400&h=400&fit=crop" alt="Playlist">
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title">Acoustic Morning</div>
                <div class="card-desc">Gentle guitar strums to start your day right.</div>
            </div>
            <div class="card">
                <div class="card-cover">
                    <img src="https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&h=400&fit=crop" alt="Playlist">
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title">Party Mix 2026</div>
                <div class="card-desc">The hottest bangers to keep the dance floor packed.</div>
            </div>
        </div>

        <!-- Recently Played -->
        <div class="section-header">
            <h2>Recently Played</h2>
            <a href="#">Show all</a>
        </div>
        <div class="card-grid">
            <div class="card">
                <div class="card-cover">
                    <img src="https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?w=400&h=400&fit=crop" alt="Album">
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title">Midnight Sessions</div>
                <div class="card-desc">New album drop • 12 tracks</div>
            </div>
            <div class="card">
                <div class="card-cover">
                    <img src="https://images.unsplash.com/photo-1507838153414-b4b713384ebd?w=400&h=400&fit=crop" alt="Album">
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title">Classical Focus</div>
                <div class="card-desc">Instrumental masterpieces for deep work.</div>
            </div>
            <div class="card">
                <div class="card-cover">
                    <img src="https://images.unsplash.com/photo-1496293455970-f8581aae0e3b?w=400&h=400&fit=crop" alt="Album">
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title">Top Hits 2026</div>
                <div class="card-desc">The biggest global tracks this month.</div>
            </div>
            <div class="card">
                <div class="card-cover">
                    <img src="https://images.unsplash.com/photo-1520523839774-a8e6f54b0e07?w=400&h=400&fit=crop" alt="Album">
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title">Piano Dreams</div>
                <div class="card-desc">Solo piano pieces for relaxation.</div>
            </div>
            <div class="card">
                <div class="card-cover">
                    <img src="https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=400&h=400&fit=crop" alt="Album">
                    <div class="play-btn">▶</div>
                </div>
                <div class="card-title">Bass Boosted</div>
                <div class="card-desc">Heavy drops and electronic beats.</div>
            </div>
        </div>

        <!-- Features -->
        <div class="section-header">
            <h2>Why TuneHub?</h2>
        </div>
        <div class="features">
            <div class="feature-box">
                <h3>🔐 Secure by Design</h3>
                <p>Salted SHA-256 hashing, automatic lockouts, and secure sessions. Your account stays protected with enterprise-grade security.</p>
            </div>
            <div class="feature-box">
                <h3>👑 Role-Based Dashboards</h3>
                <p>Admins manage catalogs & users. Members control personal libraries & custom playlists with intuitive interfaces.</p>
            </div>
            <div class="feature-box">
                <h3>⚡ Blazing Fast</h3>
                <p>Optimized JDBC queries, prepared statements, and indexed searches. Zero lag, pure music streaming experience.</p>
            </div>
        </div>
    </main>

    <footer>
        <div class="footer-c">
            <div class="footer-col">
                <h4>Company</h4>
                <a href="#">About</a>
                <a href="#">Jobs</a>
                <a href="#">For the Record</a>
            </div>
            <div class="footer-col">
                <h4>Communities</h4>
                <a href="#">For Artists</a>
                <a href="#">Developers</a>
                <a href="#">Advertising</a>
                <a href="#">Investors</a>
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
                <a href="#">Family</a>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 TuneHub. Built for music lovers. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>