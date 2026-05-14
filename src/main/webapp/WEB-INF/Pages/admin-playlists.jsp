<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*,java.util.*" %>
<%
    User cu = (User) session.getAttribute("user");
    if (cu == null || !"admin".equals(cu.getRole())) { response.sendRedirect(request.getContextPath() + "/login?error=Unauthorized"); return; }
    List<Playlist> allPlaylists = (List<Playlist>) request.getAttribute("allPlaylists");
    List<Song> allSongs = (List<Song>) request.getAttribute("songs");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Playlists</title>
    <style>
        :root{--bg:#0a0a0a;--sf:#141414;--sf2:#1f1f1f;--t:#f0f0f0;--t2:#a0a0a0;--p:#8b5cf6;--g:#10b981;--b:rgba(255,255,255,0.08);--rd:12px}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:system-ui,sans-serif;background:var(--bg);color:var(--t)}
        header{background:rgba(10,10,10,0.95);padding:1rem 2rem;border-bottom:1px solid var(--b)}
        .nav{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between}.logo{font-size:1.5rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:1rem}nav a{color:var(--t2);text-decoration:none;padding:0.5rem 1rem}nav a:hover{color:var(--t)}
        .container{max-width:1200px;margin:2rem auto;padding:0 1.5rem}
        .grid{display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;margin-top:1.5rem}
        .card{background:var(--sf);border:1px solid var(--b);border-radius:var(--rd);padding:1.5rem}
        .card h3{color:var(--g);margin-bottom:1rem}
        .item{padding:0.8rem;border-bottom:1px solid var(--b);display:flex;justify-content:space-between;align-items:center}
        .btn{padding:0.5rem 1rem;background:var(--p);color:#fff;border:none;border-radius:6px;cursor:pointer}
        select{padding:0.4rem;background:var(--sf2);border:1px solid var(--b);border-radius:6px;color:var(--t)}
    </style>
</head>
<body>
    <header><div class="nav"><div class="logo">👑 Admin Playlists</div><nav><a href="${pageContext.request.contextPath}/admin">← Back to Admin</a></nav></div></header>
    <div class="container">
        <h2>📋 Manage Default Playlists</h2>
        <div class="grid">
            <div class="card">
                <h3>All Playlists</h3>
                <% for(Playlist p : allPlaylists) { %>
                <div class="item">
                    <div><strong><%=p.getName()%></strong><br><small style="color:var(--t2)">By User #<%=p.getUserId()%></small></div>
                </div>
                <% } %>
            </div>
            <div class="card">
                <h3>Add Songs to Playlist</h3>
                <form action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="addSongToPlaylist">
                    <select name="playlist_id" style="width:100%;margin-bottom:1rem">
                        <option value="">Select Playlist...</option>
                        <% for(Playlist p : allPlaylists) { %>
                        <option value="<%=p.getId()%>"><%=p.getName()%></option>
                        <% } %>
                    </select>
                    <select name="song_id" style="width:100%;margin-bottom:1rem">
                        <option value="">Select Song...</option>
                        <% for(Song s : allSongs) { %>
                        <option value="<%=s.getId()%>"><%=s.getTitle()%> - <%=s.getArtist()%></option>
                        <% } %>
                    </select>
                    <button type="submit" class="btn">Add to Playlist</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>