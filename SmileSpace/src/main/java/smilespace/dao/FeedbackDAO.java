package smilespace.dao;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import smilespace.model.Feedback;

@Repository
@Transactional
public class FeedbackDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private final RowMapper<Feedback> feedbackRowMapper = (rs, rowNum) -> {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getInt("feedback_id"));
        
        // Handle null user_id
        Object userIdObj = rs.getObject("user_id");
        if (userIdObj != null) {
            if (userIdObj instanceof Number) {
                feedback.setUserId(((Number) userIdObj).intValue());
            } else if (userIdObj instanceof String) {
                try {
                    feedback.setUserId(Integer.parseInt((String) userIdObj));
                } catch (NumberFormatException e) {
                    feedback.setUserId(null);
                }
            }
        } else {
            feedback.setUserId(null);
        }
        
        feedback.setName(rs.getString("name"));
        feedback.setEmail(rs.getString("email"));
        feedback.setMessage(rs.getString("message"));
        feedback.setCategory(rs.getString("category"));
        feedback.setSentiment(rs.getString("sentiment"));
        feedback.setResolved(rs.getBoolean("is_resolved"));
        feedback.setReplyMessage(rs.getString("reply_message"));
        
        Timestamp replyTimestamp = rs.getTimestamp("reply_date");
        if (replyTimestamp != null) {
            feedback.setReplyDate(new Date(replyTimestamp.getTime()));
        }
        
        Timestamp createdTimestamp = rs.getTimestamp("created_at");
        if (createdTimestamp != null) {
            feedback.setCreatedAt(new Date(createdTimestamp.getTime()));
        }
        
        feedback.setUserFullName(rs.getString("user_full_name"));
        feedback.setUserRole(rs.getString("user_role"));
        
        // Handle rating field if it exists
        try {
            feedback.setRating(rs.getInt("rating"));
        } catch (SQLException e) {
            // Rating column might not exist, ignore
        }
        
        return feedback;
    };
    
    public boolean createFeedback(Feedback feedback, Integer userId) {
        String sql = "INSERT INTO feedback (user_id, name, email, message, category, sentiment, rating) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try {
            int affectedRows = jdbcTemplate.update(sql,
                userId,
                feedback.getName(),
                feedback.getEmail(),
                feedback.getMessage(),
                feedback.getCategory() != null ? feedback.getCategory() : "General",
                feedback.getSentiment() != null ? feedback.getSentiment() : "Neutral",
                feedback.getRating()
            );
            
            if (affectedRows > 0) {
                // Get the last inserted ID
                Integer feedbackId = jdbcTemplate.queryForObject(
                    "SELECT LAST_INSERT_ID()", Integer.class);
                
                if (feedbackId != null) {
                    logHistory(feedbackId, userId, "CREATE", 
                        "Feedback submitted with sentiment: " + feedback.getSentiment());
                    return true;
                }
            }
        } catch (Exception e) {
            System.err.println("Error creating feedback: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public Feedback getFeedbackById(int feedbackId) {
        String sql = "SELECT f.*, u.full_name as user_full_name, u.user_role " +
                    "FROM feedback f " +
                    "LEFT JOIN users u ON f.user_id = u.user_id " +
                    "WHERE f.feedback_id = ?";
        
        try {
            return jdbcTemplate.queryForObject(sql, feedbackRowMapper, feedbackId);
        } catch (Exception e) {
            System.err.println("Error getting feedback by ID: " + e.getMessage());
            return null;
        }
    }
    
    public List<Feedback> getAllFeedback() {
        String sql = "SELECT f.*, u.full_name as user_full_name, u.user_role " +
                    "FROM feedback f " +
                    "LEFT JOIN users u ON f.user_id = u.user_id " +
                    "ORDER BY f.created_at DESC";
        
        try {
            return jdbcTemplate.query(sql, feedbackRowMapper);
        } catch (Exception e) {
            System.err.println("Error getting all feedback: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    public List<Feedback> getFeedbackByUserId(int userId) {
        String sql = "SELECT f.*, u.full_name as user_full_name, u.user_role " +
                    "FROM feedback f " +
                    "LEFT JOIN users u ON f.user_id = u.user_id " +
                    "WHERE f.user_id = ? " +
                    "ORDER BY f.created_at DESC";
        
        try {
            return jdbcTemplate.query(sql, feedbackRowMapper, userId);
        } catch (Exception e) {
            System.err.println("Error getting feedback by user ID: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    public boolean updateFeedbackReply(int feedbackId, String replyMessage, Integer replierUserId) {
        String sql = "UPDATE feedback SET reply_message = ?, reply_date = CURRENT_TIMESTAMP, is_resolved = TRUE WHERE feedback_id = ?";
        
        try {
            int affectedRows = jdbcTemplate.update(sql, replyMessage, feedbackId);
            
            if (affectedRows > 0) {
                String details = replyMessage.length() > 50 ? 
                    replyMessage.substring(0, 50) + "..." : replyMessage;
                logHistory(feedbackId, replierUserId, "REPLY", "Reply sent: " + details);
                return true;
            }
        } catch (Exception e) {
            System.err.println("Error updating feedback reply: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean markAsResolved(int feedbackId, Integer userId) {
        String sql = "UPDATE feedback SET is_resolved = TRUE WHERE feedback_id = ?";
        
        try {
            int affectedRows = jdbcTemplate.update(sql, feedbackId);
            
            if (affectedRows > 0) {
                logHistory(feedbackId, userId, "RESOLVE", "Marked as resolved");
                return true;
            }
        } catch (Exception e) {
            System.err.println("Error marking feedback as resolved: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Feedback> searchFeedback(String searchTerm, String sentiment, String status) {
        StringBuilder sql = new StringBuilder(
            "SELECT f.*, u.full_name as user_full_name, u.user_role " +
            "FROM feedback f " +
            "LEFT JOIN users u ON f.user_id = u.user_id " +
            "WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (f.message LIKE ? OR f.name LIKE ? OR u.full_name LIKE ?)");
            String searchParam = "%" + searchTerm + "%";
            params.add(searchParam);
            params.add(searchParam);
            params.add(searchParam);
        }
        
        if (sentiment != null && !"All Sentiments".equals(sentiment) && !sentiment.isEmpty()) {
            sql.append(" AND f.sentiment = ?");
            params.add(sentiment);
        }
        
        if (status != null && !"All Status".equals(status) && !status.isEmpty()) {
            if ("Resolved".equals(status)) {
                sql.append(" AND f.is_resolved = TRUE");
            } else if ("New".equals(status)) {
                sql.append(" AND f.is_resolved = FALSE");
            }
        }
        
        sql.append(" ORDER BY f.created_at DESC");
        
        try {
            return jdbcTemplate.query(sql.toString(), feedbackRowMapper, params.toArray());
        } catch (Exception e) {
            System.err.println("Error searching feedback: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public Map<String, Integer> getFeedbackStats() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(*) as total, " +
                    "SUM(CASE WHEN sentiment = 'Positive' THEN 1 ELSE 0 END) as positive, " +
                    "SUM(CASE WHEN sentiment = 'Neutral' THEN 1 ELSE 0 END) as neutral, " +
                    "SUM(CASE WHEN sentiment = 'Negative' THEN 1 ELSE 0 END) as negative, " +
                    "SUM(CASE WHEN is_resolved = TRUE THEN 1 ELSE 0 END) as resolved " +
                    "FROM feedback";
        
        try {
            Map<String, Object> result = jdbcTemplate.queryForMap(sql);
            
            stats.put("total", ((Number) result.get("total")).intValue());
            stats.put("positive", ((Number) result.getOrDefault("positive", 0)).intValue());
            stats.put("neutral", ((Number) result.getOrDefault("neutral", 0)).intValue());
            stats.put("negative", ((Number) result.getOrDefault("negative", 0)).intValue());
            stats.put("resolved", ((Number) result.getOrDefault("resolved", 0)).intValue());
            
        } catch (Exception e) {
            System.err.println("Error getting feedback stats: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    public List<Map<String, Object>> getFeedbackHistory(int feedbackId) {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "SELECT fh.*, u.full_name as performed_by " +
                    "FROM feedback_history fh " +
                    "LEFT JOIN users u ON fh.user_id = u.user_id " +
                    "WHERE fh.feedback_id = ? " +
                    "ORDER BY fh.performed_at DESC";
        
        try {
            history = jdbcTemplate.queryForList(sql, feedbackId);
        } catch (Exception e) {
            System.err.println("Error getting feedback history: " + e.getMessage());
            e.printStackTrace();
        }
        
        return history;
    }
    
    private void logHistory(int feedbackId, Integer userId, String actionType, String details) {
        String sql = "INSERT INTO feedback_history (feedback_id, user_id, action_type, action_details) VALUES (?, ?, ?, ?)";
        
        try {
            jdbcTemplate.update(sql, feedbackId, userId, actionType, details);
        } catch (Exception e) {
            System.err.println("Error logging feedback history: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public Map<String, Integer> getCategoryStats() {
        Map<String, Integer> categoryStats = new HashMap<>();
        String sql = "SELECT category, COUNT(*) as count FROM feedback GROUP BY category ORDER BY count DESC";
        
        try {
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);
            for (Map<String, Object> row : results) {
                categoryStats.put((String) row.get("category"), ((Number) row.get("count")).intValue());
            }
        } catch (Exception e) {
            System.err.println("Error getting category stats: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categoryStats;
    }
}