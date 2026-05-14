<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*,java.util.*" %>
<%
    User cu = (User) session.getAttribute("user");
    if (cu == null) { response.sendRedirect(request.getContextPath() + "/login?error=Login required"); return; }
    
    List<Song> allSongs = (List<Song>) request.getAttribute("userSongs");
    List<Playlist> myPls = (List<Playlist>) request.getAttribute("userPlaylists");
    List<Song> results = (List<Song>) request.getAttribute("results");
    String query = (String) request.getAttribute("query");
    
    boolean isSearchMode = (results != null && query != null);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>My Library</title>
    <style>
        :root{--bg:#0a0a0a;--sf:#141414;--sf2:#1f1f1f;--t:#f0f0f0;--t2:#a0a0a0;--p:#8b5cf6;--g:#10b981;--r:#ef4444;--b:rgba(255,255,255,0.08);--rd:12px}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:system-ui,sans-serif;background:var(--bg);color:var(--t);min-height:100vh;display:flex;flex-direction:column}
        header{background:rgba(10,10,10,0.95);backdrop-filter:blur(16px);border-bottom:1px solid var(--b);padding:1rem 2rem;position:sticky;top:0}
        .nav{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center}.logo{font-size:1.5rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:1rem}nav a{color:var(--t2);text-decoration:none;padding:0.5rem 1rem;border-radius:8px;transition:0.2s}nav a:hover{color:var(--t);background:var(--sf)}
        .container{max-width:1400px;margin:2rem auto;padding:0 1.5rem;flex:1}
        .main-grid{display:grid;grid-template-columns:350px 1fr;gap:1.5rem;margin-top:1.5rem}
        .card{background:var(--sf);border:1px solid var(--b);border-radius:var(--rd);padding:1.5rem}
        .card h3{color:var(--g);margin-bottom:1rem;font-size:1.1rem}
        .playlist-grid{display:grid;grid-template-columns:repeat(auto-fill, minmax(150px, 1fr));gap:1rem;margin-top:1rem}
        .playlist-card{background:var(--sf2);border-radius:8px;padding:1rem;cursor:pointer;transition:0.2s;position:relative}
        .playlist-card:hover{transform:translateY(-2px);background:var(--b)}
        .playlist-card.default{border:2px solid var(--g)}
        .playlist-icon{height:100px;background:linear-gradient(135deg,var(--p),#4c1d95);border-radius:6px;margin-bottom:0.5rem;display:flex;align-items:center;justify-content:center;font-size:2rem}
        .btn{padding:0.6rem 1rem;border:none;border-radius:8px;cursor:pointer;font-weight:500;color:#fff;background:var(--p);transition:0.2s}.btn:hover{opacity:0.9}
        .btn-sm{padding:0.3rem 0.6rem;font-size:0.8rem}
        .alert{padding:0.8rem;border-radius:8px;margin-bottom:1rem}.alert-e{background:rgba(239,68,68,0.15);color:#fca5a5}.alert-o{background:rgba(16,185,129,0.15);color:#6ee7b7}
        .list{max-height:600px;overflow-y:auto}.item{padding:0.6rem 0;border-bottom:1px solid var(--b);display:flex;justify-content:space-between;align-items:center;gap:0.5rem}
        .item:last-child{border:none}
        .song-row{display:flex;align-items:center;gap:0.8rem;flex:1}
        .cover{width:45px;height:45px;border-radius:4px;object-fit:cover;background:var(--sf2)}
        select{-webkit-appearance:none;background:var(--sf2) url("image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='10' viewBox='0 0 24 24' fill='%23a0a0a0'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E") no-repeat right 0.5rem center;padding:0.4rem 1.5rem 0.4rem 0.8rem;border:1px solid var(--b);border-radius:6px;color:var(--t);cursor:pointer;font-size:0.85rem}
        select:focus{outline:none;border-color:var(--p)}
        select:disabled{opacity:0.5;cursor:not-allowed}
        .search-mode .available-songs{display:none}
        footer{text-align:center;padding:2rem;color:var(--t2);font-size:0.85rem;margin-top:auto;border-top:1px solid var(--b)}
        @media(max-width:900px){.main-grid{grid-template-columns:1fr}.nav{flex-direction:column;gap:1rem;text-align:center}nav{width:100%;justify-content:center}}
    </style>
</head>
<body class="<%= isSearchMode ? "search-mode" : "" %>">
    <header><div class="nav"><div class="logo">🎵 My Library</div><nav><a href="${pageContext.request.contextPath}/">Home</a><a href="${pageContext.request.contextPath}/logout">Logout</a></nav></div></header>
    
    <div class="container">
        <h2>👋 Welcome, <%= cu.getUsername() %>!</h2>
        <% if(request.getParameter("error")!=null){ %><div class="alert alert-e"><%= request.getParameter("error") %></div><% } %>
        <% if(request.getParameter("msg")!=null){ %><div class="alert alert-o"><%= request.getParameter("msg") %></div><% } %>

        <!-- Search Bar -->
        <form action="${pageContext.request.contextPath}/search" method="get" style="display:flex;gap:0.5rem;margin:1rem 0;max-width:400px">
            <input type="text" name="q" value="<%= query != null ? query : "" %>" placeholder="Search songs..." style="flex:1;padding:0.6rem;background:var(--sf2);border:1px solid var(--b);border-radius:8px;color:var(--t)">
            <button type="submit" class="btn">🔍</button>
        </form>

        <% if (isSearchMode) { %>
        <!-- ✅ SEARCH RESULTS ONLY -->
        <div class="card">
            <h3>🔍 Search Results for "<%= query %>" (<%= results.size() %>)</h3>
            <div class="list">
                <% for (Song s : results) { %>
                <div class="item">
                    <div class="song-row">
                        <img src="<%=s.getFilePath()!=null?s.getFilePath():"https://via.placeholder.com/45x45/1a1a1a/8b5cf6?text=🎵"%>" class="cover">
                        <div><strong><%=s.getTitle()%></strong><br><small style="color:var(--t2)"><%=s.getArtist()%></small></div>
                    </div>
                    <span style="color:var(--t2);font-size:0.85rem">Search mode - add disabled</span>
                </div>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <!-- ✅ NORMAL VIEW: Playlists Left, Songs Right -->
        <div class="main-grid">
            <!-- Left: Playlists -->
            <div class="card">
                <h3>📁 Your Playlists (<%= myPls != null ? myPls.size() : 0 %>)</h3>
                <form action="${pageContext.request.contextPath}/playlist" method="post" style="margin-bottom:1rem">
                    <input type="hidden" name="action" value="create">
                    <input type="text" name="name" placeholder="New playlist name" required style="width:100%;margin-bottom:0.5rem;padding:0.5rem;background:var(--sf2);border:1px solid var(--b);border-radius:6px;color:var(--t)">
                    <button type="submit" class="btn" style="width:100%">+ Create Playlist</button>
                </form>
                <div class="playlist-grid">
                    <% if (myPls != null) { for (Playlist p : myPls) { 
                        boolean isDefault = (p.getUserId() == 1); // Admin-owned = default
                    %>
                    <div class="playlist-card <%= isDefault ? "default" : "" %>" onclick="window.location.href='${pageContext.request.contextPath}/playlist/detail?id=<%=p.getId()%>'">
                        <div class="playlist-icon"><%= isDefault ? "🎯" : "📋" %></div>
                        <strong style="font-size:0.9rem"><%= p.getName() %></strong>
                        <div style="font-size:0.75rem;color:var(--t2);margin-top:0.2rem"><%= isDefault ? "Default (Admin)" : (p.isPublic()?"🌐 Public":"🔒 Private") %></div>
                    </div>
                    <% } } %>
                </div>
            </div>

            <!-- Right: Available Songs -->
            <div class="card available-songs">
                <h3>🎵 Available Songs (<%= allSongs != null ? allSongs.size() : 0 %>)</h3>
                <div class="list">
                    <% if (allSongs != null && !allSongs.isEmpty()) { for (Song s : allSongs) { %>
                    <div class="item">
                        <div class="song-row">
                            <img src="<%=s.getFilePath()!=null?s.getFilePath():"https://via.placeholder.com/45x45/1a1a1a/8b5cf6?text=🎵"%>" class="cover">
                            <div><strong><%=s.getTitle()%></strong><br><small style="color:var(--t2)"><%=s.getArtist()%></small></div>
                        </div>
                        <form action="${pageContext.request.contextPath}/playlist" method="post">
                            <input type="hidden" name="action" value="addSong">
                            <input type="hidden" name="song_id" value="<%=s.getId()%>">
                            <select name="playlist_id" onchange="if(this.value)this.closest('form').submit();">
                                <option value="">Add to...</option>
                                <% if(myPls!=null){for(Playlist p:myPls){ 
                                    boolean canEdit = (p.getUserId() == cu.getId());
                                    if(canEdit){ %>
                                <option value="<%=p.getId()%>"><%=p.getName()%></option>
                                <% } }} %>
                            </select>
                        </form>
                    </div>
                    <% } } else { %><div style="text-align:center;padding:1rem;color:var(--t2)">No songs available.</div><% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <footer>&copy; 2026 TuneHub</footer>
</body>
</html>