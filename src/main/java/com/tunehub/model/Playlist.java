// src/main/java/com/tunehub/model/Playlist.java
package com.tunehub.model;

public class Playlist {
    private int id;
    private String name;
    private int userId;
    private String description;
    private java.sql.Timestamp createdAt;
    
    public Playlist() {}
    
    public Playlist(String name, int userId, String description) {
        this.name = name;
        this.userId = userId;
        this.description = description;
    }
    
    // ===== Getters & Setters =====
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
}