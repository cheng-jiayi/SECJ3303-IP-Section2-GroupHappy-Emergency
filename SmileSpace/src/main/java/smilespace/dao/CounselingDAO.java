package smilespace.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import smilespace.model.CounselingSession;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Repository
public class CounselingDAO {
    private static final Logger logger = Logger.getLogger(CounselingDAO.class.getName());

    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public CounselingDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public boolean createCounselingSession(CounselingSession session) {
        String sql = "INSERT INTO counseling_sessions " +
                    "(student_id, scheduled_datetime, session_type, status, " +
                    "current_mood, reason, additional_notes, follow_up_method, " +
                    "created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        System.out.println("=== DAO DEBUG: Creating session ===");
        System.out.println("Student ID: " + session.getStudentId());
        System.out.println("Date/Time: " + session.getScheduledDateTime());
        System.out.println("Type: " + session.getSessionType());
        System.out.println("Mood: " + session.getCurrentMood());
        System.out.println("Reason: " + session.getReason());
        System.out.println("Follow-up: " + session.getFollowUpMethod());

        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            
            int affectedRows = jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, session.getStudentId());
                ps.setTimestamp(2, Timestamp.valueOf(session.getScheduledDateTime()));
                ps.setString(3, session.getSessionType());
                ps.setString(4, "Pending Assignment");
                ps.setString(5, session.getCurrentMood());
                ps.setString(6, session.getReason());
                ps.setString(7, session.getAdditionalNotes());
                ps.setString(8, session.getFollowUpMethod());
                
                LocalDateTime now = LocalDateTime.now();
                ps.setTimestamp(9, Timestamp.valueOf(now));
                ps.setTimestamp(10, Timestamp.valueOf(now));
                return ps;
            }, keyHolder);
            
            System.out.println("Rows affected: " + affectedRows);

            if (affectedRows > 0) {
                Number key = keyHolder.getKey();
                if (key != null) {
                    int sessionId = key.intValue();
                    session.setSessionId(sessionId);
                    System.out.println("Session created with ID: " + sessionId);
                    return true;
                }
            }
        } catch (Exception e) {
            System.err.println("=== SQL ERROR ===");
            System.err.println("Error creating counseling session: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public CounselingSession getSessionById(int sessionId) {
        String sql = "SELECT * FROM counseling_sessions WHERE session_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new CounselingSessionRowMapper(), sessionId);
        } catch (Exception e) {
            logger.severe("Error getting session by ID: " + e.getMessage());
            return null;
        }
    }

    public List<CounselingSession> getSessionsByStudentId(int studentId) {
        String sql = "SELECT * FROM counseling_sessions WHERE student_id = ? ORDER BY scheduled_datetime DESC";
        try {
            return jdbcTemplate.query(sql, new CounselingSessionRowMapper(), studentId);
        } catch (Exception e) {
            logger.severe("Error getting sessions by student ID: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public List<CounselingSession> getSessionsByCounselorId(int counselorId) {
        String sql = "SELECT * FROM counseling_sessions WHERE counselor_id = ? ORDER BY scheduled_datetime DESC";
        try {
            return jdbcTemplate.query(sql, new CounselingSessionRowMapper(), counselorId);
        } catch (Exception e) {
            logger.severe("Error getting sessions by counselor ID: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public List<Integer> getAvailableCounselors(LocalDateTime dateTime) {
        String sql = "SELECT user_id FROM users WHERE user_role='professional' " +
                     "AND user_id NOT IN (SELECT counselor_id FROM counseling_sessions " +
                     "WHERE scheduled_datetime = ? AND status != 'Cancelled')";
        try {
            return jdbcTemplate.query(sql, 
                (rs, rowNum) -> rs.getInt("user_id"), 
                Timestamp.valueOf(dateTime)
            );
        } catch (Exception e) {
            logger.severe("Error getting available counselors: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public boolean updateSession(CounselingSession session) {
        String sql = "UPDATE counseling_sessions SET counselor_id=?, scheduled_datetime=?, " +
                     "session_type=?, status=?, current_mood=?, reason=?, additional_notes=?, " +
                     "follow_up_method=?, updated_at=? WHERE session_id=?";
        
        try {
            Object[] params;
            
            // Handle nullable counselor_id
            if (session.getCounselorId() > 0) {
                params = new Object[]{
                    session.getCounselorId(),
                    Timestamp.valueOf(session.getScheduledDateTime()),
                    session.getSessionType(),
                    session.getStatus(),
                    session.getCurrentMood(),
                    session.getReason(),
                    session.getAdditionalNotes(),
                    session.getFollowUpMethod(),
                    Timestamp.valueOf(LocalDateTime.now()),
                    session.getSessionId()
                };
            } else {
                params = new Object[]{
                    null,
                    Timestamp.valueOf(session.getScheduledDateTime()),
                    session.getSessionType(),
                    session.getStatus(),
                    session.getCurrentMood(),
                    session.getReason(),
                    session.getAdditionalNotes(),
                    session.getFollowUpMethod(),
                    Timestamp.valueOf(LocalDateTime.now()),
                    session.getSessionId()
                };
            }
            
            int[] argTypes = new int[]{
                Types.INTEGER,
                Types.TIMESTAMP,
                Types.VARCHAR,
                Types.VARCHAR,
                Types.VARCHAR,
                Types.VARCHAR,
                Types.VARCHAR,
                Types.VARCHAR,
                Types.TIMESTAMP,
                Types.INTEGER
            };
            
            int affectedRows = jdbcTemplate.update(sql, params, argTypes);
            return affectedRows > 0;
        } catch (Exception e) {
            logger.severe("Error updating session: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteSession(int sessionId) {
        String sql = "DELETE FROM counseling_sessions WHERE session_id=?";
        try {
            int affectedRows = jdbcTemplate.update(sql, sessionId);
            return affectedRows > 0;
        } catch (Exception e) {
            logger.severe("Error deleting session: " + e.getMessage());
            return false;
        }
    }

    public List<CounselingSession> getAllSessions() {
        String sql = "SELECT * FROM counseling_sessions ORDER BY scheduled_datetime DESC";
        try {
            return jdbcTemplate.query(sql, new CounselingSessionRowMapper());
        } catch (Exception e) {
            logger.severe("Error getting all sessions: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    private static class CounselingSessionRowMapper implements RowMapper<CounselingSession> {
        @Override
        public CounselingSession mapRow(ResultSet rs, int rowNum) throws SQLException {
            CounselingSession session = new CounselingSession();
            session.setSessionId(rs.getInt("session_id"));
            session.setStudentId(rs.getInt("student_id"));
            
            int counselorId = rs.getInt("counselor_id");
            if (!rs.wasNull()) {
                session.setCounselorId(counselorId);
            }
            
            Timestamp sched = rs.getTimestamp("scheduled_datetime");
            if (sched != null) {
                session.setScheduledDateTime(sched.toLocalDateTime());
            }
            
            session.setSessionType(rs.getString("session_type"));
            session.setStatus(rs.getString("status"));
            session.setCurrentMood(rs.getString("current_mood"));
            session.setReason(rs.getString("reason"));
            session.setAdditionalNotes(rs.getString("additional_notes"));
            session.setFollowUpMethod(rs.getString("follow_up_method"));
            
            Timestamp created = rs.getTimestamp("created_at");
            if (created != null) {
                session.setCreatedAt(created.toLocalDateTime());
            }
            
            Timestamp updated = rs.getTimestamp("updated_at");
            if (updated != null) {
                session.setUpdatedAt(updated.toLocalDateTime());
            }
            
            return session;
        }
    }
}