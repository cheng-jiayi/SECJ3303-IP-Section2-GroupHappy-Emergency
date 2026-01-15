package smilespace.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import smilespace.model.User;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Logger;

@Repository
public class UserDAO {
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());
    
    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public UserDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new UserRowMapper(), userId);
        } catch (Exception e) {
            logger.severe("Error getting user by ID: " + e.getMessage());
            return null;
        }
    }
    
    public User getUserByUsername(String username) {
        logger.info("getUserByUsername called for: " + username);
        String sql = "SELECT * FROM users WHERE username = ?";
        try {
            User user = jdbcTemplate.queryForObject(sql, new UserRowMapper(), username);
            logger.info("User found: " + username);
            return user;
        } catch (Exception e) {
            logger.info("User NOT found: " + username);
            return null;
        }
    }
    
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new UserRowMapper(), email);
        } catch (Exception e) {
            logger.severe("Error getting user by email: " + e.getMessage());
            return null;
        }
    }
    
    public List<User> getAllUsers() {
        String sql = "SELECT * FROM users ORDER BY full_name";
        return jdbcTemplate.query(sql, new UserRowMapper());
    }
    
    public List<User> getUsersByRole(String role) {
        String sql = "SELECT * FROM users WHERE user_role = ? ORDER BY full_name";
        return jdbcTemplate.query(sql, new UserRowMapper(), role);
    }
    
    public List<User> getActiveUsers() {
        String sql = "SELECT * FROM users WHERE is_active = TRUE ORDER BY full_name";
        return jdbcTemplate.query(sql, new UserRowMapper());
    }
    
    public boolean createUser(User user) {
        String sql = "INSERT INTO users (username, email, password_hash, full_name, user_role, " +
                     "phone, matric_number, faculty, year, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            int affectedRows = jdbcTemplate.update(sql,
                user.getUsername(),
                user.getEmail(),
                user.getPasswordHash(),
                user.getFullName(),
                user.getUserRole(),
                user.getPhone(),
                user.getMatricNumber(),
                user.getFaculty(),
                user.getYear(),
                user.isActive()
            );
            return affectedRows > 0;
        } catch (Exception e) {
            logger.severe("Error creating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET email = ?, full_name = ?, phone = ?, " +
                     "matric_number = ?, faculty = ?, year = ? WHERE user_id = ?";
        
        try {
            int affectedRows = jdbcTemplate.update(sql,
                user.getEmail(),
                user.getFullName(),
                user.getPhone(),
                user.getMatricNumber(),
                user.getFaculty,
                user.getYear(),
                user.getUserId()
            );
            return affectedRows > 0;
        } catch (Exception e) {
            logger.severe("Error updating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try {
            int affectedRows = jdbcTemplate.update(sql, userId);
            return affectedRows > 0;
        } catch (Exception e) {
            logger.severe("Error deleting user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deactivateUser(int userId) {
        String sql = "UPDATE users SET is_active = FALSE WHERE user_id = ?";
        try {
            int affectedRows = jdbcTemplate.update(sql, userId);
            return affectedRows > 0;
        } catch (Exception e) {
            logger.severe("Error deactivating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean activateUser(int userId) {
        String sql = "UPDATE users SET is_active = TRUE WHERE user_id = ?";
        try {
            int affectedRows = jdbcTemplate.update(sql, userId);
            return affectedRows > 0;
        } catch (Exception e) {
            logger.severe("Error activating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateLastLogin(int userId) {
        String sql = "UPDATE users SET last_login = NOW() WHERE user_id = ?";
        try {
            int affectedRows = jdbcTemplate.update(sql, userId);
            return affectedRows > 0;
        } catch (Exception e) {
            logger.severe("Error updating last login: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updatePassword(int userId, String passwordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
        try {
            int affectedRows = jdbcTemplate.update(sql, passwordHash, userId);
            return affectedRows > 0;
        } catch (Exception e) {
            logger.severe("Error updating password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try {
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, username);
            return count != null && count > 0;
        } catch (Exception e) {
            logger.severe("Error checking username: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean checkEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try {
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
            return count != null && count > 0;
        } catch (Exception e) {
            logger.severe("Error checking email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    private static class UserRowMapper implements RowMapper<User> {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setEmail(rs.getString("email"));
            user.setPasswordHash(rs.getString("password_hash"));
            user.setFullName(rs.getString("full_name"));
            user.setUserRole(rs.getString("user_role"));
            user.setPhone(rs.getString("phone"));
            user.setMatricNumber(rs.getString("matric_number"));
            user.setFaculty(rs.getString("faculty"));
            
            Integer year = rs.getInt("year");
            if (rs.wasNull()) {
                year = null;
            }
            user.setYear(year);
            
            Timestamp createdAt = rs.getTimestamp("created_at");
            if (createdAt != null) {
                user.setCreatedAt(createdAt.toLocalDateTime());
            }
            
            Timestamp lastLogin = rs.getTimestamp("last_login");
            if (lastLogin != null) {
                user.setLastLogin(lastLogin.toLocalDateTime());
            }
            
            user.setActive(rs.getBoolean("is_active"));
            
            return user;
        }
    }

    public List<User> getAtRiskStudents() {
        String sql = "SELECT * FROM users WHERE user_role = 'student' " +
                    "AND risk_level IN ('HIGH', 'MEDIUM') " +
                    "ORDER BY " +
                    "CASE risk_level " +
                    "    WHEN 'HIGH' THEN 1 " +
                    "    WHEN 'MEDIUM' THEN 2 " +
                    "    ELSE 3 " +
                    "END, " +
                    "mood_stability ASC";
        return jdbcTemplate.query(sql, new AtRiskUserRowMapper());
    }

    public User getAtRiskStudentById(int studentId) {
        String sql = "SELECT * FROM users WHERE user_id = ? AND user_role = 'student'";
        try {
            return jdbcTemplate.queryForObject(sql, new AtRiskUserRowMapper(), studentId);
        } catch (Exception e) {
            return null;
        }
    }

    // New RowMapper for at-risk students (includes risk fields)
    private static class AtRiskUserRowMapper implements RowMapper<User> {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setEmail(rs.getString("email"));
            user.setFullName(rs.getString("full_name"));
            user.setUserRole(rs.getString("user_role"));
            user.setPhone(rs.getString("phone"));
            user.setMatricNumber(rs.getString("matric_number"));
            user.setFaculty(rs.getString("faculty"));
            
            Integer year = rs.getInt("year");
            if (rs.wasNull()) {
                year = null;
            }
            user.setYear(year);
            
            // Risk assessment fields
            user.setRiskLevel(rs.getString("risk_level"));
            user.setRecentMood(rs.getString("recent_mood"));
            user.setMoodStability(rs.getDouble("mood_stability"));
            user.setFrequentTags(rs.getString("frequent_tags"));
            user.setAssessmentCategory(rs.getString("assessment_category"));
            
            Timestamp createdAt = rs.getTimestamp("created_at");
            if (createdAt != null) {
                user.setCreatedAt(createdAt.toLocalDateTime());
            }
            
            user.setActive(rs.getBoolean("is_active"));
            
            return user;
        }
    }
}
