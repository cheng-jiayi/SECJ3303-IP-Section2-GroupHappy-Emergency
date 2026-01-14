package smilespace.dao;

import smilespace.model.LearningModule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.sql.*;
import java.util.*;

@Repository
@Transactional
public class LearningModuleDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private final RowMapper<LearningModule> learningModuleRowMapper = (rs, rowNum) -> {
        LearningModule module = new LearningModule();
        module.setId(rs.getString("id"));
        module.setTitle(rs.getString("title"));
        module.setDescription(rs.getString("description"));
        module.setCategory(rs.getString("category"));
        module.setLevel(rs.getString("level"));
        module.setAuthorName(rs.getString("author_name"));
        module.setEstimatedDuration(rs.getString("estimated_duration"));
        module.setCoverImage(rs.getString("cover_image"));
        module.setResourceFile(rs.getString("resource_file"));
        module.setVideoUrl(rs.getString("video_url"));
        module.setContentOutline(rs.getString("content_outline"));
        module.setLearningGuide(rs.getString("learning_guide"));
        module.setLearningTip(rs.getString("learning_tip"));
        module.setKeyPoints(rs.getString("key_points"));
        module.setViews(rs.getInt("views"));
        
        java.sql.Date lastUpdatedDate = rs.getDate("last_updated");
        if (lastUpdatedDate != null) {
            module.setLastUpdated(lastUpdatedDate.toString());
        } else {
            module.setLastUpdated("N/A");
        }
        
        module.setCreatedBy(rs.getInt("created_by"));
        module.setCreatedAt(rs.getTimestamp("created_at"));
        
        return module;
    };
    
    public boolean save(LearningModule module) {
        String sql = "INSERT INTO learning_modules (id, title, description, category, level, author_name, " +
                    "estimated_duration, video_url, content_outline, learning_guide, learning_tip, key_points, " +
                    "views, last_updated, created_by, cover_image, resource_file) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            int rowsAffected = jdbcTemplate.update(sql,
                module.getId(),
                module.getTitle(),
                module.getDescription(),
                module.getCategory(),
                module.getLevel(),
                module.getAuthorName(),
                module.getEstimatedDuration(),
                module.getVideoUrl(),
                module.getContentOutline(),
                module.getLearningGuide(),
                module.getLearningTip(),
                module.getKeyPoints(),
                module.getViews(),
                java.sql.Date.valueOf(module.getLastUpdated()),
                module.getCreatedBy() != null ? module.getCreatedBy() : 1,
                module.getCoverImage(),
                module.getResourceFile()
            );
            
            System.out.println("Saved module " + module.getId() + ": " + (rowsAffected > 0));
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("ERROR in save(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean update(LearningModule module) {
        String sql = "UPDATE learning_modules SET title = ?, description = ?, category = ?, level = ?, " +
                    "author_name = ?, estimated_duration = ?, video_url = ?, content_outline = ?, " +
                    "learning_guide = ?, learning_tip = ?, key_points = ?, views = ?, last_updated = ?, " +
                    "cover_image = ?, resource_file = ? " +
                    "WHERE id = ?";
        
        try {
            int rowsAffected = jdbcTemplate.update(sql,
                module.getTitle(),
                module.getDescription(),
                module.getCategory(),
                module.getLevel(),
                module.getAuthorName(),
                module.getEstimatedDuration(),
                module.getVideoUrl(),
                module.getContentOutline(),
                module.getLearningGuide(),
                module.getLearningTip(),
                module.getKeyPoints(),
                module.getViews(),
                java.sql.Date.valueOf(module.getLastUpdated()),
                module.getCoverImage(),
                module.getResourceFile(),
                module.getId()
            );
            
            System.out.println("Updated module " + module.getId() + ": " + (rowsAffected > 0));
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("ERROR in update(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean delete(String id) {
        String sql = "DELETE FROM learning_modules WHERE id = ?";
        
        try {
            int rowsAffected = jdbcTemplate.update(sql, id);
            System.out.println("Deleted module " + id + ": " + (rowsAffected > 0));
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("ERROR in delete(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public List<LearningModule> findAll() {
        String sql = "SELECT * FROM learning_modules ORDER BY last_updated DESC";
        
        try {
            List<LearningModule> modules = jdbcTemplate.query(sql, learningModuleRowMapper);
            System.out.println("Total modules loaded from database: " + modules.size());
            return modules;
            
        } catch (Exception e) {
            System.err.println("ERROR in findAll(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public LearningModule findById(String id) {
        String sql = "SELECT * FROM learning_modules WHERE id = ?";
        
        try {
            return jdbcTemplate.queryForObject(sql, learningModuleRowMapper, id);
        } catch (Exception e) {
            System.err.println("ERROR in findById(): " + e.getMessage());
            return null;
        }
    }
    
    public List<LearningModule> findByCategory(String category) {
        String sql = "SELECT * FROM learning_modules WHERE category = ? ORDER BY last_updated DESC";
        
        try {
            return jdbcTemplate.query(sql, learningModuleRowMapper, category);
        } catch (Exception e) {
            System.err.println("ERROR in findByCategory(): " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    public boolean incrementViews(String moduleId) {
        String sql = "UPDATE learning_modules SET views = views + 1 WHERE id = ?";
        
        try {
            int rowsAffected = jdbcTemplate.update(sql, moduleId);
            System.out.println("Incremented views for module " + moduleId + ": " + (rowsAffected > 0));
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("ERROR in incrementViews(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public List<LearningModule> search(String keyword, String category, String level) {
        List<LearningModule> modules = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM learning_modules WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
            String searchTerm = "%" + keyword + "%";
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (category != null && !"all".equals(category)) {
            sql.append(" AND category = ?");
            params.add(category);
        }
        
        if (level != null && !"all".equals(level)) {
            sql.append(" AND level = ?");
            params.add(level);
        }
        
        sql.append(" ORDER BY last_updated DESC");
        
        try {
            return jdbcTemplate.query(sql.toString(), learningModuleRowMapper, params.toArray());
        } catch (Exception e) {
            System.err.println("ERROR in search(): " + e.getMessage());
            e.printStackTrace();
            return modules;
        }
    }
    
    public Map<String, Object> getModuleStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            // Total modules
            Integer totalModules = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) as total FROM learning_modules", Integer.class);
            stats.put("totalModules", totalModules != null ? totalModules : 0);
            
            // Category statistics
            List<Map<String, Object>> categoryStats = jdbcTemplate.queryForList(
                "SELECT category, COUNT(*) as count FROM learning_modules GROUP BY category");
            Map<String, Integer> categoryMap = new HashMap<>();
            for (Map<String, Object> row : categoryStats) {
                categoryMap.put((String) row.get("category"), ((Number) row.get("count")).intValue());
            }
            stats.put("categoryStats", categoryMap);
            
            // Level statistics
            List<Map<String, Object>> levelStats = jdbcTemplate.queryForList(
                "SELECT level, COUNT(*) as count FROM learning_modules GROUP BY level");
            Map<String, Integer> levelMap = new HashMap<>();
            for (Map<String, Object> row : levelStats) {
                levelMap.put((String) row.get("level"), ((Number) row.get("count")).intValue());
            }
            stats.put("levelStats", levelMap);
            
            // Total views
            Integer totalViews = jdbcTemplate.queryForObject(
                "SELECT SUM(views) as totalViews FROM learning_modules", Integer.class);
            stats.put("totalViews", totalViews != null ? totalViews : 0);
            
            // Recent modules
            List<LearningModule> recentModules = jdbcTemplate.query(
                "SELECT * FROM learning_modules ORDER BY created_at DESC LIMIT 5", 
                learningModuleRowMapper);
            stats.put("recentModules", recentModules);
            
            System.out.println("Module statistics retrieved");
            
        } catch (Exception e) {
            System.err.println("ERROR in getModuleStatistics(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    public boolean recordAccess(String moduleId, int userId, String accessType) {
        String sql = "INSERT INTO module_access_history (module_id, user_id, access_type) VALUES (?, ?, ?)";
        
        try {
            int rowsAffected = jdbcTemplate.update(sql, moduleId, userId, accessType);
            System.out.println("Recorded access for module " + moduleId + ": " + (rowsAffected > 0));
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("ERROR in recordAccess(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Map<String, Object>> getAccessHistory(String moduleId) {
        List<Map<String, Object>> history = new ArrayList<>();
        
        // Check if table exists
        try {
            Integer tableExists = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'smilespace' AND table_name = 'module_access_history'", 
                Integer.class);
            
            if (tableExists == null || tableExists == 0) {
                System.out.println("module_access_history table does not exist");
                return history;
            }
        } catch (Exception e) {
            System.err.println("ERROR checking if table exists: " + e.getMessage());
            return history;
        }
        
        String sql = "SELECT mah.*, u.full_name, u.username " +
                     "FROM module_access_history mah " +
                     "JOIN users u ON mah.user_id = u.user_id " +
                     "WHERE mah.module_id = ? " +
                     "ORDER BY mah.access_date DESC " +
                     "LIMIT 50";
        
        try {
            history = jdbcTemplate.queryForList(sql, moduleId);
            System.out.println("Retrieved " + history.size() + " access records for module " + moduleId);
        } catch (Exception e) {
            System.err.println("ERROR in getAccessHistory(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return history;
    }
}