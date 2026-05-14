package com.tunehub.model;

public class Song {
    private int id, duration, uploadedBy;
    private String title, artist, album, genre, filePath;
    private java.sql.Timestamp createdAt;
    
    public Song() {}
    
    // Getters
    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getArtist() { return artist; }
    public String getAlbum() { return album; }
    public String getGenre() { return genre; }
    public int getDuration() { return duration; }
    public String getFilePath() { return filePath; }
    public int getUploadedBy() { return uploadedBy; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    
    // Setters
    public void setId(int id) { this.id = id; }
    public void setTitle(String title) { this.title = title; }
    public void setArtist(String artist) { this.artist = artist; }
    public void setAlbum(String album) { this.album = album; }
    public void setGenre(String genre) { this.genre = genre; }
    public void setDuration(int duration) { this.duration = duration; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    public void setUploadedBy(int uploadedBy) { this.uploadedBy = uploadedBy; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
}