package smilespace.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import smilespace.model.Student;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.*;
import java.util.logging.Logger;

@Repository
public class StudentDAO {
    private static final Logger logger = Logger.getLogger(StudentDAO.class.getName());
    
    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public StudentDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    public List<Student> getAtRiskStudents() {
        String sql = "SELECT u.* FROM users u WHERE u.user_role = 'student' AND u.is_active = TRUE ORDER BY u.full_name";
        
        return jdbcTemplate.query(sql, new StudentRowMapper());
    }
    
    public Student getStudentById(String studentId) {
        if (studentId == null || studentId.trim().isEmpty()) {
            return null;
        }
        
        try {
            int userId = parseStudentId(studentId);
            if (userId <= 0) {
                return null;
            }
            
            String sql = "SELECT u.* FROM users u WHERE u.user_id = ? AND u.user_role = 'student'";
            
            try {
                Student student = jdbcTemplate.queryForObject(sql, new StudentRowMapper(), userId);
                enrichStudentWithMoodData(student);
                return student;
            } catch (Exception e) {
                logger.severe("Error getting student by ID: " + e.getMessage());
                return null;
            }
        } catch (NumberFormatException e) {
            logger.warning("Invalid student ID format: " + studentId);
            return null;
        }
    }
    
    public Student getStudentByUserId(int userId) {
        String sql = "SELECT u.* FROM users u WHERE u.user_id = ? AND u.user_role = 'student'";
        
        try {
            Student student = jdbcTemplate.queryForObject(sql, new StudentRowMapper(), userId);
            enrichStudentWithMoodData(student);
            return student;
        } catch (Exception e) {
            logger.severe("Error getting student by user ID: " + e.getMessage());
            return null;
        }
    }
    
    private void enrichStudentWithMoodData(Student student) {
        if (student == null) {
            return;
        }
        
        String sql = "SELECT mf.feeling_name, me.entry_date, me.tags " +
                     "FROM mood_entries me " +
                     "JOIN mood_feelings mf ON me.entry_id = mf.entry_id " +
                     "WHERE me.user_id = ? AND me.entry_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) " +
                     "ORDER BY me.entry_date DESC";
        
        try {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, student.getUserId());
            
            List<String> recentFeelings = new ArrayList<>();
            List<String> recentTags = new ArrayList<>();
            int moodEntryCount = 0;
            
            for (Map<String, Object> row : rows) {
                moodEntryCount++;
                String feeling = (String) row.get("feeling_name");
                if (feeling != null && !feeling.trim().isEmpty() && !recentFeelings.contains(feeling)) {
                    recentFeelings.add(feeling);
                }
                
                String tags = (String) row.get("tags");
                if (tags != null && !tags.trim().isEmpty()) {
                    String[] tagArray = tags.split(",");
                    for (String tag : tagArray) {
                        String trimmedTag = tag.trim();
                        if (!trimmedTag.isEmpty() && !recentTags.contains(trimmedTag)) {
                            recentTags.add(trimmedTag);
                        }
                    }
                }
            }
            
            student.setMoodEntryCount(moodEntryCount);
            
            if (!recentFeelings.isEmpty()) {
                student.setRecentMood(String.join(", ", recentFeelings));
                
                int negativeFeelings = 0;
                for (String feeling : recentFeelings) {
                    String lowerFeeling = feeling.toLowerCase();
                    if (lowerFeeling.contains("stress") || 
                        lowerFeeling.contains("anxious") || 
                        lowerFeeling.contains("sad") ||
                        lowerFeeling.contains("overwhelm")) {
                        negativeFeelings++;
                    }
                }
                
                if (negativeFeelings >= 3) {
                    student.setRiskLevel("High");
                    student.setAssessmentCategory("At Risk");
                } else if (negativeFeelings >= 1) {
                    student.setRiskLevel("Medium");
                    student.setAssessmentCategory("Monitor");
                } else {
                    student.setRiskLevel("Low");
                    student.setAssessmentCategory("Normal");
                }
            } else {
                student.setRecentMood("No mood data");
                student.setRiskLevel("Unknown");
                student.setAssessmentCategory("No assessment");
            }
            
            if (!recentTags.isEmpty()) {
                student.setFrequentTags(String.join(", ", recentTags));
            } else {
                student.setFrequentTags("No tags");
            }
            
            double stability = calculateMoodStability(student.getUserId());
            student.setMoodStability(stability);
            
        } catch (Exception e) {
            logger.warning("Error enriching student with mood data: " + e.getMessage());
            student.setRecentMood("Error loading mood data");
            student.setRiskLevel("Unknown");
            student.setAssessmentCategory("Error");
            student.setFrequentTags("Error");
            student.setMoodStability(0.0);
        }
    }
    
    private double calculateMoodStability(int userId) {
        String sql = "SELECT COUNT(DISTINCT entry_date) as days_with_entries " +
                     "FROM mood_entries " +
                     "WHERE user_id = ? AND entry_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
        
        try {
            Integer daysWithEntries = jdbcTemplate.queryForObject(sql, Integer.class, userId);
            if (daysWithEntries != null) {
                return (daysWithEntries / 30.0) * 100.0;
            }
        } catch (Exception e) {
            logger.warning("Error calculating mood stability: " + e.getMessage());
        }
        return 0.0;
    }
    
    private int parseStudentId(String studentId) {
        if (studentId == null) return 0;
        
        try {
            if (studentId.toUpperCase().startsWith("STU")) {
                String idStr = studentId.substring(3);
                return Integer.parseInt(idStr.trim());
            } else {
                return Integer.parseInt(studentId.trim());
            }
        } catch (NumberFormatException e) {
            logger.warning("Invalid student ID format: " + studentId);
            return 0;
        }
    }
    
    private static class StudentRowMapper implements RowMapper<Student> {
        @Override
        public Student mapRow(ResultSet rs, int rowNum) throws SQLException {
            Student student = new Student();
            student.setUserId(rs.getInt("user_id"));
            student.setUsername(rs.getString("username"));
            student.setFullName(rs.getString("full_name"));
            student.setEmail(rs.getString("email"));
            student.setPhone(rs.getString("phone"));
            student.setMatricNumber(rs.getString("matric_number"));
            student.setProgram(rs.getString("program"));
            student.setYear(rs.getInt("year"));
            student.setActive(rs.getBoolean("is_active"));
            
            Timestamp lastLogin = rs.getTimestamp("last_login");
            if (lastLogin != null) {
                student.setLastLogin(lastLogin.toLocalDateTime().toLocalDate());
            }
            
            return student;
        }
    }
}