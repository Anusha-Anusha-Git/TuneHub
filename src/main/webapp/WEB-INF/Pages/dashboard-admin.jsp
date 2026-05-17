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
        :root{--bg:#0a0a0a;--sf:#141414;--sf2:#1f1f1f;--t:#f0f0f0;--t2:#a0a0a0;--p:#8b5cf6;--g:#10b981;--r:#ef4444;--b:rgba(255,255,255,0.08);--rd:10px}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:system-ui,sans-serif;background:var(--bg);color:var(--t);min-height:100vh;display:flex;flex-direction:column;font-size:0.9rem}
        header{background:rgba(10,10,10,0.95);backdrop-filter:blur(16px);border-bottom:1px solid var(--b);padding:0.75rem 1.5rem;position:sticky;top:0}
        .nav{max-width:1200px;margin:0 auto;display:flex;justify-content:space-between;align-items:center}
        .logo{font-size:1.3rem;font-weight:800;background:linear-gradient(135deg,var(--g),var(--p));-webkit-background-clip:text;color:transparent}
        nav{display:flex;gap:0.75rem}nav a{color:var(--t2);text-decoration:none;padding:0.4rem 0.8rem;border-radius:6px;font-size:0.85rem}nav a:hover{color:var(--t);background:var(--sf)}
        .container{max-width:1200px;margin:1.5rem auto;padding:0 1rem;flex:1}
        .tabs{display:flex;gap:0.4rem;margin-bottom:1rem;border-bottom:1px solid var(--b);padding-bottom:0.4rem}
        .tab{padding:0.5rem 1rem;border-radius:6px;cursor:pointer;font-weight:600;background:transparent;color:var(--t2);transition:0.2s;font-size:0.85rem}
        .tab:hover{background:var(--sf2);color:var(--t)}.tab.active{background:var(--p);color:#000}
        .tab-content{display:none}.tab-content.active{display:block}
        .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem}
        .card{background:var(--sf);border:1px solid var(--b);border-radius:var(--rd);padding:1rem}
        .card h3{color:var(--g);margin-bottom:0.75rem;font-size:1rem}
        .form-group{margin-bottom:0.6rem}.form-group label{display:block;font-size:0.8rem;color:var(--t2);margin-bottom:0.3rem}
        input{width:100%;padding:0.5rem;background:var(--sf2);border:1px solid var(--b);border-radius:6px;color:var(--t);font-size:0.85rem}input:focus{outline:none;border-color:var(--p)}
        .btn{padding:0.5rem 0.9rem;border:none;border-radius:6px;cursor:pointer;font-weight:500;color:#fff;background:var(--p);transition:0.2s;font-size:0.85rem}.btn:hover{opacity:0.9}
        .btn-danger{background:var(--r)}.btn-sm{padding:0.25rem 0.5rem;font-size:0.8rem}
        table{width:100%;border-collapse:collapse;font-size:0.85rem}th,td{padding:0.6rem 0.5rem;text-align:left;border-bottom:1px solid var(--b)}th{color:var(--t2);font-size:0.75rem;text-transform:uppercase;font-weight:600}tr:hover{background:var(--sf2)}
        .cover{width:36px;height:36px;border-radius:4px;object-fit:cover;background:var(--sf2)}
        .alert{padding:0.6rem;border-radius:6px;margin-bottom:0.75rem;font-size:0.8rem}.alert-e{background:rgba(239,68,68,0.15);color:#fca5a5}
        footer{text-align:center;padding:1.5rem;color:var(--t2);font-size:0.8rem;margin-top:auto;border-top:1px solid var(--b)}
        @media(max-width:768px){.nav{flex-direction:column;gap:0.5rem;text-align:center}nav{width:100%;justify-content:center}.grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
    <header><div class="nav"><div class="logo">👑 Admin</div><nav>
    <a href="${pageContext.request.contextPath}/">Home</a>
   <a href="${pageContext.request.contextPath}/admin?action=editProfile">Edit Profile</a>
    <a href="${pageContext.request.contextPath}/logout" onclick="return confirm('Are you sure you want to log out?')">Logout</a>
</nav></div></header>

    <div class="container">
        <!-- ✅ WORKING TABS -->
        <div class="tabs">
            <div class="tab active" onclick="showTab('songs', this)">🎵 Songs</div>
            <div class="tab" onclick="showTab('users', this)">👥 Users</div>
            <div class="tab" onclick="showTab('add', this)">➕ Add Song</div>
        </div>

        <div id="songs" class="tab-content active">
            <h3 style="color:var(--g);margin-bottom:0.75rem">All Songs (<%= songs!=null?songs.size():0 %>)</h3>
            <div class="card">
                <table><thead><tr><th>Cover</th><th>Title</th><th>Artist</th><th>Album</th><th>Actions</th></tr></thead>
                <tbody>
                    <% if (songs != null && !songs.isEmpty()) { for (Song s : songs) { 
                        String cover = s.getFilePath();
                        if(cover==null || cover.isEmpty()) cover = "https://via.placeholder.com/36x36/1a1a1a/8b5cf6?text="+java.net.URLEncoder.encode(s.getTitle().substring(0,1),"UTF-8");
                    %>
                    <tr>
                        <td><img src="<%=cover%>" class="cover" onerror="this.src='https://via.placeholder.com/36x36/1a1a1a/8b5cf6?text=🎵'"></td>
                        <td><%= s.getTitle() %></td><td><%= s.getArtist() %></td><td><%= s.getAlbum()!=null?s.getAlbum():"-" %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin?action=editSong&id=<%=s.getId()%>" class="btn btn-sm">Edit</a>
                            <form action="${pageContext.request.contextPath}/admin" method="post" style="display:inline;margin-left:0.3rem" onsubmit="return confirm('Delete <%=s.getTitle()%>?')">
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
            <h3 style="color:var(--g);margin-bottom:0.75rem">👥 All Users</h3>
            <div class="grid">
                <% if (users != null && !users.isEmpty()) { for (User u : users) { 
                    List<String> uPls = (plsMap != null) ? plsMap.getOrDefault(u.getId(), new ArrayList<>()) : new ArrayList<>();
                %>
                <div class="card">
                    <div style="display:flex;align-items:center;gap:0.75rem;margin-bottom:0.75rem">
                        <div style="width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,var(--p),var(--g));display:flex;align-items:center;justify-content:center;font-weight:700;font-size:1rem"><%=u.getUsername().substring(0,1).toUpperCase()%></div>
                        <div><strong style="font-size:0.95rem"><%=u.getUsername()%></strong><br><small style="color:var(--t2);font-size:0.8rem"><%=u.getEmail()%></small></div>
                    </div>
                    <small style="color:var(--t2);display:block;margin-bottom:0.5rem">Role: <%=u.getRole().toUpperCase()%> • Joined: <%=u.getCreatedAt()!=null?u.getCreatedAt().toString().substring(0,10):"-"%></small>
                    <% if(!uPls.isEmpty()){ %>
                    <div style="background:var(--sf2);padding:0.5rem;border-radius:6px;margin-bottom:0.5rem">
                        <strong style="color:var(--t2);font-size:0.75rem">Playlists:</strong>
                        <div style="margin-top:0.3rem"><% for(String pl : uPls){ %><div style="padding:0.2rem 0;border-bottom:1px solid var(--b);font-size:0.8rem">📋 <%=pl%></div><% } %></div>
                    </div><% } %>
                    <% if(!"admin".equals(u.getRole()) && u.getId()!=cu.getId()){ %>
                    <form action="${pageContext.request.contextPath}/admin" method="post" onsubmit="return confirm('Delete <%=u.getUsername()%>?')">
                        <input type="hidden" name="action" value="deleteUser"><input type="hidden" name="id" value="<%=u.getId()%>">
                        <button type="submit" class="btn btn-sm btn-danger" style="width:100%;font-size:0.8rem">Delete User</button>
                    </form><% } %>
                </div><% } } %>
            </div>
        </div>

        <div id="add" class="tab-content">
            <div class="card">
                <% 
                    com.tunehub.model.Song editSong = (com.tunehub.model.Song) request.getAttribute("editSong");
                    boolean isEditing = (editSong != null);
                    String songId = isEditing ? String.valueOf(editSong.getId()) : "";
                    String titleVal = isEditing ? editSong.getTitle() : "";
                    String artistVal = isEditing ? editSong.getArtist() : "";
                    String albumVal = isEditing && editSong.getAlbum() != null ? editSong.getAlbum() : "";
                    String coverVal = isEditing && editSong.getFilePath() != null ? editSong.getFilePath() : "";
                %>
                <h3 style="color:var(--g);margin-bottom:0.75rem"><%= isEditing ? "✏️ Edit Song" : "➕ Add New Song" %></h3>
                
                <% if(isEditing) { %>
                <div style="background:rgba(139,92,246,0.1);padding:0.5rem;border-radius:6px;margin-bottom:0.75rem;display:flex;justify-content:space-between;align-items:center;font-size:0.85rem">
                    <span>Editing: <strong><%= editSong.getTitle() %></strong></span>
                    <a href="${pageContext.request.contextPath}/admin" style="color:var(--g);text-decoration:none">← Cancel</a>
                </div>
                <% } %>
                
                <form action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="saveSong">
                    <% if(isEditing) { %><input type="hidden" name="id" value="<%= editSong.getId() %>"><% } %>
                    
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.75rem;margin-bottom:0.75rem">
                        <div class="form-group"><label>Title *</label><input type="text" name="title" required value="<%= titleVal %>"></div>
                        <div class="form-group"><label>Artist *</label><input type="text" name="artist" required value="<%= artistVal %>"></div>
                        <div class="form-group"><label>Album</label><input type="text" name="album" value="<%= albumVal %>"></div>
                        <div class="form-group"><label>Cover URL</label><input type="url" name="file_path" value="<%= coverVal %>"></div>
                    </div>
                    <button type="submit" class="btn" style="width:100%;font-size:0.85rem"><%= isEditing ? "💾 Update" : "✅ Save" %></button>
                </form>
            </div>
        </div>
    </div>
    
    <footer>&copy; 2026 TuneHub</footer>
    
    <!-- ✅ TAB SWITCHING SCRIPT -->
    <script>
    function showTab(tabId, tabElement) {
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
        tabElement.classList.add('active');
        document.getElementById(tabId).classList.add('active');
    }
    <% if (request.getAttribute("editSong") != null) { %>
    document.addEventListener('DOMContentLoaded', function() {
        var addTab = document.querySelector('.tab[onclick*="add"]');
        if(addTab) addTab.click();
    });
    <% } %>
    </script>
</body>
</html>