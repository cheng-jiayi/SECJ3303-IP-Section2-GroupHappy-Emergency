package smilespace.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import smilespace.model.MoodEntry;
import smilespace.model.MoodWeeklySummary;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.DayOfWeek;
import java.util.*;
import java.util.logging.Logger;

@Repository
public class MoodDAO {
    private static final Logger logger = Logger.getLogger(MoodDAO.class.getName());
    
    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public MoodDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    public boolean createMoodEntry(MoodEntry entry) {
        String sql = "INSERT INTO mood_entries (user_id, entry_date, reflection, image_path, tags) VALUES (?, ?, ?, ?, ?)";
        
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            
            int affectedRows = jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, entry.getUserId());
                ps.setDate(2, Date.valueOf(entry.getEntryDate()));
                ps.setString(3, entry.getReflection());
                ps.setString(4, entry.getImagePath());
                
                String tagsStr = "";
                if (entry.getTags() != null && !entry.getTags().isEmpty()) {
                    tagsStr = String.join(",", entry.getTags());
                }
                ps.setString(5, tagsStr);
                return ps;
            }, keyHolder);
            
            if (affectedRows > 0) {
                Number key = keyHolder.getKey();
                if (key != null) {
                    int entryId = key.intValue();
                    entry.setEntryId(entryId);
                    insertFeelings(entryId, entry.getFeelings());
                    
                    logHistory(entry.getUserId(), "CREATE", entryId, "Created mood entry");
                    logger.info("Mood entry created: User " + entry.getUserId() + ", Entry ID: " + entryId);
                    return true;
                }
            }
        } catch (Exception e) {
            logger.severe("Error creating mood entry: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public MoodEntry getMoodEntryById(int entryId, int userId) {
        String sql = "SELECT * FROM mood_entries WHERE entry_id = ? AND user_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new MoodEntryRowMapper(), entryId, userId);
        } catch (Exception e) {
            logger.severe("Error getting mood entry: " + e.getMessage());
            return null;
        }
    }
    
    public MoodEntry getMoodEntryByDate(int userId, LocalDate date) {
        String sql = "SELECT * FROM mood_entries WHERE user_id = ? AND entry_date = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new MoodEntryRowMapper(), userId, Date.valueOf(date));
        } catch (Exception e) {
            logger.severe("Error getting mood entry by date: " + e.getMessage());
            return null;
        }
    }
    
    public List<MoodEntry> getMoodEntriesByUser(int userId) {
        String sql = "SELECT * FROM mood_entries WHERE user_id = ? ORDER BY entry_date DESC";
        return jdbcTemplate.query(sql, new MoodEntryRowMapper(), userId);
    }
    
    public boolean updateMoodEntry(MoodEntry entry) {
        String sql = "UPDATE mood_entries SET reflection = ?, image_path = ?, tags = ? WHERE entry_id = ? AND user_id = ?";
        
        try {
            String tagsStr = "";
            if (entry.getTags() != null && !entry.getTags().isEmpty()) {
                tagsStr = String.join(",", entry.getTags());
            }
            
            int affectedRows = jdbcTemplate.update(sql,
                entry.getReflection(),
                entry.getImagePath(),
                tagsStr,
                entry.getEntryId(),
                entry.getUserId()
            );
            
            if (affectedRows > 0) {
                deleteFeelingsForEntry(entry.getEntryId());
                insertFeelings(entry.getEntryId(), entry.getFeelings());
                logHistory(entry.getUserId(), "UPDATE", entry.getEntryId(), "Updated mood entry");
                logger.info("Mood entry updated: Entry ID: " + entry.getEntryId());
                return true;
            }
        } catch (Exception e) {
            logger.severe("Error updating mood entry: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteMoodEntry(int entryId, int userId) {
        String sql = "DELETE FROM mood_entries WHERE entry_id = ? AND user_id = ?";
        
        try {
            logHistory(userId, "DELETE", entryId, "Deleted mood entry");
            int affectedRows = jdbcTemplate.update(sql, entryId, userId);
            logger.info("Mood entry deleted: Entry ID: " + entryId + ", User ID: " + userId);
            return affectedRows > 0;
        } catch (Exception e) {
            logger.severe("Error deleting mood entry: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public MoodEntry getLatestMoodEntry(int userId) {
        String sql = "SELECT * FROM mood_entries WHERE user_id = ? ORDER BY entry_date DESC LIMIT 1";
        try {
            return jdbcTemplate.queryForObject(sql, new MoodEntryRowMapper(), userId);
        } catch (Exception e) {
            logger.severe("Error getting latest mood entry: " + e.getMessage());
            return null;
        }
    }
    
    public MoodWeeklySummary getWeeklySummary(int userId, LocalDate date) {
        MoodWeeklySummary summary = new MoodWeeklySummary();
        
        LocalDate weekStart = date.with(DayOfWeek.MONDAY);
        LocalDate weekEnd = weekStart.plusDays(6);
        
        summary.setWeekStart(weekStart);
        summary.setWeekEnd(weekEnd);
        
        List<MoodEntry> weekEntries = getMoodEntriesByDateRange(userId, weekStart, weekEnd);
        summary.setTotalEntries(weekEntries.size());
        
        if (!weekEntries.isEmpty()) {
            Map<String, Integer> feelingFreq = new HashMap<>();
            for (MoodEntry entry : weekEntries) {
                for (String feeling : entry.getFeelings()) {
                    feelingFreq.put(feeling, feelingFreq.getOrDefault(feeling, 0) + 1);
                }
            }
            summary.setFeelingFrequency(feelingFreq);
            
            List<Map.Entry<String, Integer>> sortedEntries = new ArrayList<>(feelingFreq.entrySet());
            sortedEntries.sort((a, b) -> b.getValue().compareTo(a.getValue()));
            
            List<String> dominant = new ArrayList<>();
            int limit = Math.min(3, sortedEntries.size());
            for (int i = 0; i < limit; i++) {
                dominant.add(sortedEntries.get(i).getKey());
            }
            summary.setDominantFeelings(dominant);
        }
        
        return summary;
    }
    
    public Map<String, Integer> getMoodTrends(int userId) {
        String sql = "SELECT mf.feeling_name, COUNT(*) as count FROM mood_feelings mf " +
                    "JOIN mood_entries me ON mf.entry_id = me.entry_id " +
                    "WHERE me.user_id = ? GROUP BY mf.feeling_name";
        
        Map<String, Integer> trends = new HashMap<>();
        try {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, userId);
            for (Map<String, Object> row : rows) {
                trends.put((String) row.get("feeling_name"), ((Number) row.get("count")).intValue());
            }
        } catch (Exception e) {
            logger.severe("Error getting mood trends: " + e.getMessage());
            e.printStackTrace();
        }
        return trends;
    }
    
    public List<MoodEntry> getMoodEntriesByDateRange(int userId, LocalDate start, LocalDate end) {
        String sql = "SELECT * FROM mood_entries WHERE user_id = ? AND entry_date BETWEEN ? AND ? ORDER BY entry_date";
        return jdbcTemplate.query(sql, new MoodEntryRowMapper(), userId, Date.valueOf(start), Date.valueOf(end));
    }
    
    public List<Map<String, Object>> getMoodHistory(int userId, int limit) {
        String sql = "SELECT action_type, entry_id, action_details, performed_at " +
                    "FROM mood_history WHERE user_id = ? ORDER BY performed_at DESC LIMIT ?";
        
        try {
            return jdbcTemplate.queryForList(sql, userId, limit);
        } catch (Exception e) {
            logger.severe("Error getting mood history: " + e.getMessage());
            e.printStackTrace();
        }
        return new ArrayList<>();
    }
    
    private void insertFeelings(int entryId, List<String> feelings) {
        if (feelings == null || feelings.isEmpty()) return;
        
        String sql = "INSERT INTO mood_feelings (entry_id, feeling_name) VALUES (?, ?)";
        List<Object[]> batchArgs = new ArrayList<>();
        
        for (String feeling : feelings) {
            if (feeling != null && !feeling.trim().isEmpty()) {
                batchArgs.add(new Object[]{entryId, feeling.toLowerCase()});
            }
        }
        
        if (!batchArgs.isEmpty()) {
            jdbcTemplate.batchUpdate(sql, batchArgs);
        }
    }
    
    private void deleteFeelingsForEntry(int entryId) {
        String sql = "DELETE FROM mood_feelings WHERE entry_id = ?";
        jdbcTemplate.update(sql, entryId);
    }
    
    private void logHistory(int userId, String actionType, int entryId, String details) {
        String sql = "INSERT INTO mood_history (user_id, action_type, entry_id, action_details) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, userId, actionType, entryId, details);
        logger.info("History logged: User " + userId + " " + actionType + " entry " + entryId);
    }
    
    private class MoodEntryRowMapper implements RowMapper<MoodEntry> {
        @Override
        public MoodEntry mapRow(ResultSet rs, int rowNum) throws SQLException {
            MoodEntry entry = new MoodEntry();
            entry.setEntryId(rs.getInt("entry_id"));
            entry.setUserId(rs.getInt("user_id"));
            
            Date sqlDate = rs.getDate("entry_date");
            if (sqlDate != null) {
                entry.setEntryDate(sqlDate.toLocalDate());
            }
            
            entry.setReflection(rs.getString("reflection"));
            entry.setImagePath(rs.getString("image_path"));
            
            String tagsStr = rs.getString("tags");
            if (tagsStr != null && !tagsStr.trim().isEmpty()) {
                Set<String> tagsSet = new HashSet<>();
                String[] tagsArray = tagsStr.split(",");
                for (String tag : tagsArray) {
                    if (tag != null && !tag.trim().isEmpty()) {
                        tagsSet.add(tag.trim());
                    }
                }
                entry.setTags(tagsSet);
            }
            
            entry.setFeelings(getFeelingsForEntry(entry.getEntryId()));
            
            return entry;
        }
    }
    
    private List<String> getFeelingsForEntry(int entryId) {
        String sql = "SELECT feeling_name FROM mood_feelings WHERE entry_id = ?";
        return jdbcTemplate.query(sql, 
            (rs, rowNum) -> rs.getString("feeling_name"), 
            entryId
        );
    }
}