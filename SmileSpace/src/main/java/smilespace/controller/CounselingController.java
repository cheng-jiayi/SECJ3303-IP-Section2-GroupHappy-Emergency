package smilespace.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import smilespace.model.CounselingSession;
import smilespace.model.Professional;
import smilespace.model.Referral;
import smilespace.model.Student;
import smilespace.model.User;
import smilespace.service.CounselingService;
import smilespace.service.ProfessionalService;
import smilespace.service.ReferralService;
import smilespace.service.StudentService;
import smilespace.dao.UserDAO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Controller
@RequestMapping("/counseling")
public class CounselingController {
    
    @Autowired
    private CounselingService counselingService;
    
    @Autowired
    private StudentService studentService;

    @Autowired
    private ProfessionalService professionalService;

    @Autowired
    private ReferralService referralService;
    
    @Autowired
    private UserDAO userDAO;
    
    @GetMapping
    public String handleGet(@RequestParam(value = "action", required = false) String action,
                           @RequestParam(value = "sessionId", required = false) Integer sessionId,
                           HttpSession session,
                           Model model) {
        
        System.out.println("===== DEBUG: CounselingController.handleGet =====");
        System.out.println("DEBUG: Action: " + action);
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        int userId = user.getUserId();
        String userRole = user.getUserRole();
        
        try {
            if ("bookSession".equals(action)) {
                return showBookingForm(userId, userRole, model);
            } else if ("viewSessions".equals(action)) {
                if ("student".equals(userRole)) {
                    return showStudentSessions(userId, model);
                } else if ("professional".equals(userRole)) {
                    return showCounselorSessions(userId, model, session);
                } else {
                    return "redirect:/index.jsp";
                }
            } else if ("sessionDetails".equals(action) && sessionId != null) {
                return showSessionDetails(userId, userRole, sessionId, model);
            } else if ("documentSession".equals(action) && sessionId != null) {
                if ("professional".equals(userRole)) {
                    return showDocumentSessionForm(userId, sessionId, model);
                } else {
                    return "redirect:/counseling?action=viewSessions";
                }
            } else {
                // Default action based on user role
                if ("student".equals(userRole)) {
                    return showStudentSessions(userId, model);
                } else if ("professional".equals(userRole)) {
                    return showCounselorSessions(userId, model, session);
                } else {
                    return "redirect:/index.jsp";
                }
            }
        } catch (Exception e) {
            System.err.println("ERROR in CounselingController: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Error: " + e.getMessage());
            return "error";
        }
    }
    
    @PostMapping
    public String handlePost(@RequestParam(value = "action", required = false) String action,
                            @RequestParam(value = "sessionId", required = false) Integer sessionId,
                            @RequestParam(value = "sessionDate", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate sessionDate,
                            @RequestParam(value = "sessionTime", required = false) String sessionTime,
                            @RequestParam(value = "sessionType", required = false) String sessionType,
                            @RequestParam(value = "currentMood", required = false) String currentMood,
                            @RequestParam(value = "reason", required = false) String reason,
                            @RequestParam(value = "additionalNotes", required = false) String additionalNotes,
                            @RequestParam(value = "followUpMethod", defaultValue = "Email") String followUpMethod,
                            @RequestParam(value = "summary", required = false) String summary,
                            @RequestParam(value = "progressNotes", required = false) String progressNotes,
                            @RequestParam(value = "followUpActions", required = false) String followUpActions,
                            @RequestParam(value = "nextSessionSuggested", required = false) String nextSessionSuggested,
                            @RequestParam(value = "nextSessionDate", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate nextSessionDate,
                            @RequestParam(value = "nextSessionTime", required = false) String nextSessionTime,
                            @RequestParam(value = "attachment", required = false) MultipartFile attachmentFile,
                            HttpSession session,
                            HttpServletRequest request,
                            Model model) throws IOException {
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        int userId = user.getUserId();
        String userRole = user.getUserRole();
        
        try {
            if ("submitBooking".equals(action) && "student".equals(userRole)) {
                return submitBooking(userId, sessionDate, sessionTime, sessionType, currentMood, 
                                   reason, additionalNotes, followUpMethod, model, request);
            } else if ("submitDocumentation".equals(action) && "professional".equals(userRole) && sessionId != null) {
                return submitDocumentation(userId, sessionId, summary, progressNotes, followUpActions,
                                          nextSessionSuggested, nextSessionDate, nextSessionTime,
                                          attachmentFile, model, request);
            } else if ("deleteSession".equals(action) && sessionId != null) {
                return deleteSession(userId, userRole, sessionId);
            } else if ("acceptSessions".equals(action) && "professional".equals(userRole)) {
                return acceptSessions(userId, request, model);
            } else if ("acceptSingleSession".equals(action) && "professional".equals(userRole) && sessionId != null) {
                return acceptSingleSession(userId, sessionId, model);
            } else {
                return "redirect:/counseling?action=viewSessions";
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error: " + e.getMessage());
            return "error";
        }
    }
    
    private String showBookingForm(int userId, String userRole, Model model) {
        if (!"student".equals(userRole)) {
            return "redirect:/counseling?action=viewSessions";
        }
        return "virtualCounselingModule/student/bookingForm";
    }
    
    private String submitBooking(int studentId, LocalDate sessionDate, String sessionTimeStr,
                               String sessionType, String currentMood, String reason,
                               String additionalNotes, String followUpMethod,
                               Model model, HttpServletRequest request) {
        
        System.out.println("=== CONTROLLER DEBUG: submitBooking START ===");
        
        // Validate required fields
        if (sessionDate == null || sessionTimeStr == null || sessionTimeStr.isEmpty() ||
            sessionType == null || sessionType.isEmpty() ||
            currentMood == null || currentMood.isEmpty() ||
            reason == null || reason.isEmpty()) {
            
            model.addAttribute("error", "Please fill in all required fields (*)");
            return "virtualCounselingModule/student/bookingForm";
        }
        
        // Parse time
        LocalTime time;
        try {
            sessionTimeStr = sessionTimeStr.trim();
            if (!sessionTimeStr.contains(":")) {
                if (sessionTimeStr.length() == 4) {
                    sessionTimeStr = sessionTimeStr.substring(0, 2) + ":" + sessionTimeStr.substring(2);
                } else if (sessionTimeStr.length() == 3) {
                    sessionTimeStr = "0" + sessionTimeStr.substring(0, 1) + ":" + sessionTimeStr.substring(1);
                }
            }
            
            if (sessionTimeStr.split(":").length == 2) {
                sessionTimeStr = sessionTimeStr + ":00";
            }
            
            time = LocalTime.parse(sessionTimeStr);
        } catch (Exception e) {
            model.addAttribute("error", "Invalid time format. Please use HH:MM format");
            return "virtualCounselingModule/student/bookingForm";
        }
        
        LocalDateTime scheduledDateTime = LocalDateTime.of(sessionDate, time);
        
        // Check if date is in the future
        if (scheduledDateTime.isBefore(LocalDateTime.now())) {
            model.addAttribute("error", "Please select a future date and time");
            return "virtualCounselingModule/student/bookingForm";
        }
        
        // Book the session
        CounselingSession session = counselingService.bookSession(
            studentId, scheduledDateTime, sessionType, currentMood, 
            reason, additionalNotes, followUpMethod
        );
        
        if (session != null && session.getSessionId() > 0) {
            model.addAttribute("session", session);
            model.addAttribute("successMessage", "Session booked successfully!");
            return "virtualCounselingModule/student/bookingConfirmation";
        } else {
            model.addAttribute("error", "Failed to book session. Please try again.");
            return "virtualCounselingModule/student/bookingForm";
        }
    }
    
    private String showStudentSessions(int userId, Model model) {
        List<CounselingSession> sessions = counselingService.getStudentSessions(userId);
        model.addAttribute("sessions", sessions);
        return "virtualCounselingModule/student/studentSessions";
    }

    private String showCounselorSessions(int userId, Model model, HttpSession httpSession) {
        System.out.println("=== DEBUG showCounselorSessions ===");
        System.out.println("User ID: " + userId);
        
        // Get assigned counseling sessions
        List<CounselingSession> mySessions = counselingService.getCounselorSessions(userId);
        System.out.println("My assigned sessions count: " + mySessions.size());
        
        // Get unassigned counseling sessions
        List<CounselingSession> unassignedSessions = counselingService.getSessionsPendingAssignment();
        System.out.println("Unassigned sessions count: " + unassignedSessions.size());
        
        // Get pending referrals (THIS IS CRITICAL - add this line)
        List<Referral> pendingReferrals = referralService.getPendingReferrals();
        System.out.println("Pending referrals count: " + pendingReferrals.size());
        
        // Get professional info
        Professional professional = null;
        User user = (User) httpSession.getAttribute("user");
        if (user != null && "professional".equals(user.getUserRole())) {
            try {
                professional = professionalService.getProfessionalById(userId);
                
                if (professional == null) {
                    System.out.println("No professional found with ID: " + userId);
                    // Create basic professional object from user
                    professional = new Professional();
                    professional.setFullName(user.getFullName());
                    professional.setEmail(user.getEmail());
                    professional.setSpecialization("Mental Health");
                    professional.setExperienceYears(0);
                    System.out.println("Created dummy professional from user info");
                } else {
                    System.out.println("Got Professional info for: " + professional.getFullName());
                }
            } catch (Exception e) {
                System.err.println("Error getting professional info: " + e.getMessage());
                e.printStackTrace();
                // Create basic professional object from user
                professional = new Professional();
                professional.setFullName(user.getFullName());
                professional.setEmail(user.getEmail());
                professional.setSpecialization("Mental Health");
            }
        }
        
        // ADD THESE TO THE MODEL:
        model.addAttribute("mySessions", mySessions);
        model.addAttribute("unassignedSessions", unassignedSessions);
        model.addAttribute("pendingReferrals", pendingReferrals); // ← ADD THIS LINE
        model.addAttribute("professional", professional);
        
        return "virtualCounselingModule/professional/mhpSessions";
    }

    private String showSessionDetails(int userId, String userRole, int sessionId, Model model) {
        System.out.println("\n\n===== DEBUG: showSessionDetails START =====");
        System.out.println("DEBUG: User ID: " + userId);
        System.out.println("DEBUG: User Role: " + userRole);
        System.out.println("DEBUG: Session ID: " + sessionId);
        
        CounselingSession session = counselingService.getSessionById(sessionId);
        
        if (session == null) {
            System.out.println("ERROR: Session is NULL");
            return "redirect:/counseling?action=viewSessions";
        }
        
        System.out.println("DEBUG: Session found - ID: " + session.getSessionId());
        
        // Check permissions
        if (!(session.getStudentId() == userId || 
            (session.getCounselorId() != null && session.getCounselorId() == userId))) {
            System.out.println("ERROR: Permission denied");
            return "redirect:/counseling?action=viewSessions";
        }
        
        model.addAttribute("session", session);
        
        if ("professional".equals(userRole)) {
            System.out.println("DEBUG: Getting student info for professional");
            Student student = studentService.getStudentByUserId(session.getStudentId());
            if (student != null) {
                model.addAttribute("student", student);
            }
            
            // IMPORTANT: Check what view name is being returned
            String viewName = "virtualCounselingModule/professional/sessionDetails";
            System.out.println("DEBUG: Returning view: " + viewName);
            return viewName;
        } else {
            String viewName = "virtualCounselingModule/student/sessionDetails";
            System.out.println("DEBUG: Returning view: " + viewName);
            return viewName;
        }
    }

    private String showDocumentSessionForm(int userId, int sessionId, Model model) {
        CounselingSession session = counselingService.getSessionById(sessionId);
        if (session == null || session.getCounselorId() != userId || !session.isScheduled()) {
            return "redirect:/counseling?action=professionalSessions";
        }
        
        Student student = studentService.getStudentByUserId(session.getStudentId());
        if (student != null) {
            model.addAttribute("student", student);
        }
        
        model.addAttribute("session", session);
        return "virtualCounselingModule/professional/documentSession";
    }
    
    private String submitDocumentation(int userId, int sessionId, String summary, 
                                      String progressNotes, String followUpActions,
                                      String nextSessionSuggested, LocalDate nextSessionDate,
                                      String nextSessionTime, MultipartFile attachmentFile,
                                      Model model, HttpServletRequest request) throws IOException {
        
        CounselingSession session = counselingService.getSessionById(sessionId);
        if (session == null || session.getCounselorId() != userId || !session.isScheduled()) {
            return "redirect:/counseling?action=professionalSessions";
        }
        
        // Handle file upload
        String attachmentPath = null;
        if (attachmentFile != null && !attachmentFile.isEmpty()) {
            String fileName = attachmentFile.getOriginalFilename();
            if (fileName != null && !fileName.isEmpty()) {
                String uploadDir = request.getServletContext().getRealPath("") + File.separator + 
                                 "uploads" + File.separator + "counseling";
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                String uniqueFileName = sessionId + "_" + System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadDir + File.separator + uniqueFileName;
                attachmentFile.transferTo(new File(filePath));
                
                attachmentPath = "uploads/counseling/" + uniqueFileName;
            }
        }
        
        // Complete the session
        boolean success = counselingService.completeSession(
            sessionId, summary, progressNotes, followUpActions, attachmentPath
        );
        
        // Schedule next session if requested
        if ("Yes".equals(nextSessionSuggested) && nextSessionDate != null && nextSessionTime != null) {
            try {
                LocalTime time = LocalTime.parse(nextSessionTime);
                LocalDateTime nextSessionDateTime = LocalDateTime.of(nextSessionDate, time);
                counselingService.scheduleNextSession(sessionId, nextSessionDateTime);
            } catch (Exception e) {
                System.err.println("Error scheduling next session: " + e.getMessage());
            }
        }
        
        if (success) {
            return "redirect:/counseling?action=sessionDetails&sessionId=" + sessionId;
        } else {
            model.addAttribute("error", "Failed to submit documentation. Please try again.");
            return showDocumentSessionForm(userId, sessionId, model);
        }
    }
    
    private String deleteSession(int userId, String userRole, int sessionId) {
        CounselingSession session = counselingService.getSessionById(sessionId);
        if (session == null) {
            return "redirect:/counseling?action=viewSessions";
        }
        
        // Check permissions
        boolean hasPermission = false;
        if ("student".equals(userRole) && session.getStudentId() == userId) {
            hasPermission = true;
        } else if ("professional".equals(userRole) && session.getCounselorId() == userId) {
            hasPermission = true;
        }
        
        if (hasPermission) {
            boolean deleted = counselingService.deleteSession(sessionId);
            if (deleted) {
                return "redirect:/counseling?action=viewSessions";
            }
        }
        
        return "redirect:/counseling?action=viewSessions";
    }
    
    private String acceptSessions(int userId, HttpServletRequest request, Model model) {
        String[] sessionIds = request.getParameterValues("sessionIds");
        if (sessionIds != null && sessionIds.length > 0) {
            System.out.println("Accepting multiple sessions: " + sessionIds.length);
            for (String sessionIdStr : sessionIds) {
                try {
                    int sessionId = Integer.parseInt(sessionIdStr);
                    counselingService.assignCounselor(sessionId, userId);
                    System.out.println("Assigned session " + sessionId + " to counselor " + userId);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid session ID: " + sessionIdStr);
                }
            }
        }
        return "redirect:/counseling?action=viewSessions";
    }
    
    private String acceptSingleSession(int userId, int sessionId, Model model) {
        System.out.println("Accepting single session: " + sessionId);
        boolean success = counselingService.assignCounselor(sessionId, userId);
        if (success) {
            System.out.println("Successfully assigned session " + sessionId);
        } else {
            System.out.println("Failed to assign session " + sessionId);
        }
        return "redirect:/counseling?action=viewSessions";
    }
}