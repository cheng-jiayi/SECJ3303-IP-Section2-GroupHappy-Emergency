package smilespace.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import smilespace.model.Referral;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

@Repository
public class ReferralDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    // RowMapper for Referral
    private static class ReferralRowMapper implements RowMapper<Referral> {
        @Override
        public Referral mapRow(ResultSet rs, int rowNum) throws SQLException {
            Referral referral = new Referral();
            referral.setReferralId(rs.getInt("referral_id"));
            referral.setStudentId(rs.getInt("student_id"));
            referral.setFacultyId(rs.getInt("faculty_id"));
            referral.setStudentName(rs.getString("student_name"));
            referral.setStudentMatric(rs.getString("matric_number"));
            referral.setFacultyName(rs.getString("faculty_name"));
            referral.setReason(rs.getString("reason"));
            referral.setUrgency(rs.getString("urgency"));
            referral.setNotes(rs.getString("notes"));
            
            Timestamp referralDate = rs.getTimestamp("referral_date");
            if (referralDate != null) {
                referral.setReferralDate(referralDate.toLocalDateTime());
            }
            
            referral.setStatus(rs.getString("status"));
            
            Integer counselorId = rs.getInt("counselor_id");
            if (!rs.wasNull()) {
                referral.setCounselorId(counselorId);
            }
            
            referral.setCounselorName(rs.getString("counselor_name"));
            
            return referral;
        }
    }
    
    // New RowMapper for detailed referral
    private static class ReferralDetailRowMapper implements RowMapper<Referral> {
        @Override
        public Referral mapRow(ResultSet rs, int rowNum) throws SQLException {
            Referral referral = new Referral();
            referral.setReferralId(rs.getInt("referral_id"));
            referral.setStudentId(rs.getInt("student_id"));
            referral.setFacultyId(rs.getInt("faculty_id"));
            referral.setStudentName(rs.getString("student_name"));
            referral.setStudentMatric(rs.getString("matric_number"));
            referral.setFacultyName(rs.getString("faculty_name"));
            referral.setReason(rs.getString("reason"));
            referral.setUrgency(rs.getString("urgency"));
            referral.setNotes(rs.getString("notes"));
            
            Timestamp referralDate = rs.getTimestamp("referral_date");
            if (referralDate != null) {
                referral.setReferralDate(referralDate.toLocalDateTime());
            }
            
            referral.setStatus(rs.getString("status"));
            
            Integer counselorId = rs.getInt("counselor_id");
            if (!rs.wasNull()) {
                referral.setCounselorId(counselorId);
            }
            
            referral.setCounselorName(rs.getString("counselor_name"));
            referral.setCounselorEmail(rs.getString("counselor_email"));
            
            // Student additional info
            referral.setStudentEmail(rs.getString("student_email"));
            referral.setStudentPhone(rs.getString("student_phone"));
            referral.setStudentFaculty(rs.getString("student_faculty"));
            referral.setStudentYear(rs.getInt("student_year"));
            referral.setRecentMood(rs.getString("recent_mood"));
            referral.setRiskLevel(rs.getString("risk_level"));
            referral.setFrequentTags(rs.getString("frequent_tags"));
            referral.setMoodStability(rs.getDouble("mood_stability"));
            referral.setAssessmentCategory(rs.getString("assessment_category"));
            
            return referral;
        }
    }
    
    public int saveReferral(Referral referral) {
        String sql = "INSERT INTO referrals (student_id, faculty_id, reason, urgency, notes) " +
                    "VALUES (?, ?, ?, ?, ?)";
        try {
            return jdbcTemplate.update(sql,
                referral.getStudentId(),
                referral.getFacultyId(),
                referral.getReason(),
                referral.getUrgency(),
                referral.getNotes()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    public List<Referral> getPendingReferrals() {
        String sql = "SELECT r.*, " +
                    "u.full_name as student_name, u.matric_number, " +
                    "f.full_name as faculty_name, " +
                    "c.full_name as counselor_name " +
                    "FROM referrals r " +
                    "JOIN users u ON r.student_id = u.user_id " +
                    "JOIN users f ON r.faculty_id = f.user_id " +
                    "LEFT JOIN users c ON r.counselor_id = c.user_id " +
                    "WHERE r.status = 'PENDING' " +
                    "ORDER BY " +
                    "CASE r.urgency " +
                    "    WHEN 'HIGH' THEN 1 " +
                    "    WHEN 'MEDIUM' THEN 2 " +
                    "    WHEN 'LOW' THEN 3 " +
                    "END, " +
                    "r.referral_date DESC";
        return jdbcTemplate.query(sql, new ReferralRowMapper());
    }
    
    public List<Referral> getReferralsByCounselor(int counselorId) {
        String sql = "SELECT r.*, " +
                    "u.full_name as student_name, u.matric_number, " +
                    "f.full_name as faculty_name, " +
                    "c.full_name as counselor_name " +
                    "FROM referrals r " +
                    "JOIN users u ON r.student_id = u.user_id " +
                    "JOIN users f ON r.faculty_id = f.user_id " +
                    "LEFT JOIN users c ON r.counselor_id = c.user_id " +
                    "WHERE r.counselor_id = ? " +
                    "ORDER BY r.referral_date DESC";
        return jdbcTemplate.query(sql, new ReferralRowMapper(), counselorId);
    }
    
    // NEW METHOD: Get referrals by faculty
    public List<Referral> getReferralsByFaculty(int facultyId) {
        String sql = "SELECT r.*, " +
                    "u.full_name as student_name, u.matric_number, " +
                    "f.full_name as faculty_name, " +
                    "c.full_name as counselor_name " +
                    "FROM referrals r " +
                    "JOIN users u ON r.student_id = u.user_id " +
                    "JOIN users f ON r.faculty_id = f.user_id " +
                    "LEFT JOIN users c ON r.counselor_id = c.user_id " +
                    "WHERE r.faculty_id = ? " +
                    "ORDER BY r.referral_date DESC";
        return jdbcTemplate.query(sql, new ReferralRowMapper(), facultyId);
    }
    
    public boolean acceptReferral(int referralId, int counselorId) {
        String sql = "UPDATE referrals SET status = 'ACCEPTED', counselor_id = ? " +
                    "WHERE referral_id = ? AND status = 'PENDING'";
        try {
            int rowsUpdated = jdbcTemplate.update(sql, counselorId, referralId);
            
            // Create counseling session from accepted referral
            if (rowsUpdated > 0) {
                createCounselingSessionFromReferral(referralId, counselorId);
            }
            
            return rowsUpdated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private void createCounselingSessionFromReferral(int referralId, int counselorId) {
        String sql = "INSERT INTO counseling_sessions (student_id, counselor_id, scheduled_datetime, " +
                    "session_type, status, reason, follow_up_method) " +
                    "SELECT r.student_id, ?, " +
                    "DATE_ADD(NOW(), INTERVAL 3 DAY), " +
                    "'Initial Assessment', " +
                    "'Scheduled', " +
                    "CONCAT('Referral: ', r.reason), " +
                    "'Email' " +
                    "FROM referrals r " +
                    "WHERE r.referral_id = ?";
        try {
            jdbcTemplate.update(sql, counselorId, referralId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public Referral getReferralById(int referralId) {
        String sql = "SELECT r.*, " +
                    "u.full_name as student_name, u.matric_number, " +
                    "f.full_name as faculty_name, " +
                    "c.full_name as counselor_name " +
                    "FROM referrals r " +
                    "JOIN users u ON r.student_id = u.user_id " +
                    "JOIN users f ON r.faculty_id = f.user_id " +
                    "LEFT JOIN users c ON r.counselor_id = c.user_id " +
                    "WHERE r.referral_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new ReferralRowMapper(), referralId);
        } catch (Exception e) {
            return null;
        }
    }
    
    // NEW METHOD: Get referral with detailed information
    public Referral getReferralByIdWithDetails(int referralId) {
        String sql = "SELECT r.*, " +
                    "u.full_name as student_name, u.matric_number, " +
                    "u.email as student_email, u.phone as student_phone, " +
                    "u.faculty as student_faculty, u.year as student_year, " +
                    "u.recent_mood, u.risk_level, u.frequent_tags, " +
                    "u.mood_stability, u.assessment_category, " +
                    "f.full_name as faculty_name, " +
                    "c.full_name as counselor_name, c.email as counselor_email " +
                    "FROM referrals r " +
                    "JOIN users u ON r.student_id = u.user_id " +
                    "JOIN users f ON r.faculty_id = f.user_id " +
                    "LEFT JOIN users c ON r.counselor_id = c.user_id " +
                    "WHERE r.referral_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new ReferralDetailRowMapper(), referralId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public Referral getLatestReferralByStudent(int studentId) {
        String sql = "SELECT r.*, " +
                    "u.full_name as student_name, u.matric_number, " +
                    "f.full_name as faculty_name, " +
                    "c.full_name as counselor_name " +
                    "FROM referrals r " +
                    "JOIN users u ON r.student_id = u.user_id " +
                    "JOIN users f ON r.faculty_id = f.user_id " +
                    "LEFT JOIN users c ON r.counselor_id = c.user_id " +
                    "WHERE r.student_id = ? " +
                    "ORDER BY r.referral_date DESC LIMIT 1";
        try {
            return jdbcTemplate.queryForObject(sql, new ReferralRowMapper(), studentId);
        } catch (Exception e) {
            return null;
        }
    }
    
    // NEW METHOD: Get referral ID for a student-faculty combination
    public Integer getReferralIdByStudentAndFaculty(int studentId, int facultyId) {
        String sql = "SELECT referral_id FROM referrals " +
                    "WHERE student_id = ? AND faculty_id = ? " +
                    "ORDER BY referral_date DESC LIMIT 1";
        try {
            return jdbcTemplate.queryForObject(sql, Integer.class, studentId, facultyId);
        } catch (Exception e) {
            return null;
        }
    }
}