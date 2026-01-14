package smilespace.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import smilespace.model.Professional;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.*;
import java.util.logging.Logger;

@Repository
public class ProfessionalDAO {
    private static final Logger logger = Logger.getLogger(ProfessionalDAO.class.getName());
    
    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public ProfessionalDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    public Professional getProfessionalById(int professionalId) {
        String sql = "SELECT cp.*, u.full_name, u.email, u.phone, u.created_at, u.last_login " +
                    "FROM counseling_professionals cp " +
                    "JOIN users u ON cp.professional_id = u.user_id " +
                    "WHERE cp.professional_id = ?";
        
        try {
            return jdbcTemplate.queryForObject(sql, new ProfessionalRowMapper(), professionalId);
        } catch (Exception e) {
            logger.severe("Error getting professional by ID: " + e.getMessage());
            return null;
        }
    }

    public Professional getProfessionalByEmail(String email) {
        String sql = "SELECT * FROM professionals WHERE email = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new ProfessionalRowMapper(), email);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }
    
    public List<Professional> getAvailableProfessionals() {
        String sql = "SELECT cp.*, u.full_name, u.email, u.phone " +
                    "FROM counseling_professionals cp " +
                    "JOIN users u ON cp.professional_id = u.user_id " +
                    "WHERE cp.is_available = TRUE " +
                    "ORDER BY u.full_name";
        
        try {
            return jdbcTemplate.query(sql, new ProfessionalRowMapper());
        } catch (Exception e) {
            logger.severe("Error getting available professionals: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    public List<Professional> getAllProfessionals() {
        String sql = "SELECT cp.*, u.full_name, u.email, u.phone " +
                    "FROM counseling_professionals cp " +
                    "JOIN users u ON cp.professional_id = u.user_id " +
                    "ORDER BY u.full_name";
        
        try {
            return jdbcTemplate.query(sql, new ProfessionalRowMapper());
        } catch (Exception e) {
            logger.severe("Error getting all professionals: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    public boolean saveProfessional(Professional professional) {
        String checkSql = "SELECT COUNT(*) FROM counseling_professionals WHERE professional_id = ?";
        
        try {
            Integer count = jdbcTemplate.queryForObject(checkSql, Integer.class, professional.getProfessionalId());
            boolean exists = count != null && count > 0;
            
            if (!exists) {
                String insertSql = "INSERT INTO counseling_professionals " +
                                  "(professional_id, specialization, qualifications, experience_years, " +
                                  "license_number, hourly_rate, availability, is_available, bio) " +
                                  "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                int affectedRows = jdbcTemplate.update(insertSql,
                    professional.getProfessionalId(),
                    professional.getSpecialization(),
                    professional.getQualifications(),
                    professional.getExperienceYears(),
                    professional.getLicenseNumber(),
                    professional.getHourlyRate(),
                    professional.getAvailability(),
                    professional.isAvailable(),
                    professional.getBio()
                );
                
                if (affectedRows > 0) {
                    logger.info("Professional info saved: ID " + professional.getProfessionalId());
                    return true;
                }
            } else {
                String updateSql = "UPDATE counseling_professionals SET " +
                                  "specialization = ?, qualifications = ?, experience_years = ?, " +
                                  "license_number = ?, hourly_rate = ?, availability = ?, " +
                                  "is_available = ?, bio = ? WHERE professional_id = ?";
                
                int affectedRows = jdbcTemplate.update(updateSql,
                    professional.getSpecialization(),
                    professional.getQualifications(),
                    professional.getExperienceYears(),
                    professional.getLicenseNumber(),
                    professional.getHourlyRate(),
                    professional.getAvailability(),
                    professional.isAvailable(),
                    professional.getBio(),
                    professional.getProfessionalId()
                );
                
                if (affectedRows > 0) {
                    logger.info("Professional info updated: ID " + professional.getProfessionalId());
                    return true;
                }
            }
        } catch (Exception e) {
            logger.severe("Error saving professional info: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateAvailability(int professionalId, boolean isAvailable) {
        String sql = "UPDATE counseling_professionals SET is_available = ? WHERE professional_id = ?";
        
        try {
            int affectedRows = jdbcTemplate.update(sql, isAvailable, professionalId);
            if (affectedRows > 0) {
                logger.info("Professional availability updated: ID " + professionalId + " to " + isAvailable);
                return true;
            }
        } catch (Exception e) {
            logger.severe("Error updating professional availability: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    public Map<String, Object> getProfessionalStatistics(int professionalId) {
        String sql = "SELECT " +
                    "COUNT(*) as total_sessions, " +
                    "SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) as completed_sessions, " +
                    "SUM(CASE WHEN status = 'Scheduled' THEN 1 ELSE 0 END) as scheduled_sessions, " +
                    "SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) as cancelled_sessions " +
                    "FROM counseling_sessions WHERE professional_id = ?";
        
        Map<String, Object> stats = new HashMap<>();
        
        try {
            Map<String, Object> row = jdbcTemplate.queryForMap(sql, professionalId);
            stats.put("total_sessions", row.get("total_sessions"));
            stats.put("completed_sessions", row.get("completed_sessions"));
            stats.put("scheduled_sessions", row.get("scheduled_sessions"));
            stats.put("cancelled_sessions", row.get("cancelled_sessions"));
        } catch (Exception e) {
            logger.severe("Error getting professional statistics: " + e.getMessage());
            e.printStackTrace();
        }
        return stats;
    }
    
    public List<Map<String, Object>> getProfessionalsWithWorkload() {
        String sql = "SELECT cp.*, u.full_name, u.email, " +
                    "(SELECT COUNT(*) FROM counseling_sessions cs " +
                    " WHERE cs.professional_id = cp.professional_id AND cs.status = 'Scheduled') as pending_sessions, " +
                    "(SELECT COUNT(*) FROM counseling_sessions cs " +
                    " WHERE cs.professional_id = cp.professional_id AND cs.status = 'Completed') as completed_sessions " +
                    "FROM counseling_professionals cp " +
                    "JOIN users u ON cp.professional_id = u.user_id " +
                    "ORDER BY u.full_name";
        
        try {
            return jdbcTemplate.queryForList(sql);
        } catch (Exception e) {
            logger.severe("Error getting professionals with workload: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    private static class ProfessionalRowMapper implements RowMapper<Professional> {
        @Override
        public Professional mapRow(ResultSet rs, int rowNum) throws SQLException {
            Professional professional = new Professional();
            professional.setProfessionalId(rs.getInt("professional_id"));
            professional.setFullName(rs.getString("full_name"));
            professional.setEmail(rs.getString("email"));
            professional.setPhone(rs.getString("phone"));
            professional.setSpecialization(rs.getString("specialization"));
            professional.setQualifications(rs.getString("qualifications"));
            professional.setExperienceYears(rs.getInt("experience_years"));
            professional.setLicenseNumber(rs.getString("license_number"));
            professional.setHourlyRate(rs.getBigDecimal("hourly_rate"));
            professional.setAvailability(rs.getString("availability"));
            professional.setAvailable(rs.getBoolean("is_available"));
            professional.setBio(rs.getString("bio"));
            
            Timestamp createdAt = rs.getTimestamp("created_at");
            if (createdAt != null) {
                professional.setCreatedAt(createdAt.toLocalDateTime());
            }
            
            Timestamp lastLogin = rs.getTimestamp("last_login");
            if (lastLogin != null) {
                professional.setLastLogin(lastLogin.toLocalDateTime());
            }
            
            return professional;
        }
    }
}