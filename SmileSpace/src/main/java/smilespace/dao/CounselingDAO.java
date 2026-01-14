package smilespace.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import smilespace.model.CounselingSession;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public class CounselingDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public CounselingSession getSessionById(int sessionId) {
        System.out.println("=== DAO: getSessionById(" + sessionId + ") START ===");
        
        try {
            String sql = "SELECT cs.*, " +
                        "u1.full_name as student_name, u1.email as student_email, " +
                        "u2.full_name as counselor_name " +
                        "FROM counseling_sessions cs " +
                        "LEFT JOIN users u1 ON cs.student_id = u1.user_id " +
                        "LEFT JOIN users u2 ON cs.counselor_id = u2.user_id " +
                        "WHERE cs.session_id = ?";
            
            System.out.println("Executing query: " + sql);
            
            CounselingSession session = jdbcTemplate.queryForObject(sql, new CounselingSessionRowMapper(), sessionId);
            
            System.out.println("=== DAO: Session retrieved successfully ===");
            System.out.println("Session ID: " + session.getSessionId());
            System.out.println("Status: " + session.getStatus());
            System.out.println("isCompleted(): " + session.isCompleted());
            System.out.println("Session Summary: " + session.getSessionSummary());
            System.out.println("Progress Notes: " + session.getProgressNotes());
            
            return session;
            
        } catch (EmptyResultDataAccessException e) {
            System.out.println("=== DAO: No session found with ID " + sessionId + " ===");
            return null;
        } catch (Exception e) {
            System.err.println("=== DAO ERROR in getSessionById: " + e.getMessage() + " ===");
            e.printStackTrace();
            return null;
        }
    }

    public List<CounselingSession> getSessionsPendingAssignment() {
        String sql = "SELECT cs.*, " +
                    "u1.full_name as student_name, u1.email as student_email, " +
                    "u2.full_name as counselor_name " +
                    "FROM counseling_sessions cs " +
                    "LEFT JOIN users u1 ON cs.student_id = u1.user_id " +
                    "LEFT JOIN users u2 ON cs.counselor_id = u2.user_id " +
                    "WHERE cs.status = 'Pending Assignment' " +
                    "ORDER BY cs.scheduled_datetime ASC";
        
        System.out.println("DAO: Getting sessions pending assignment");
        List<CounselingSession> sessions = jdbcTemplate.query(sql, new CounselingSessionRowMapper());
        System.out.println("DAO: Found " + sessions.size() + " pending sessions");
        return sessions;
    }
    
    // Update your RowMapper class
    private static class CounselingSessionRowMapper implements RowMapper<CounselingSession> {
    @Override
    public CounselingSession mapRow(ResultSet rs, int rowNum) throws SQLException {
        System.out.println("=== ROWMAPPER: Mapping row ===");
        
        CounselingSession session = new CounselingSession();
        
        try {
            // Basic ID fields
            int sessionId = rs.getInt("session_id");
            session.setSessionId(sessionId);
            System.out.println("RowMapper: session_id = " + sessionId);
            
            session.setStudentId(rs.getInt("student_id"));
            System.out.println("RowMapper: student_id = " + rs.getInt("student_id"));
            
            // Counselor ID
            Object counselorIdObj = rs.getObject("counselor_id");
            if (counselorIdObj != null) {
                session.setCounselorId((Integer) counselorIdObj);
                System.out.println("RowMapper: counselor_id = " + counselorIdObj);
            } else {
                System.out.println("RowMapper: counselor_id = NULL");
            }
            
            // STATUS - CRITICAL
            String status = rs.getString("status");
            session.setStatus(status);
            System.out.println("RowMapper: status = '" + status + "'");
            
            // SESSION SUMMARY - CRITICAL
            String sessionSummary = rs.getString("session_summary");
            session.setSessionSummary(sessionSummary);
            System.out.println("RowMapper: session_summary = " + 
                (sessionSummary != null ? "'" + sessionSummary + "'" : "NULL"));
            
            // PROGRESS NOTES
            String progressNotes = rs.getString("progress_notes");
            session.setProgressNotes(progressNotes);
            System.out.println("RowMapper: progress_notes = " + 
                (progressNotes != null ? "'" + progressNotes + "'" : "NULL"));
            
            // FOLLOW UP ACTIONS
            String followUpActions = rs.getString("follow_up_actions");
            session.setFollowUpActions(followUpActions);
            System.out.println("RowMapper: follow_up_actions = " + 
                (followUpActions != null ? "'" + followUpActions + "'" : "NULL"));
            
            // NEXT SESSION SUGGESTED (DATETIME)
            Timestamp nextSessionSuggested = rs.getTimestamp("next_session_suggested");
            if (nextSessionSuggested != null && !rs.wasNull()) {
                session.setNextSessionSuggested(nextSessionSuggested.toLocalDateTime());
                System.out.println("RowMapper: next_session_suggested = " + nextSessionSuggested.toLocalDateTime());
            } else {
                System.out.println("RowMapper: next_session_suggested = NULL");
            }
            
            // DATETIME fields
            Timestamp scheduled = rs.getTimestamp("scheduled_datetime");
            if (scheduled != null) {
                session.setScheduledDateTime(scheduled.toLocalDateTime());
            }
            
            Timestamp actual = rs.getTimestamp("actual_datetime");
            if (actual != null) {
                session.setActualDateTime(actual.toLocalDateTime());
            }
            
            // Other text fields
            session.setCurrentMood(rs.getString("current_mood"));
            session.setReason(rs.getString("reason"));
            session.setAdditionalNotes(rs.getString("additional_notes"));
            session.setFollowUpMethod(rs.getString("follow_up_method"));
            session.setObservedMood(rs.getString("observed_mood"));
            session.setSessionType(rs.getString("session_type"));
            session.setMeetingLink(rs.getString("meeting_link"));
            session.setMeetingLocation(rs.getString("location"));  // Changed from 'meeting_location' to 'location'
            session.setAttachmentPath(rs.getString("attachment_path"));
            
            // User info from JOIN
            session.setStudentName(rs.getString("student_name"));
            session.setStudentEmail(rs.getString("student_email"));
            session.setCounselorName(rs.getString("counselor_name"));
            
            // Created/updated at
            Timestamp createdAt = rs.getTimestamp("created_at");
            if (createdAt != null) {
                session.setCreatedAt(createdAt.toLocalDateTime());
            }
            
            Timestamp updatedAt = rs.getTimestamp("updated_at");
            if (updatedAt != null) {
                session.setUpdatedAt(updatedAt.toLocalDateTime());
            }
            
            System.out.println("RowMapper: Completed mapping session ID " + sessionId);
            
        } catch (SQLException e) {
            System.err.println("RowMapper ERROR: " + e.getMessage());
            throw e;
        }
        
        return session;
    }
}

    public boolean createCounselingSession(CounselingSession session) {
    String sql = "INSERT INTO counseling_sessions " +
                "(student_id, counselor_id, scheduled_datetime, session_type, " +
                "current_mood, reason, additional_notes, follow_up_method, status, " +
                "location, meeting_link, " +  // Note: location comes before meeting_link
                "created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    try {
        System.out.println("=== DAO DEBUG: Creating counseling session ===");
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        int rows = jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"session_id"});
            ps.setInt(1, session.getStudentId());
            
            // Handle null counselor_id
            if (session.getCounselorId() != null) {
                ps.setInt(2, session.getCounselorId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            
            ps.setTimestamp(3, Timestamp.valueOf(session.getScheduledDateTime()));
            ps.setString(4, session.getSessionType());
            ps.setString(5, session.getCurrentMood());
            ps.setString(6, session.getReason());
            ps.setString(7, session.getAdditionalNotes());
            ps.setString(8, session.getFollowUpMethod());
            ps.setString(9, session.getStatus());
            ps.setString(10, session.getMeetingLocation()); // location column
            ps.setString(11, session.getMeetingLink()); // meeting_link column
            ps.setTimestamp(12, Timestamp.valueOf(session.getCreatedAt()));
            ps.setTimestamp(13, Timestamp.valueOf(session.getUpdatedAt()));
            return ps;
        }, keyHolder);
        
        if (rows > 0 && keyHolder.getKey() != null) {
            session.setSessionId(keyHolder.getKey().intValue());
            System.out.println("✅ Session created with ID: " + session.getSessionId());
            return true;
        }
        
        System.err.println("❌ Failed to create session");
        return false;
        
    } catch (Exception e) {
        System.err.println("💥 Error creating session: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

    public boolean updateSession(CounselingSession session) {
    try {
        String sql = "UPDATE counseling_sessions SET " +
                    "counselor_id = ?, " +
                    "scheduled_datetime = ?, " +
                    "actual_datetime = ?, " +
                    "session_type = ?, " +
                    "status = ?, " +
                    "meeting_link = ?, " +
                    "location = ?, " +  // Changed from meeting_location to location
                    "current_mood = ?, " +
                    "reason = ?, " +
                    "additional_notes = ?, " +
                    "follow_up_method = ?, " +
                    "session_summary = ?, " +
                    "observed_mood = ?, " + 
                    "progress_notes = ?, " +
                    "follow_up_actions = ?, " +
                    "attachment_path = ?, " + 
                    "next_session_suggested = ?, " +
                    "updated_at = ? " +
                    "WHERE session_id = ?";
        
        int rowsAffected = jdbcTemplate.update(sql,
            session.getCounselorId(),
            session.getScheduledDateTime() != null ? Timestamp.valueOf(session.getScheduledDateTime()) : null,
            session.getActualDateTime() != null ? Timestamp.valueOf(session.getActualDateTime()) : null,
            session.getSessionType(),
            session.getStatus(),
            session.getMeetingLink(),
            session.getMeetingLocation(), // This maps to 'location' column
            session.getCurrentMood(),
            session.getReason(),
            session.getAdditionalNotes(),
            session.getFollowUpMethod(),
            session.getSessionSummary(),
            session.getObservedMood(),
            session.getProgressNotes(),
            session.getFollowUpActions(),
            session.getAttachmentPath(),
            session.getNextSessionSuggested() != null ? Timestamp.valueOf(session.getNextSessionSuggested()) : null,
            Timestamp.valueOf(LocalDateTime.now()),
            session.getSessionId()
        );
        
        return rowsAffected > 0;
        
    } catch (Exception e) {
        System.err.println("Error updating counseling session: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
    
    // Other methods...
    public List<CounselingSession> getSessionsByStudentId(int studentId) {
        String sql = "SELECT cs.*, " +
                    "u1.full_name as student_name, u1.email as student_email, " +
                    "u2.full_name as counselor_name " +
                    "FROM counseling_sessions cs " +
                    "LEFT JOIN users u1 ON cs.student_id = u1.user_id " +
                    "LEFT JOIN users u2 ON cs.counselor_id = u2.user_id " +
                    "WHERE cs.student_id = ? " +
                    "ORDER BY cs.scheduled_datetime DESC";
        
        return jdbcTemplate.query(sql, new CounselingSessionRowMapper(), studentId);
    }
    
    public List<CounselingSession> getSessionsByCounselorId(int counselorId) {
        String sql = "SELECT cs.*, " +
                    "u1.full_name as student_name, u1.email as student_email, " +
                    "u2.full_name as counselor_name " +
                    "FROM counseling_sessions cs " +
                    "LEFT JOIN users u1 ON cs.student_id = u1.user_id " +
                    "LEFT JOIN users u2 ON cs.counselor_id = u2.user_id " +
                    "WHERE cs.counselor_id = ? " +
                    "ORDER BY cs.scheduled_datetime DESC";
        
        return jdbcTemplate.query(sql, new CounselingSessionRowMapper(), counselorId);
    }
    
    public boolean deleteSession(int sessionId) {
        String sql = "DELETE FROM counseling_sessions WHERE session_id = ?";
        int rowsAffected = jdbcTemplate.update(sql, sessionId);
        return rowsAffected > 0;
    }
    
    public List<Integer> getAvailableCounselors(LocalDateTime dateTime) {
        // Implementation for available counselors
        return List.of();
    }
    
    public List<CounselingSession> getAllSessions() {
        String sql = "SELECT cs.*, " +
                    "u1.full_name as student_name, u1.email as student_email, " +
                    "u2.full_name as counselor_name " +
                    "FROM counseling_sessions cs " +
                    "LEFT JOIN users u1 ON cs.student_id = u1.user_id " +
                    "LEFT JOIN users u2 ON cs.counselor_id = u2.user_id " +
                    "ORDER BY cs.scheduled_datetime DESC";
        
        return jdbcTemplate.query(sql, new CounselingSessionRowMapper());
    }
}