package smilespace.model;

import java.util.Date;

public class Feedback {
    private int id;
    private Integer userId;
    private String name;
    private String email;
    private String message;
    private String category;
    private String sentiment;
    private boolean resolved;
    private String replyMessage;
    private Date replyDate;
    private Date createdAt;
    private String userFullName;
    private String userRole;
    private Integer rating; // Add this field for storing rating
    
    public Feedback() {}
    
    public Feedback(String name, String email, String message) {
        this.name = name;
        this.email = email;
        this.message = message;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getSentiment() { return sentiment; }
    public void setSentiment(String sentiment) { this.sentiment = sentiment; }
    
    public boolean isResolved() { return resolved; }
    public void setResolved(boolean resolved) { this.resolved = resolved; }
    
    public String getReplyMessage() { return replyMessage; }
    public void setReplyMessage(String replyMessage) { this.replyMessage = replyMessage; }
    
    public Date getReplyDate() { return replyDate; }
    public void setReplyDate(Date replyDate) { this.replyDate = replyDate; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }
    
    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }
    
    // Add getter and setter for rating
    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }
}