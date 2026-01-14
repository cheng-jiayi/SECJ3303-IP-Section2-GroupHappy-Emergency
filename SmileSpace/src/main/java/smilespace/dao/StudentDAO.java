package smilespace.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import smilespace.model.Student;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

@Repository
public class StudentDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private static final Logger logger = Logger.getLogger(StudentDAO.class.getName());
    
    // RowMapper for Student
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
            student.setFaculty(rs.getString("faculty"));
            student.setYear(rs.getInt("year"));
            student.setActive(rs.getBoolean("is_active"));
            
            // Risk assessment fields
            student.setRecentMood(rs.getString("recent_mood"));
            student.setRiskLevel(rs.getString("risk_level"));
            student.setAssessmentCategory(rs.getString("assessment_category"));
            student.setFrequentTags(rs.getString("frequent_tags"));
            student.setMoodStability(rs.getDouble("mood_stability"));
            
            return student;
        }
    }
    
    public List<Student> getAtRiskStudents() {
        String sql = """
            SELECT u.* FROM users u 
            WHERE u.user_role = 'student' 
            AND u.risk_level IN ('HIGH', 'MEDIUM')
            AND u.is_active = TRUE
            ORDER BY 
                CASE u.risk_level 
                    WHEN 'HIGH' THEN 1
                    WHEN 'MEDIUM' THEN 2
                    WHEN 'LOW' THEN 3
                END,
                u.mood_stability ASC
            """;
        
        try {
            List<Student> students = jdbcTemplate.query(sql, new StudentRowMapper());
            logger.info("SQL Query executed. Found " + students.size() + " at-risk students");
            return students;
        } catch (Exception e) {
            logger.severe("Error in getAtRiskStudents: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }
    
    public Student getStudentById(String studentId) {
        // This method expects formatted ID like "STU001"
        try {
            // Extract numeric ID from "STU001" format
            if (studentId.startsWith("STU")) {
                int userId = Integer.parseInt(studentId.substring(3));
                return getStudentByUserId(userId);
            } else {
                // Try to parse as direct user ID
                int userId = Integer.parseInt(studentId);
                return getStudentByUserId(userId);
            }
        } catch (NumberFormatException e) {
            logger.warning("Invalid student ID format: " + studentId);
            return null;
        }
    }
    
    public Student getStudentByUserId(int userId) {
        String sql = """
            SELECT u.* FROM users u 
            WHERE u.user_id = ? 
            AND u.user_role = 'student'
            """;
        
        try {
            List<Student> students = jdbcTemplate.query(sql, new StudentRowMapper(), userId);
            if (!students.isEmpty()) {
                return students.get(0);
            }
            return null;
        } catch (Exception e) {
            logger.severe("Error getting student by user ID: " + e.getMessage());
            return null;
        }
    }
    
    // Add this for debugging
    public List<Student> getAllStudentsWithRisk() {
        String sql = """
            SELECT u.user_id, u.full_name, u.matric_number, u.risk_level, 
                   u.recent_mood, u.mood_stability, u.frequent_tags
            FROM users u 
            WHERE u.user_role = 'student'
            ORDER BY u.user_id
            """;
        
        try {
            return jdbcTemplate.query(sql, (rs, rowNum) -> {
                Student student = new Student();
                student.setUserId(rs.getInt("user_id"));
                student.setFullName(rs.getString("full_name"));
                student.setMatricNumber(rs.getString("matric_number"));
                student.setRiskLevel(rs.getString("risk_level"));
                student.setRecentMood(rs.getString("recent_mood"));
                student.setMoodStability(rs.getDouble("mood_stability"));
                student.setFrequentTags(rs.getString("frequent_tags"));
                return student;
            });
        } catch (Exception e) {
            logger.severe("Error getting all students: " + e.getMessage());
            return List.of();
        }
    }

    public List<Student> getAtRiskStudentsWithReferralStatus(int facultyId) {
        String sql = """
            SELECT 
                u.*,
                CASE 
                    WHEN r.referral_id IS NOT NULL AND r.status = 'PENDING' THEN 'PENDING'
                    WHEN r.referral_id IS NOT NULL AND r.status = 'ACCEPTED' THEN 'ACCEPTED'
                    WHEN r.referral_id IS NOT NULL AND r.status = 'COMPLETED' THEN 'COMPLETED'
                    ELSE 'NO_REFERRAL'
                END as referral_status,
                r.referral_id
            FROM users u 
            LEFT JOIN referrals r ON u.user_id = r.student_id AND r.faculty_id = ?
            WHERE u.user_role = 'student' 
            AND u.risk_level IN ('HIGH', 'MEDIUM')
            AND u.is_active = TRUE
            ORDER BY 
                CASE u.risk_level 
                    WHEN 'HIGH' THEN 1
                    WHEN 'MEDIUM' THEN 2
                    WHEN 'LOW' THEN 3
                END,
                u.mood_stability ASC
            """;
        
        try {
            return jdbcTemplate.query(sql, new RowMapper<Student>() {
                @Override
                public Student mapRow(ResultSet rs, int rowNum) throws SQLException {
                    Student student = new Student();
                    student.setUserId(rs.getInt("user_id"));
                    student.setUsername(rs.getString("username"));
                    student.setFullName(rs.getString("full_name"));
                    student.setEmail(rs.getString("email"));
                    student.setPhone(rs.getString("phone"));
                    student.setMatricNumber(rs.getString("matric_number"));
                    student.setFaculty(rs.getString("faculty"));
                    student.setYear(rs.getInt("year"));
                    student.setActive(rs.getBoolean("is_active"));
                    student.setRecentMood(rs.getString("recent_mood"));
                    student.setRiskLevel(rs.getString("risk_level"));
                    student.setAssessmentCategory(rs.getString("assessment_category"));
                    student.setFrequentTags(rs.getString("frequent_tags"));
                    student.setMoodStability(rs.getDouble("mood_stability"));
                    
                    // Set referral info
                    String referralStatus = rs.getString("referral_status");
                    int referralId = rs.getInt("referral_id");
                    if (!rs.wasNull() && !"NO_REFERRAL".equals(referralStatus)) {
                        student.setReferralStatus(referralStatus);
                        student.setReferralId(referralId);
                    }
                    
                    return student;
                }
            }, facultyId);
        } catch (Exception e) {
            logger.severe("Error in getAtRiskStudentsWithReferralStatus: " + e.getMessage());
            return List.of();
        }
    }
}