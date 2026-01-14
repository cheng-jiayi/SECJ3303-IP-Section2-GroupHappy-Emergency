package smilespace.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import smilespace.dao.CounselingDAO;
import smilespace.dao.UserDAO;
import smilespace.model.CounselingSession;
import smilespace.model.User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CounselingService {
    
    @Autowired
    private CounselingDAO counselingDAO;
    
    @Autowired
    private UserDAO userDAO;

    public CounselingSession bookSession(int studentId, LocalDateTime scheduledDateTime, 
                                 String sessionType, String currentMood, 
                                 String reason, String additionalNotes, 
                                 String followUpMethod) {
    
        System.out.println("=== SERVICE DEBUG: Booking session ===");
        System.out.println("Student ID: " + studentId);
        System.out.println("DateTime: " + scheduledDateTime);
        System.out.println("Type: " + sessionType);
        System.out.println("Mood: " + currentMood);
        System.out.println("Reason: " + reason);
        System.out.println("Follow-up: " + followUpMethod);

        try {
            CounselingSession session = new CounselingSession();
            session.setStudentId(studentId);
            session.setScheduledDateTime(scheduledDateTime);
            session.setSessionType(sessionType);
            session.setCurrentMood(currentMood);
            session.setReason(reason);
            session.setAdditionalNotes(additionalNotes);
            session.setFollowUpMethod(followUpMethod != null ? followUpMethod : "Email");
            session.setStatus("Pending Assignment");
            
            System.out.println("📋 Session object created:");
            System.out.println("  - Student ID: " + session.getStudentId());
            System.out.println("  - Date/Time: " + session.getScheduledDateTime());
            System.out.println("  - Type: " + session.getSessionType());
            System.out.println("  - Mood: " + session.getCurrentMood());
            System.out.println("  - Reason: " + session.getReason());
            System.out.println("  - Status: " + session.getStatus());

            System.out.println("💾 Calling DAO to save session...");
            boolean success = counselingDAO.createCounselingSession(session);
            
            System.out.println("DAO returned success: " + success);
            
            if (success) {
                System.out.println("✅ Session saved to database");
                System.out.println("Generated Session ID: " + session.getSessionId());
                return session;
            } else {
                System.err.println("❌ Failed to save session to database");
                return null;
            }
            
        } catch (Exception e) {
            System.err.println("💥 Error in bookSession: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public boolean completeSession(int sessionId, String summary, String progressNotes,
                                   String followUpActions, String attachmentPath) {
        
        System.out.println("=== SERVICE DEBUG: Completing session " + sessionId + " ===");
        
        CounselingSession session = counselingDAO.getSessionById(sessionId);
        
        if (session != null) {
            session.setStatus("Completed");
            session.setActualDateTime(LocalDateTime.now());
            session.setSessionSummary(summary);
            session.setProgressNotes(progressNotes);
            session.setFollowUpActions(followUpActions);
            session.setAttachmentPath(attachmentPath);
            session.setUpdatedAt(LocalDateTime.now());
            
            boolean success = counselingDAO.updateSession(session);
            System.out.println("Session completion: " + (success ? "SUCCESS" : "FAILED"));
            return success;
        }
        
        return false;
    }

    public boolean scheduleNextSession(int sessionId, LocalDateTime nextSessionDateTime) {
        
        System.out.println("=== SERVICE DEBUG: Scheduling next session ===");
        
        CounselingSession session = counselingDAO.getSessionById(sessionId);
        
        if (session != null) {
            session.setNextSessionSuggested(nextSessionDateTime);
            session.setUpdatedAt(LocalDateTime.now());
            
            boolean success = counselingDAO.updateSession(session);
            System.out.println("Next session scheduling: " + (success ? "SUCCESS" : "FAILED"));
            return success;
        }
        
        return false;
    }

    public User getCounselorById(int counselorId) {
        return userDAO.getUserById(counselorId);
    }

    public List<CounselingSession> getStudentSessions(int studentId) {
        return counselingDAO.getSessionsByStudentId(studentId);
    }

    public List<CounselingSession> getCounselorSessions(int counselorId) {
        return counselingDAO.getSessionsByCounselorId(counselorId);
    }

    public CounselingSession getSessionById(int sessionId) {
        return counselingDAO.getSessionById(sessionId);
    }

    public boolean isTimeSlotAvailable(LocalDateTime dateTime) {
        List<Integer> availableCounselors = counselingDAO.getAvailableCounselors(dateTime);
        return !availableCounselors.isEmpty();
    }

    public boolean updateSession(CounselingSession session) {
        return counselingDAO.updateSession(session);
    }

    public boolean deleteSession(int sessionId) {
        return counselingDAO.deleteSession(sessionId);
    }

    public boolean cancelSession(int sessionId, int userId) {
        CounselingSession session = counselingDAO.getSessionById(sessionId);
        if (session != null && session.getStudentId() == userId) {
            session.setStatus("Cancelled");
            return counselingDAO.updateSession(session);
        }
        return false;
    }
    
    public boolean submitFeedback(int sessionId, String feedback, int rating) {
        CounselingSession session = counselingDAO.getSessionById(sessionId);
        if (session != null && "Completed".equals(session.getStatus())) {
            session.setStudentFeedback(feedback);
            session.setRating(rating);
            session.setUpdatedAt(LocalDateTime.now());
            return counselingDAO.updateSession(session);
        }
        return false;
    }

    public List<CounselingSession> getUpcomingStudentSessions(int studentId) {
        List<CounselingSession> allSessions = counselingDAO.getSessionsByStudentId(studentId);
        LocalDateTime now = LocalDateTime.now();

        return allSessions.stream()
                .filter(session -> "Scheduled".equals(session.getStatus()) ||
                                   "Pending Assignment".equals(session.getStatus()))
                .filter(session -> session.getScheduledDateTime() != null &&
                                  session.getScheduledDateTime().isAfter(now))
                .collect(Collectors.toList());
    }

    public List<CounselingSession> getUpcomingCounselorSessions(int counselorId) {
        List<CounselingSession> allSessions = counselingDAO.getSessionsByCounselorId(counselorId);
        LocalDateTime now = LocalDateTime.now();

        return allSessions.stream()
                .filter(session -> "Scheduled".equals(session.getStatus()) ||
                                   "Pending Assignment".equals(session.getStatus()))
                .filter(session -> session.getScheduledDateTime() != null &&
                                  session.getScheduledDateTime().isAfter(now))
                .collect(Collectors.toList());
    }

    public boolean hasUpcomingSession(int studentId) {
        List<CounselingSession> upcoming = getUpcomingStudentSessions(studentId);
        return !upcoming.isEmpty();
    }
    
    public boolean assignCounselor(int sessionId, int counselorId) {
        CounselingSession session = counselingDAO.getSessionById(sessionId);
        if (session != null && "Pending Assignment".equals(session.getStatus())) {
            session.setCounselorId(counselorId);
            session.setStatus("Scheduled");
            session.setUpdatedAt(LocalDateTime.now());
            return counselingDAO.updateSession(session);
        }
        return false;
    }
    
    public List<CounselingSession> getSessionsPendingAssignment() {
        List<CounselingSession> allSessions = counselingDAO.getAllSessions();
        return allSessions.stream()
                .filter(session -> "Pending Assignment".equals(session.getStatus()))
                .collect(Collectors.toList());
    }
    
    public List<CounselingSession> getAllSessions() {
        return counselingDAO.getAllSessions();
    }
}