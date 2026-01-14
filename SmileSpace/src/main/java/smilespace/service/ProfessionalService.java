package smilespace.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import smilespace.dao.ProfessionalDAO;
import smilespace.model.Professional;

import java.util.List;
import java.util.Map;

@Service
public class ProfessionalService {
    
    @Autowired
    private ProfessionalDAO professionalDAO;
    
    public Professional getProfessionalById(int professionalId) {
        return professionalDAO.getProfessionalById(professionalId);
    }
    
    public List<Professional> getAvailableProfessionals() {
        return professionalDAO.getAvailableProfessionals();
    }
    
    public List<Professional> getAllProfessionals() {
        return professionalDAO.getAllProfessionals();
    }
    
    public boolean saveProfessional(Professional professional) {
        return professionalDAO.saveProfessional(professional);
    }
    
    public boolean updateAvailability(int professionalId, boolean isAvailable) {
        return professionalDAO.updateAvailability(professionalId, isAvailable);
    }
    
    public Map<String, Object> getProfessionalStatistics(int professionalId) {
        return professionalDAO.getProfessionalStatistics(professionalId);
    }
    
    public List<Map<String, Object>> getProfessionalsWithWorkload() {
        return professionalDAO.getProfessionalsWithWorkload();
    }
    
    // Method to assign professional to session
    public boolean assignProfessionalToSession(int sessionId, int professionalId) {
        // This should call a method in CounselingDAO
        // You'll need to add this method to your CounselingDAO
        return false; //Place
        // holder - implement this 
    }

    public Professional getProfessionalByEmail(String email) {
        return professionalDAO.getProfessionalByEmail(email);
    }
}