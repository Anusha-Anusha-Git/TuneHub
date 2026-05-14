<%@ page contentType="text/html;charset=UTF-8" import="com.tunehub.model.*,java.util.*,java.util.Map" %>
<%
    User cu = (User) session.getAttribute("user");
    if (cu == null || !"admin".equals(cu.getRole())) { response.sendRedirect(request.getContextPath() + "/login?error=Unauthorized"); return; }
    List<User> users = (List<User>) request.getAttribute("users");
    List<Song> songs = (List<Song>) request.getAttribute("songs");
    Map<Integer, List<String>> plsMap = (Map<Integer, List<String>>) request.getAttribute("userPlaylistsMap");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Admin Dashboard</title>
    <style>
        :root{--bg:#0a0a0a;--sf:#141414;--sf2:#1f1f1f;--t:#f0f0f0;--t2:#a0a0a0;--p:#8b5cf6;--g:#10b981;--r:#ef4444;--b:rgba(255,255,255,0.08);--rd:12px}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:system-ui,sans-serif;background:var(--bg);color:var(--t);min-height:100vh;display:flex;flex-direction:column}
        header{background:rgba(10,10,10,0.95);backdrop-filter:blur(16px);border-bottom:1px solid var(--b);padding:1rem 2rem;position:sticky;top:0}
        .nav{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center}
        .logo{font-size:1.5rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:1rem}nav a{color:var(--t2);text-decoration:none;padding:0.5rem 1rem;border-radius:8px;transition:0.2s}nav a:hover{color:var(--t);background:var(--sf)}
        .container{max-width:1400px;margin:2rem auto;padding:0 1.5rem;flex:1}
        .tabs{display:flex;gap:0.5rem;margin-bottom:1.5rem;border-bottom:1px solid var(--b);padding-bottom:0.5rem}
        .tab{padding:0.6rem 1.2rem;border-radius:8px;cursor:pointer;font-weight:600;background:transparent;color:var(--t2);transition:0.2s;border:1px solid transparent}
        .tab:hover{background:var(--sf2);color:var(--t)}
        .tab.active{background:var(--p);color:#000;border-color:var(--p)}
        .tab-content{display:none;animation:fadeIn 0.3s ease}
        .tab-content.active{display:block}
        @keyframes fadeIn{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}
        .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:1.5rem}
        .card{background:var(--sf);border:1px solid var(--b);border-radius:var(--rd);padding:1.5rem}
        .card h3{color:var(--g);margin-bottom:1rem}
        .form-group{margin-bottom:1rem}.form-group label{display:block;font-size:0.85rem;color:var(--t2);margin-bottom:0.4rem}
        input{width:100%;padding:0.7rem;background:var(--sf2);border:1px solid var(--b);border-radius:8px;color:var(--t)}input:focus{outline:none;border-color:var(--p)}
        .btn{padding:0.6rem 1rem;border:none;border-radius:8px;cursor:pointer;font-weight:500;color:#fff;background:var(--p);transition:0.2s}.btn:hover{opacity:0.9}
        .btn-danger{background:var(--r)}.btn-sm{padding:0.3rem 0.6rem;font-size:0.8rem}
        table{width:100%;border-collapse:collapse}th,td{padding:0.8rem;text-align:left;border-bottom:1px solid var(--b)}th{color:var(--t2);font-size:0.8rem;text-transform:uppercase}tr:hover{background:var(--sf2)}
        .cover{width:45px;height:45px;border-radius:4px;object-fit:cover;background:var(--sf2)}
        .alert{padding:0.8rem;border-radius:8px;margin-bottom:1rem;background:rgba(239,68,68,0.15);color:#fca5a5;border-left:3px solid var(--r)}
        footer{text-align:center;padding:2rem;color:var(--t2);font-size:0.85rem;margin-top:auto;border-top:1px solid var(--b)}
        @media(max-width:768px){.nav{flex-direction:column;gap:1rem;text-align:center}nav{width:100%;justify-content:center}.grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
    <header><div class="nav"><div class="logo">👑 Admin</div><nav><a href="${pageContext.request.contextPath}/">Home</a><a href="${pageContext.request.contextPath}/logout">Logout</a></nav></div></header>
    <div class="container">
        <% if (request.getAttribute("error") != null) { %><div class="alert"><%= request.getAttribute("error") %></div><% } %>
        <% if (request.getParameter("msg") != null) { %><div class="alert" style="background:rgba(16,185,129,0.15);color:#6ee7b7;border-left-color:var(--g)"><%= request.getParameter("msg") %></div><% } %>
        
        <!-- ✅ WORKING TABS -->
        <div class="tabs">
            <div class="tab active" onclick="showTab('songs', this)">🎵 Songs</div>
            <div class="tab" onclick="showTab('users', this)">👥 Users</div>
            <div class="tab" onclick="showTab('add', this)">➕ Add Song</div>
        </div>

        <div id="songs" class="tab-content active">
            <h2 style="color:var(--g);margin-bottom:1rem">All Songs (<%= songs!=null?songs.size():0 %>)</h2>
            <div class="card">
                <table><thead><tr><th>Cover</th><th>Title</th><th>Artist</th><th>Album</th><th>Actions</th></tr></thead>
                <tbody>
                    <% if (songs != null && !songs.isEmpty()) { for (Song s : songs) { 
                        String cover = s.getFilePath();
                        if(cover==null || cover.isEmpty()) cover = "https://via.placeholder.com/45x45/1a1a1a/8b5cf6?text="+java.net.URLEncoder.encode(s.getTitle().substring(0,1),"UTF-8");
                    %>
                    <tr>
                        <td><img src="<%=cover%>" class="cover" onerror="this.src='https://via.placeholder.com/45x45/1a1a1a/8b5cf6?text=🎵'"></td>
                        <td><%= s.getTitle() %></td><td><%= s.getArtist() %></td><td><%= s.getAlbum()!=null?s.getAlbum():"-" %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin?action=editSong&id=<%=s.getId()%>" class="btn btn-sm">Edit</a>
                            <form action="${pageContext.request.contextPath}/admin" method="post" style="display:inline" onsubmit="return confirm('Delete <%=s.getTitle()%>?')">
                                <input type="hidden" name="action" value="deleteSong"><input type="hidden" name="id" value="<%=s.getId()%>">
                                <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } } %>
                </tbody></table>
            </div>
        </div>

        <div id="users" class="tab-content">
            <h2 style="color:var(--g);margin-bottom:1rem">👥 All Users</h2>
            <div class="grid">
                <% if (users != null && !users.isEmpty()) { for (User u : users) { 
                    List<String> uPls = (plsMap != null) ? plsMap.getOrDefault(u.getId(), new ArrayList<>()) : new ArrayList<>();
                %>
                <div class="card">
                    <div style="display:flex;align-items:center;gap:1rem;margin-bottom:1rem">
                        <div style="width:50px;height:50px;border-radius:50%;background:linear-gradient(135deg,var(--p),var(--g));display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1.2rem"><%=u.getUsername().substring(0,1).toUpperCase()%></div>
                        <div><h4 style="margin:0"><%=u.getUsername()%></h4><p style="color:var(--t2);margin:0;font-size:0.9rem"><%=u.getEmail()%></p>
                        <small style="color:var(--t2)">Role: <%=u.getRole().toUpperCase()%> • Joined: <%=u.getCreatedAt()!=null?u.getCreatedAt().toString().substring(0,10):"-"%></small></div>
                    </div>
                    <% if(!uPls.isEmpty()){ %>
                    <div style="background:var(--sf2);padding:0.8rem;border-radius:8px;margin-bottom:0.8rem">
                        <strong style="color:var(--t2);font-size:0.8rem">Playlists:</strong>
                        <div style="margin-top:0.5rem"><% for(String pl : uPls){ %><div style="padding:0.3rem 0;border-bottom:1px solid var(--b);font-size:0.9rem">📋 <%=pl%></div><% } %></div>
                    </div><% } %>
                    <% if(!"admin".equals(u.getRole()) && u.getId()!=cu.getId()){ %>
                    <form action="${pageContext.request.contextPath}/admin" method="post" onsubmit="return confirm('Delete <%=u.getUsername()%>?')">
                        <input type="hidden" name="action" value="deleteUser"><input type="hidden" name="id" value="<%=u.getId()%>">
                        <button type="submit" class="btn btn-sm btn-danger" style="width:100%">Delete User</button>
                    </form><% } %>
                </div><% } } %>
            </div>
        </div>

        <div id="add" class="tab-content">
    <div class="card">
        <% 
            com.tunehub.model.Song editSong = (com.tunehub.model.Song) request.getAttribute("editSong");
            boolean isEditing = (editSong != null);
        %>
        <h3 style="color:var(--g)"><%= isEditing ? "✏️ Edit Song" : "➕ Add New Song" %></h3>
        
        <% if(isEditing) { %>
        <div style="background:rgba(139,92,246,0.1);padding:0.8rem;border-radius:8px;margin-bottom:1rem;display:flex;justify-content:space-between;align-items:center">
            <span>Editing: <strong><%= editSong.getTitle() %></strong></span>
            <a href="${pageContext.request.contextPath}/admin" style="color:var(--g);text-decoration:none;font-weight:600">← Cancel & Return</a>
        </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/admin" method="post">
            <input type="hidden" name="action" value="saveSong">
            <% if(isEditing) { %><input type="hidden" name="id" value="<%= editSong.getId() %>"><% } %>
            
            <div class="grid" style="grid-template-columns:1fr 1fr;gap:1rem;margin-bottom:1rem">
                <div class="form-group">
                    <label>Title *</label>
                    <input type="text" name="title" required value="<%= isEditing ? editSong.getTitle() : "" %>">
                </div>
                <div class="form-group">
                    <label>Artist *</label>
                    <input type="text" name="artist" required value="<%= isEditing ? editSong.getArtist() : "" %>">
                </div>
                <div class="form-group">
                    <label>Album</label>
                    <input type="text" name="album" value="<%= isEditing ? (editSong.getAlbum()!=null?editSong.getAlbum():"") : "" %>">
                </div>
                <div class="form-group">
                    <label>Cover URL</label>
                    <input type="url" name="file_path" value="<%= isEditing ? (editSong.getFilePath()!=null?editSong.getFilePath():"") : "" %>">
                </div>
            </div>
            <button type="submit" class="btn" style="width:100%"><%= isEditing ? "💾 Update Song" : "✅ Save Song" %></button>
        </form>
    </div>
</div>
    <footer>&copy; 2026 TuneHub</footer>
    
    <!-- ✅ TAB SWITCHING SCRIPT -->
    <script>
    function showTab(tabId, tabElement) {
        // Remove active class from all tabs
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
        
        // Add active class to clicked tab
        tabElement.classList.add('active');
        document.getElementById(tabId).classList.add('active');
    }
    </script>
</body>
</html>