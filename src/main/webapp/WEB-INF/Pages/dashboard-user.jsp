<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*,java.util.*" %>
<%
    User cu = (User) session.getAttribute("user");
    if (cu == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<Song> allSongs = (List<Song>) request.getAttribute("userSongs");
    List<Playlist> myPls = (List<Playlist>) request.getAttribute("userPlaylists");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>My Library</title>
    <style>
        :root { --bg: #0a0a0a; --sf: #141414; --sf2: #1f1f1f; --t: #f0f0f0; --t2: #a0a0a0; --p: #8b5cf6; --g: #10b981; --r: #ef4444; --b: rgba(255,255,255,0.08); --rd: 12px; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: system-ui, -apple-system, sans-serif; background: var(--bg); color: var(--t); min-height: 100vh; display: flex; flex-direction: column; }
        header { background: rgba(10,10,10,0.95); backdrop-filter: blur(16px); border-bottom: 1px solid var(--b); padding: 1rem 2rem; position: sticky; top: 0; z-index: 100; }
        .nav { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.5rem; font-weight: 800; background: linear-gradient(135deg, var(--g), var(--p)); -webkit-background-clip: text; color: transparent; }
        nav { display: flex; gap: 1rem; }
        nav a { color: var(--t2); text-decoration: none; padding: 0.5rem 1rem; border-radius: 8px; transition: 0.2s; }
        nav a:hover { color: var(--t); background: var(--sf); }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1.5rem; flex: 1; }
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 1rem; }
        @media (max-width: 900px) { .grid { grid-template-columns: 1fr; } }
        .card { background: var(--sf); border: 1px solid var(--b); border-radius: var(--rd); padding: 1.5rem; }
        .card h3 { color: var(--g); margin-bottom: 1rem; font-size: 1.1rem; }
        .btn { padding: 0.75rem; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; color: #fff; background: var(--p); transition: 0.2s; width: 100%; }
        .btn:hover { opacity: 0.9; }
        .btn-sm { padding: 0.4rem 0.7rem; font-size: 0.85rem; }
        .btn-danger { background: var(--r); }
        .alert { padding: 0.75rem; border-radius: 8px; margin-bottom: 1rem; font-size: 0.9rem; }
        .alert-e { background: rgba(239,68,68,0.15); color: #fca5a5; }
        .alert-o { background: rgba(16,185,129,0.15); color: #6ee7b7; }
        .fg { margin-bottom: 0.8rem; }
        .fg input { width: 100%; padding: 0.75rem; background: var(--sf2); border: 1px solid var(--b); border-radius: 8px; color: var(--t); }
        .fg input:focus { outline: none; border-color: var(--p); }
        .list { max-height: 400px; overflow-y: auto; padding-right: 0.5rem; }
        .item { padding: 0.75rem 0; border-bottom: 1px solid var(--b); display: flex; justify-content: space-between; align-items: center; gap: 0.75rem; }
        .item:last-child { border: none; }
        .visibility-group { display: flex; gap: 1rem; margin: 0.75rem 0 1rem; font-size: 0.9rem; }
        .visibility-group label { display: flex; align-items: center; gap: 0.35rem; cursor: pointer; }
        select { -webkit-appearance: none; appearance: none; background: var(--sf2) url("image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='10' viewBox='0 0 24 24' fill='%23a0a0a0'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E") no-repeat right 0.7rem center/10px; padding: 0.5rem 1.5rem 0.5rem 0.8rem; border: 1px solid var(--b); border-radius: 6px; color: var(--t); font-size: 0.9rem; cursor: pointer; }
        select:focus { outline: none; border-color: var(--p); }
        footer { text-align: center; padding: 2rem; color: var(--t2); font-size: 0.85rem; margin-top: auto; border-top: 1px solid var(--b); }
    </style>
</head>
<body>
    <header>
        <div class="nav">
            <div class="logo">🎵 My Library</div>
            <nav>
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/profile">Dashboard</a>
                <a href="${pageContext.request.contextPath}/profile?action=edit">Edit Profile</a>
                <a href="${pageContext.request.contextPath}/logout" onclick="return confirm('Are you sure you want to log out?')">Logout</a>
            </nav>
        </div>
    </header>

    <div class="container">
        <h2>👋 Welcome, <%= cu.getUsername() %>!</h2>
        <% if (request.getParameter("error") != null) { %><div class="alert alert-e"><%= request.getParameter("error") %></div><% } %>
        <% if (request.getParameter("success") != null) { %><div class="alert alert-o"><%= request.getParameter("success") %></div><% } %>

        <div class="grid">
            <div class="card">
                <h3>📋 Create Playlist</h3>
                <form action="${pageContext.request.contextPath}/playlist" method="post" id="createPlaylistForm">
                    <input type="hidden" name="action" value="create">
                    <div class="fg"><input type="text" name="name" placeholder="Playlist name *" required></div>
                    <div class="fg"><input type="text" name="description" placeholder="Description (optional)"></div>
                    <div class="visibility-group">
                        <label><input type="radio" name="is_public" value="true" checked style="width:auto; margin:0"> 🌐 Public</label>
                        <label><input type="radio" name="is_public" value="false" style="width:auto; margin:0"> 🔒 Private</label>
                    </div>
                    <button type="submit" class="btn">Create</button>
                </form>

                <h3 style="margin-top: 1.5rem;">📁 Your Playlists</h3>
                <div class="list">
                    <% if (myPls != null && !myPls.isEmpty()) { for (Playlist p : myPls) { %>
                    <div class="item" style="cursor:pointer" onclick="window.location.href='${pageContext.request.contextPath}/playlist/detail?id=<%=p.getId()%>'">
                        <span><%= p.getName() %> (<%= p.isPublic() ? "🌐" : "🔒" %>)</span>
                        <form action="${pageContext.request.contextPath}/playlist" method="post" onclick="event.stopPropagation()">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="playlist_id" value="<%= p.getId() %>">
                            <button type="submit" class="btn btn-sm btn-danger">🗑️</button>
                        </form>
                    </div>
                    <% } } else { %>
                        <p style="color:var(--t2); text-align:center; padding: 1rem 0;">No playlists yet.</p>
                    <% } %>
                </div>
            </div>

            <div class="card">
                <h3>🎵 Available Songs</h3>
                <div class="list">
                    <% if (allSongs != null && !allSongs.isEmpty()) { for (Song s : allSongs) { %>
                    <div class="item">
                        <span><%= s.getTitle() %> - <%= s.getArtist() %></span>
                        <form action="${pageContext.request.contextPath}/playlist" method="post" style="display:flex; gap:0.5rem;">
                            <input type="hidden" name="action" value="addSong">
                            <input type="hidden" name="song_id" value="<%= s.getId() %>">
                            <select name="playlist_id" onchange="if(this.value) this.closest('form').submit();">
                                <option value="">Add to...</option>
                                <% if (myPls != null) { for (Playlist pl : myPls) { %>
                                    <option value="<%= pl.getId() %>"><%= pl.getName() %></option>
                                <% } } %>
                            </select>
                            <button type="submit" class="btn btn-sm">+</button>
                        </form>
                    </div>
                    <% } } else { %>
                        <p style="color:var(--t2); text-align:center; padding: 1rem 0;">No songs available.</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <footer>&copy; 2026 TuneHub</footer>
    <script>
        document.getElementById('createPlaylistForm').addEventListener('submit', function(e) {
            const isPublic = document.querySelector('input[name="is_public"]:checked').value === 'true';
            const name = document.querySelector('input[name="name"]').value;
            if (!confirm(isPublic ? `Make "${name}" PUBLIC? It will appear on the home page.` : `Make "${name}" PRIVATE? Only you will see it.`)) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>