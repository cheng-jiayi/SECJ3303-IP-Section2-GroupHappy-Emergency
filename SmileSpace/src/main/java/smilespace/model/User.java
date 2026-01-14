package smilespace.model;

import java.time.LocalDateTime;

public class User {
    private int userId;
    private String username;
    private String email;
    private String passwordHash;
    private String fullName;
    private String userRole;
    private String phone;
    private String matricNumber;
    private String program;
    private Integer year;
    private LocalDateTime createdAt;
    private LocalDateTime lastLogin;
    private boolean isActive;
    
    // Constructors
    public User() {
        this.isActive = true;
    }
    
    public User(String username, String email, String passwordHash, String fullName, String userRole) {
        this();
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.userRole = userRole;
    }
    
    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getMatricNumber() { return matricNumber; }
    public void setMatricNumber(String matricNumber) { this.matricNumber = matricNumber; }
    
    public String getProgram() { return program; }
    public void setProgram(String program) { this.program = program; }
    
    public Integer getYear() { return year; }
    public void setYear(Integer year) { this.year = year; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    // Helper methods
    public boolean isStudent() {
        return "student".equals(userRole);
    }
    
    public boolean isFaculty() {
        return "faculty".equals(userRole);
    }
    
    public boolean isAdmin() {
        return "admin".equals(userRole);
    }
    
    public boolean isProfessional() {
        return "professional".equals(userRole);
    }
    
    public String getDisplayRole() {
        if (userRole == null) return "Unknown";
        switch (userRole) {
            case "student": return "Student";
            case "faculty": return "Faculty";
            case "admin": return "Administrator";
            case "professional": return "Mental Health Professional";
            default: return userRole;
        }
    }
}