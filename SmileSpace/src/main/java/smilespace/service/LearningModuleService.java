package smilespace.service;

import smilespace.model.LearningModule;
import smilespace.dao.LearningModuleDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Map;
import java.text.SimpleDateFormat;
import java.util.Date;

@Service
@Transactional
public class LearningModuleService {
    
    @Autowired
    private LearningModuleDAO moduleDAO;
    
    public boolean createModule(LearningModule module, int createdBy) {
        String nextId = generateNextModuleId();
        module.setId(nextId);
        module.setCreatedBy(createdBy);
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        module.setLastUpdated(sdf.format(new Date()));
        
        return moduleDAO.save(module);
    }
    
    public boolean updateModule(String id, LearningModule module) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        module.setLastUpdated(sdf.format(new Date()));
        module.setId(id);
        
        return moduleDAO.update(module);
    }
    
    public boolean deleteModule(String id) {
        return moduleDAO.delete(id);
    }
    
    public LearningModule getModuleById(String id) {
        return moduleDAO.findById(id);
    }
    
    public List<LearningModule> getAllModules() {
        return moduleDAO.findAll();
    }
    
    public List<LearningModule> getModulesByCategory(String category) {
        return moduleDAO.findByCategory(category);
    }
    
    public List<LearningModule> searchModules(String keyword, String category, String level) {
        return moduleDAO.search(keyword, category, level);
    }
    
    public boolean recordModuleAccess(String moduleId, int userId, String accessType) {
        moduleDAO.incrementViews(moduleId);
        return moduleDAO.recordAccess(moduleId, userId, accessType);
    }
    
    public Map<String, Object> getModuleStatistics() {
        return moduleDAO.getModuleStatistics();
    }
    
    public List<Map<String, Object>> getAccessHistory(String moduleId) {
        return moduleDAO.getAccessHistory(moduleId);
    }
    
    public boolean incrementModuleViews(String moduleId) {
        return moduleDAO.incrementViews(moduleId);
    }
    
    private String generateNextModuleId() {
        List<LearningModule> allModules = moduleDAO.findAll();
        int maxId = 0;
        
        for (LearningModule module : allModules) {
            String id = module.getId();
            if (id != null) {
                if (id.startsWith("LM")) {
                    try {
                        int idNum = Integer.parseInt(id.substring(2));
                        if (idNum > maxId) {
                            maxId = idNum;
                        }
                    } catch (NumberFormatException e) {
                        // Ignore non-numeric parts
                    }
                } else if (id.startsWith("UC")) {
                    try {
                        int idNum = Integer.parseInt(id.substring(2));
                        if (idNum > maxId) {
                            maxId = idNum;
                        }
                    } catch (NumberFormatException e) {
                        // Ignore non-numeric parts
                    }
                }
            }
        }
        
        // Start from LM010 if we already have LM001-LM009
        if (maxId < 10) {
            maxId = 9; // Start from LM010
        }
        
        return "LM" + String.format("%03d", maxId + 1);
    }
}