<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.*" %>
<!DOCTYPE html>

<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Dashboard | TuneHub</title>
  <style>
        body { font-family: Arial, sans-serif; background:#f0f0f0; margin:0; }
        .container { max-width:1100px; margin:auto; padding:20px; }
        .header { background:#111; color:white; padding:20px; border-radius:10px; margin-bottom:20px; }
        .grid { display:flex; gap:20px; }
        .sidebar { width:300px; flex-shrink:0; }
        .main-content { flex:1; }
        .card { background:white; padding:20px; border-radius:10px; margin-bottom:15px; box-shadow:0 1px 4px rgba(0,0,0,0.1); }
        .stat-card { background:#222; color:white; padding:15px; border-radius:10px; margin-bottom:15px; text-align:center; }
        .stat-value { font-size:2.5em; font-weight:bold; margin:5px 0; }
        .form label { display:block; margin-top:10px; font-weight:bold; font-size:0.85em; }
        .form input, .form select { width:100%; padding:8px; margin-top:4px; box-sizing:border-box; border:1px solid #ddd; border-radius:5px; }
        .form button { margin-top:15px; width:100%; padding:10px; background:#222; color:white; border:none; border-radius:5px; cursor:pointer; }
        .song-list { list-style:none; padding:0; margin:0; }
        .song-item { display:flex; justify-content:space-between; align-items:center; padding:12px; border-bottom:1px solid #eee; }
        .song-item:last-child { border-bottom:none; }
        .badge { background:#222; color:white; padding:3px 8px; border-radius:20px; font-size:0.75em; }
        .delete-btn { background:#c0392b; color:white; border:none; padding:6px 12px; border-radius:5px; cursor:pointer; }
        .empty { text-align:center; color:#999; padding:30px; }
        .logout { float:right; color:#aaa; text-decoration:none; }
        .logout:hover { color:white; }
        .error { color:red; }
        </style>
</head>
<body>
<div class="container">

    <header class="header">
        <a href="HomeController" class="logout">Logout</a>
        <h1>Hello, <%= session.getAttribute("name") != null ? session.getAttribute("name") : "Music Lover" %> 🎵</h1>
        <p>Welcome to your personal music library.</p>
    </header>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <div class="grid">

        <!-- SIDEBAR: stats + add song form -->
        <div class="sidebar">
            <div class="stat-card">
                <p>Total Songs</p>
                <%
                    List<Map<String,String>> songs = (List<Map<String,String>>) request.getAttribute("songs");
                    int count = (songs != null) ? songs.size() : 0;
                %>
                <p class="stat-value"><%= count %></p>
            </div>

            <div class="card">
                <h2>Add Song</h2>
                <%-- BUG FIX: form now has action and method so it actually submits --%>
                <form class="form" action="AddSong" method="post">
                    <label>Title</label>
                    <input type="text"   name="title"    placeholder="Song Title"  required />

                    <label>Artist</label>
                    <input type="text"   name="artist"   placeholder="Artist Name" required />

                    <label>Album</label>
                    <input type="text"   name="album"    placeholder="Album Name" />

                    <label>Genre</label>
                    <select name="genre">
                        <option>Pop</option>
                        <option>Rock</option>
                        <option>HipHop</option>
                        <option>Jazz</option>
                        <option>Classical</option>
                        <option>Electronic</option>
                        <option>Country</option>
                        <option>R&B</option>
                        <option>Other</option>
                    </select>

                    <label>Duration (seconds)</label>
                    <input type="number" name="duration" placeholder="210" min="0" />

                    <button type="submit">Add Song</button>
                </form>
            </div>
        </div>

        <!-- MAIN CONTENT: song library -->
        <div class="main-content">
            <div class="card">
                <h2>Your Library</h2>

                <% if (songs == null || songs.isEmpty()) { %>
                    <div class="empty">
                        <p>No songs added yet. Use the form on the left to add your first song!</p>
                    </div>
                <% } else { %>
                    <ul class="song-list">
                    <% for (Map<String,String> song : songs) { %>
                        <li class="song-item">
                            <div>
                                <strong><%= song.get("title") %></strong><br/>
                                <small><%= song.get("artist") %></small>
                                <div style="margin-top:5px;">
                                    <span class="badge"><%= song.get("genre") %></span>
                                    <% if (!"0".equals(song.get("duration"))) { %>
                                        <small style="color:#999; margin-left:8px;">
                                            <%= Integer.parseInt(song.get("duration"))/60 %>:<%= String.format("%02d", Integer.parseInt(song.get("duration"))%60) %>
                                        </small>
                                    <% } %>
                                </div>
                            </div>
                            <form action="DeleteSong" method="post" style="margin:0;">
                                <input type="hidden" name="songId" value="<%= song.get("id") %>" />
                                <button class="delete-btn" type="submit">Delete</button>
                            </form>
                        </li>
                    <% } %>
                    </ul>
                <% } %>
            </div>
        </div>

    </div>
</div>
</body>
</html>