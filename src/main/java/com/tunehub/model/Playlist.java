package com.tunehub.model;

public class Playlist {
    private int id, userId, songCount;
    private String name, description, creatorName;
    private boolean isPublic;
    private java.sql.Timestamp createdAt;
    
    public Playlist() {}
    
    // Getters
    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public boolean isPublic() { return isPublic; }
    public int getSongCount() { return songCount; }
    public String getCreatorName() { return creatorName; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    
    // Setters
    public void setId(int id) { this.id = id; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setName(String name) { this.name = name; }
    public void setDescription(String description) { this.description = description; }
    public void setPublic(boolean isPublic) { this.isPublic = isPublic; }
    public void setSongCount(int songCount) { this.songCount = songCount; }
    public void setCreatorName(String creatorName) { this.creatorName = creatorName; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
}