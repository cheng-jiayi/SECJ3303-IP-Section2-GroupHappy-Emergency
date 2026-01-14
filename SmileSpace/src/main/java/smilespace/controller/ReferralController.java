package smilespace.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import smilespace.model.Referral;
import smilespace.model.Student;
import smilespace.model.User;
import smilespace.service.ReferralService;
import smilespace.service.StudentService;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/referral")
public class ReferralController {
    
    @Autowired
    private StudentService studentService;
    
    @Autowired
    private ReferralService referralService;
    
    // View at-risk students - This matches your JSP
    @GetMapping
    public String viewAtRiskStudents(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"faculty".equals(user.getUserRole())) {
            return "redirect:/login";
        }
        
        // Get students with referral status
        List<Student> atRiskStudents = studentService.getAtRiskStudentsWithReferralStatus(user.getUserId());
        model.addAttribute("students", atRiskStudents);
        
        return "virtualCounselingModule/faculty/atRiskStudents";
    }
    
    // Show referral form - This matches your JSP call
    @GetMapping("/referralForm")
    public String showReferralForm(@RequestParam("studentId") String studentId,
                                   HttpSession session,
                                   Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"faculty".equals(user.getUserRole())) {
            return "redirect:/login";
        }
        
        // Extract numeric ID from "STU001" format
        int numericId = extractNumericId(studentId);
        Student student = studentService.getStudentByUserId(numericId);
        if (student == null) {
            return "redirect:/referral";
        }
        
        model.addAttribute("student", student);
        model.addAttribute("faculty", user);
        
        return "virtualCounselingModule/faculty/referralForm";
    }
    
     public String viewReferral(@RequestParam("referralId") int referralId,
                            HttpSession session,
                            Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        // Check if user is faculty or professional
        boolean isFaculty = "faculty".equals(user.getUserRole());
        boolean isProfessional = "professional".equals(user.getUserRole());
        
        if (!isFaculty && !isProfessional) {
            return "redirect:/login";
        }
        
        // Get the referral with full details
        Referral referral = referralService.getReferralWithDetails(referralId);
        if (referral == null) {
            String redirectUrl = isFaculty ? "/referral?error=Referral+not+found" 
                                           : "/counseling?action=viewSessions&error=Referral+not+found";
            return "redirect:" + redirectUrl;
        }
        
        // Check permissions
        boolean hasAccess = false;
        String viewName = "";
        
        if (isFaculty) {
            // Faculty can only view referrals they submitted
            if (referral.getFacultyId() == user.getUserId()) {
                hasAccess = true;
                viewName = "virtualCounselingModule/faculty/viewReferral";
            }
        } else if (isProfessional) {
            // Professionals can view any referral (especially pending ones they might accept)
            hasAccess = true;
            viewName = "virtualCounselingModule/professional/referralDetails";
        }
        
        if (!hasAccess) {
            String redirectUrl = isFaculty ? "/referral?error=Access+denied" 
                                           : "/counseling?action=viewSessions&error=Access+denied";
            return "redirect:" + redirectUrl;
        }
        
        // Get student information
        Student student = studentService.getStudentByUserId(referral.getStudentId());
        if (student == null) {
            String redirectUrl = isFaculty ? "/referral?error=Student+not+found" 
                                           : "/counseling?action=viewSessions&error=Student+not+found";
            return "redirect:" + redirectUrl;
        }
        
        model.addAttribute("referral", referral);
        model.addAttribute("student", student);
        model.addAttribute("userRole", user.getUserRole()); // Pass user role to JSP
        
        return viewName;
    }

    // Submit referral
    @PostMapping("/submit")
    public String submitReferral(@RequestParam("studentId") String studentId,
                                @RequestParam("reason") String reason,
                                @RequestParam("urgency") String urgency,
                                @RequestParam(value = "otherReason", required = false) String otherReason,
                                @RequestParam("notify") String notify,
                                @RequestParam(value = "notes", required = false) String notes,
                                HttpSession session) {
        User faculty = (User) session.getAttribute("user");
        if (faculty == null || !"faculty".equals(faculty.getUserRole())) {
            return "redirect:/login";
        }
        
        // Extract numeric ID
        int numericId = extractNumericId(studentId);
        
        // If "Other" reason is selected, use the custom reason
        String finalReason = reason;
        if ("Other".equals(reason) && otherReason != null && !otherReason.trim().isEmpty()) {
            finalReason = "Other: " + otherReason.trim();
        }
        
        // Combine notify method with notes
        String finalNotes = "Notification Method: " + notify;
        if (notes != null && !notes.trim().isEmpty()) {
            finalNotes += "\n\nAdditional Notes: " + notes;
        }
        
        boolean success = referralService.submitReferral(
            numericId, faculty.getUserId(), finalReason, urgency, finalNotes
        );
        
        if (success) {
            return "redirect:/referral/success?studentId=" + numericId;
        } else {
            return "redirect:/referral/referralForm?studentId=" + studentId + "&error=true";
        }
    }
    
    // Success page
    @GetMapping("/success")
    public String showSuccess(@RequestParam("studentId") int studentId,
                             HttpSession session,
                             Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"faculty".equals(user.getUserRole())) {
            return "redirect:/login";
        }
        
        Student student = studentService.getStudentByUserId(studentId);
        if (student == null) {
            return "redirect:/referral";
        }
        
        // Get the latest referral for this student
        Referral latestReferral = referralService.getLatestReferralByStudent(studentId);
        if (latestReferral == null) {
            return "redirect:/referral";
        }
        
        model.addAttribute("student", student);
        model.addAttribute("referral", latestReferral);
        
        return "virtualCounselingModule/faculty/referralSuccess"; // This is the JSP filename
    }
    
    // Accept referral (for MHP)
    @PostMapping("/accept")
    public String acceptReferral(@RequestParam("referralId") int referralId,
                                HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"professional".equals(user.getUserRole())) {
            return "redirect:/login";
        }
        
        boolean success = referralService.acceptReferral(referralId, user.getUserId());
        
        if (success) {
            return "redirect:/counseling?action=viewSessions&message=Referral+accepted+successfully";
        } else {
            return "redirect:/counseling?action=viewSessions&error=Failed+to+accept+referral";
        }
    }
    
    // Helper method to extract numeric ID from "STU001" format
    private int extractNumericId(String studentId) {
        try {
            if (studentId.startsWith("STU")) {
                return Integer.parseInt(studentId.substring(3));
            }
            return Integer.parseInt(studentId);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}