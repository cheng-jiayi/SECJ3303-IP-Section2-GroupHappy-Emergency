package smilespace.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import smilespace.dao.ReferralDAO;
import smilespace.model.Referral;
import java.util.List;

@Service
public class ReferralService {
    
    @Autowired
    private ReferralDAO referralDAO;
    
    public List<Referral> getPendingReferrals() {
        return referralDAO.getPendingReferrals();
    }
    
    public List<Referral> getCounselorReferrals(int counselorId) {
        return referralDAO.getReferralsByCounselor(counselorId);
    }
    
    @Transactional
    public boolean submitReferral(int studentId, int facultyId, String reason, 
                                 String urgency, String notes) {
        Referral referral = new Referral();
        referral.setStudentId(studentId);
        referral.setFacultyId(facultyId);
        referral.setReason(reason);
        referral.setUrgency(urgency);
        referral.setNotes(notes);
        
        return referralDAO.saveReferral(referral) > 0;
    }
    
    @Transactional
    public boolean acceptReferral(int referralId, int counselorId) {
        return referralDAO.acceptReferral(referralId, counselorId);
    }
    
    public Referral getReferralById(int referralId) {
        return referralDAO.getReferralById(referralId);
    }
    
    public Referral getLatestReferralByStudent(int studentId) {
        return referralDAO.getLatestReferralByStudent(studentId);
    }

    public Referral getReferralWithDetails(int referralId) {
        return referralDAO.getReferralByIdWithDetails(referralId);
    }

    public List<Referral> getReferralsByFaculty(int facultyId) {
        return referralDAO.getReferralsByFaculty(facultyId);
    }
}