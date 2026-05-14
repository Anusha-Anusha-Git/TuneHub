package com.tunehub.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username, email, passwordHash, salt, role;
    private java.sql.Timestamp createdAt;
    private int failedAttempts;
    private java.sql.Timestamp lockedUntil;
    
    public User() {}
    
    // Getters
    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getPasswordHash() { return passwordHash; }
    public String getSalt() { return salt; }
    public String getRole() { return role; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    
    // Setters
    public void setId(int id) { this.id = id; }
    public void setUsername(String username) { this.username = username; }
    public void setEmail(String email) { this.email = email; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public void setSalt(String salt) { this.salt = salt; }
    public void setRole(String role) { this.role = role; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }

    public int getFailedAttempts() { return failedAttempts; }
    public void setFailedAttempts(int failedAttempts) { this.failedAttempts = failedAttempts; }
    public java.sql.Timestamp getLockedUntil() { return lockedUntil; }
    public void setLockedUntil(java.sql.Timestamp lockedUntil) { this.lockedUntil = lockedUntil; }
}