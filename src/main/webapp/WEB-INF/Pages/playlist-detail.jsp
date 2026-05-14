<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*,java.util.*" %>
<%
    Playlist pl = (Playlist) request.getAttribute("playlist");
    List<Song> songs = (List<Song>) request.getAttribute("playlistSongs");
    User cu = (User) request.getAttribute("currentUser");
    if(pl == null) { response.sendRedirect(request.getContextPath()+"/profile"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title><%= pl.getName() %> - TuneHub</title>
    <style>
        :root{--bg:#0a0a0a;--sf:#141414;--sf2:#1f1f1f;--t:#f0f0f0;--t2:#a0a0a0;--g:#10b981;--p:#8b5cf6;--b:rgba(255,255,255,0.08);--rd:12px}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:system-ui,sans-serif;background:var(--bg);color:var(--t);min-height:100vh}
        header{background:rgba(10,10,10,0.95);backdrop-filter:blur(16px);padding:1rem 2rem;border-bottom:1px solid var(--b)}
        .nav{max-width:1400px;margin:0 auto;display:flex;justify-content:space-between;align-items:center}
        .logo{font-size:1.5rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:1rem} nav a{color:var(--t2);text-decoration:none;padding:0.5rem 1rem;border-radius:8px;transition:0.2s} nav a:hover{color:var(--t);background:var(--sf)}
        .header-hero{max-width:1400px;margin:0 auto;padding:3rem 2rem 1.5rem;background:linear-gradient(180deg, rgba(139,92,246,0.4) 0%, var(--bg) 100%);display:flex;align-items:flex-end;gap:2rem}
        .pl-cover{width:230px;height:230px;background:linear-gradient(135deg,var(--p),var(--g));border-radius:8px;box-shadow:0 8px 30px rgba(0,0,0,0.5);display:flex;align-items:center;justify-content:center;font-size:4rem}
        .pl-info h1{font-size:3rem;font-weight:900;margin-bottom:0.5rem}
        .pl-info p{color:var(--t2);font-size:1rem}
        .pl-meta{font-size:0.9rem;color:var(--t2);margin-top:0.5rem}
        .container{max-width:1400px;margin:0 auto;padding:1rem 2rem 4rem}
        table{width:100%;border-collapse:collapse;margin-top:1.5rem}
        th,td{padding:0.8rem 1rem;text-align:left;border-bottom:1px solid var(--b)}
        th{color:var(--t2);font-size:0.8rem;text-transform:uppercase}
        tr:hover{background:var(--sf)}
        .song-row{display:flex;align-items:center;gap:1rem}
        .cover{width:45px;height:45px;border-radius:4px;object-fit:cover;background:var(--sf2)}
        .btn{padding:0.6rem 1rem;border:none;border-radius:8px;cursor:pointer;font-weight:500;background:var(--g);color:#000;transition:0.2s}.btn:hover{transform:scale(1.05)}
        .alert{padding:0.8rem;border-radius:8px;margin-bottom:1rem;background:rgba(239,68,68,0.15);color:#fca5a5}
        @media(max-width:768px){.header-hero{flex-direction:column;text-align:center}.pl-cover{width:180px;height:180px}}
    </style>
</head>
<body>
    <header><div class="nav"><div class="logo">🎵 TuneHub</div><nav><a href="${pageContext.request.contextPath}/profile">← Back</a><a href="${pageContext.request.contextPath}/">Home</a></nav></div></header>
    
    <div class="header-hero">
        <div class="pl-cover">📋</div>
        <div class="pl-info">
            <p style="font-size:0.8rem;text-transform:uppercase;font-weight:700;letter-spacing:1px">Playlist</p>
            <h1><%= pl.getName() %></h1>
            <% if(pl.getDescription()!=null && !pl.getDescription().isEmpty()){ %><p><%= pl.getDescription() %></p><% } %>
            <div class="pl-meta">
                <%= pl.getCreatorName() %> • <%= pl.getSongCount() %> songs
                <% if(pl.isPublic()){ %><span style="margin-left:0.5rem;background:rgba(16,185,129,0.2);color:#6ee7b7;padding:2px 6px;border-radius:4px;font-size:0.8rem">Public</span><% } %>
            </div>
        </div>
    </div>

    <div class="container">
        <% if(request.getAttribute("error")!=null){ %><div class="alert"><%= request.getAttribute("error") %></div><% } %>
        <% if(songs != null && !songs.isEmpty()){ %>
        <table>
            <thead><tr><th>#</th><th>Song</th><th>Album</th><th>Duration</th><th>Action</th></tr></thead>
            <tbody>
                <% int i=1; for(Song s : songs){ %>
                <tr>
                    <td><%= i++ %></td>
                    <td>
                        <div class="song-row">
                            <!-- ✅ ALBUM COVER IMAGE WITH FALLBACK -->
                            <% if(s.getFilePath()!=null && !s.getFilePath().isEmpty()){ %>
                                <img src="<%=s.getFilePath()%>" class="cover" alt="<%=s.getTitle()%>">
                            <% } else { %>
                                <div class="cover" style="display:flex;align-items:center;justify-content:center;font-size:1.2rem">🎵</div>
                            <% } %>
                            <div><strong><%= s.getTitle() %></strong><br><small style="color:var(--t2)"><%= s.getArtist() %></small></div>
                        </div>
                    </td>
                    <td><%= s.getAlbum()!=null?s.getAlbum():"Unknown"%></td>
                    <td><%= s.getDuration()>0?(s.getDuration()/60)+":"+String.format("%02d",s.getDuration()%60):"-:-" %></td>
                    <td><button class="btn" onclick="alert('Playback coming soon!')">▶ Play</button></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
            <div style="text-align:center;padding:3rem;color:var(--t2)">This playlist is empty. Add songs from your dashboard.</div>
        <% } %>
    </div>
</body>
</html>