package com.tunehub.model;

public class User {
    
    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private String salt;
    private String role;
    private int failedLoginAttempts;
    private boolean locked;
    private java.sql.Timestamp createdAt;
    
    public User() {}
    
    // ===== Getters =====
    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getPasswordHash() { return passwordHash; }
    public String getSalt() { return salt; }
    public String getRole() { return role; }
    public int getFailedLoginAttempts() { return failedLoginAttempts; }
    public boolean isLocked() { return locked; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    
    // ===== Setters =====
    public void setId(int id) { this.id = id; }
    public void setUsername(String username) { this.username = username; }
    public void setEmail(String email) { this.email = email; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public void setSalt(String salt) { this.salt = salt; }
    public void setRole(String role) { this.role = role; }
    public void setFailedLoginAttempts(int n) { this.failedLoginAttempts = n; }
    public void setLocked(boolean locked) { this.locked = locked; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
}