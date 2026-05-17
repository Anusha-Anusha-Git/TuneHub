<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*,java.util.*" %>
<%
    Playlist pl = (Playlist) request.getAttribute("playlist");
    List<Song> songs = (List<Song>) request.getAttribute("playlistSongs");
    if (pl == null) { response.sendRedirect(request.getContextPath() + "/profile"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= pl.getName() %> - TuneHub</title>
    <style>
        :root { --bg:#0a0a0a; --sf:#141414; --sf2:#1f1f1f; --t:#f0f0f0; --t2:#a0a0a0; --p:#8b5cf6; --g:#10b981; --r:#ef4444; --b:rgba(255,255,255,0.08); --rd:12px; }
        * { box-sizing:border-box; margin:0; padding:0; }
        body { font-family:system-ui,-apple-system,sans-serif; background:var(--bg); color:var(--t); min-height:100vh; display:flex; flex-direction:column; }
        
        header { background:rgba(10,10,10,0.95); backdrop-filter:blur(16px); border-bottom:1px solid var(--b); padding:1rem 2rem; position:sticky; top:0; z-index:100; }
        .nav { max-width:1200px; margin:0 auto; display:flex; justify-content:space-between; align-items:center; }
        .logo { font-size:1.5rem; font-weight:800; background:linear-gradient(135deg,var(--g),var(--p)); -webkit-background-clip:text; color:transparent; }
        nav { display:flex; gap:1rem; }
        nav a { color:var(--t2); text-decoration:none; padding:0.5rem 1rem; border-radius:8px; transition:0.2s; }
        nav a:hover { color:var(--t); background:var(--sf); }
        
        .container { max-width:1000px; margin:2rem auto; padding:0 1.5rem; flex:1; }
        
        .playlist-header {
            background:linear-gradient(180deg, rgba(139,92,246,0.2) 0%, var(--bg) 100%);
            padding:2rem;
            border-radius:var(--rd);
            margin-bottom:1.5rem;
            border:1px solid var(--b);
        }
        .playlist-title { font-size:2rem; font-weight:800; margin-bottom:0.5rem; }
        .playlist-meta { display:flex; gap:0.75rem; align-items:center; flex-wrap:wrap; color:var(--t2); font-size:0.9rem; margin-bottom:0.75rem; }
        .badge { background:var(--sf2); padding:0.25rem 0.65rem; border-radius:6px; font-size:0.8rem; }
        .playlist-desc { color:var(--t2); margin-top:0.5rem; line-height:1.5; max-width:600px; }
        
        .song-table { width:100%; border-collapse:collapse; background:var(--sf); border-radius:var(--rd); overflow:hidden; border:1px solid var(--b); }
        .song-table th, .song-table td { padding:0.85rem 1rem; text-align:left; border-bottom:1px solid var(--b); }
        .song-table th { background:var(--sf2); color:var(--t2); font-size:0.75rem; text-transform:uppercase; letter-spacing:0.5px; font-weight:600; }
        .song-table tr:last-child td { border-bottom:none; }
        .song-table tr:hover { background:rgba(255,255,255,0.03); }
        
        .song-num { color:var(--t2); width:40px; text-align:center; font-size:0.9rem; }
        .song-title { font-weight:600; }
        .song-meta { font-size:0.85rem; color:var(--t2); }
        
        .empty-state { text-align:center; padding:3rem; background:var(--sf); border-radius:var(--rd); border:1px solid var(--b); color:var(--t2); }
        
        footer { text-align:center; padding:2rem; color:var(--t2); font-size:0.85rem; margin-top:auto; border-top:1px solid var(--b); }
        @media(max-width:768px) { .playlist-header { padding:1.5rem; } .playlist-title { font-size:1.5rem; } .song-table th, .song-table td { padding:0.7rem 0.6rem; font-size:0.9rem; } }
    </style>
</head>
<body>
    <header>
        <div class="nav">
            <div class="logo">🎵 TuneHub</div>
            <nav>
                <a href="${pageContext.request.contextPath}/profile">← Back to Dashboard</a>
                <a href="${pageContext.request.contextPath}/">Home</a>
            </nav>
        </div>
    </header>

    <div class="container">
        <div class="playlist-header">
            <h1 class="playlist-title"><%= pl.getName() %></h1>
            <div class="playlist-meta">
                <span class="badge"><%= pl.isPublic() ? "🌐 Public" : "🔒 Private" %></span>
                <span><%= songs != null ? songs.size() : 0 %> tracks</span>
                <span>Created by you</span>
            </div>
            <% if(pl.getDescription() != null && !pl.getDescription().isEmpty()) { %>
                <p class="playlist-desc"><%= pl.getDescription() %></p>
            <% } %>
        </div>

        <% if(songs != null && !songs.isEmpty()) { %>
            <table class="song-table">
                <thead>
                    <tr>
                        <th style="width:50px">#</th>
                        <th>Title</th>
                        <th>Artist</th>
                        <th>Album</th>
                    </tr>
                </thead>
                <tbody>
                    <% int i = 1; for(Song s : songs) { %>
                    <tr>
                        <td class="song-num"><%= i++ %></td>
                        <td><span class="song-title"><%= s.getTitle() %></span></td>
                        <td class="song-meta"><%= s.getArtist() %></td>
                        <td class="song-meta"><%= s.getAlbum() != null ? s.getAlbum() : "Unknown" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-state">This playlist is empty. Add songs from your dashboard.</div>
        <% } %>
    </div>

    <footer>&copy; 2026 TuneHub</footer>
</body>
</html>