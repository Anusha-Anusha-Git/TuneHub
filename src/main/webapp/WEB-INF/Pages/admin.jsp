<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Admin Dashboard | TuneHub</title>
  <link rel="stylesheet" href="CSS/dashboard.css" />
</head>

<body>

<div class="container">

  <!-- HEADER -->
  <header class="header">
    <h1 class="welcome-title">
      Admin Dashboard ⚙️
    </h1>
    <p class="welcome-subtitle">
      Manage users and songs across the system.
    </p>
  </header>

  <div class="grid">

    <!-- LEFT: USERS -->
    <div class="sidebar">

      <div class="card">
        <h2>All Users</h2>

        <ul class="song-list">
        <%
          List<Map<String, String>> users = (List<Map<String, String>>) request.getAttribute("users");
          if (users != null && !users.isEmpty()) {
            for (Map<String, String> user : users) {
        %>

          <li class="song-item">
            <div class="song-details">
              <h3><%= users.getString("name") %></h3>
              <p><%= users.getString("email") %></p>
            </div>

            <a href="DeleteUserController?id=<%= users.getInt("id") %>">
              <button class="delete-btn">Delete</button>
            </a>
          </li>

        <%
            }
          }
        %>
        </ul>

      </div>

    </div>

    <!-- RIGHT: SONGS -->
    <div class="main-content">

      <div class="card">
        <h2>All Songs</h2>

        <ul class="song-list">
        <%
          List<Map<String, String>> songs = (List<Map<String, String>>) request.getAttribute("songs");
          if (songs != null && !songs.isEmpty()) {
            for (Map<String, String> song : songs) {
        %>

          <li class="song-item">
            <div class="song-details">
              <h3><%= songs.getString("title") %></h3>
              <p><%= songs.getString("artist") %></p>

              <div class="meta">
                <span class="badge"><%= songs.getString("genre") %></span>
              </div>
            </div>

            <a href="DeleteSongController?id=<%= songs.getInt("id") %>">
              <button class="delete-btn">Delete</button>
            </a>
          </li>

        <%
            }
          }
        %>
        </ul>

      </div>

    </div>

  </div>

</div>

</body>
</html>