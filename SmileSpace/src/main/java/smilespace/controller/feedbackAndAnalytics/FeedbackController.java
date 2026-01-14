package smilespace.controller.feedbackAndAnalytics;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import smilespace.model.Feedback;
import smilespace.service.FeedbackAnalyticsService;
import smilespace.service.FeedbackService;

@Controller
@RequestMapping("/feedback")
public class FeedbackController {
    
    @Autowired
    private FeedbackService feedbackService;
    
    @Autowired
    private FeedbackAnalyticsService feedbackAnalyticsService;
    
    // Show feedback form (accessible to all users)
    @GetMapping("")
    public String showFeedbackForm(Model model, HttpSession session) {
        // Add user info to model
        String userFullName = (String) session.getAttribute("userFullName");
        String userEmail = (String) session.getAttribute("userEmail");
        
        model.addAttribute("userFullName", userFullName);
        model.addAttribute("userEmail", userEmail);
        
        return "feedbackAndAnalyticsModule/feedback";
    }
    
    // Submit feedback (accessible to all users)
    @PostMapping("/submit")
    public String submitFeedback(
            @RequestParam String name,
            @RequestParam(required = false) String email,
            @RequestParam String message,
            @RequestParam String category,
            @RequestParam Integer rating,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        // Get userId from session - handle both Integer and String types
        Integer userId = null;
        Object userIdObj = session.getAttribute("userId");
        
        if (userIdObj != null) {
            if (userIdObj instanceof Integer) {
                userId = (Integer) userIdObj;
            } else if (userIdObj instanceof String) {
                try {
                    userId = Integer.parseInt((String) userIdObj);
                } catch (NumberFormatException e) {
                    // Log error but continue - userId will be null
                    System.err.println("Warning: Could not parse userId from session: " + userIdObj);
                }
            } else {
                System.err.println("Warning: Unexpected userId type in session: " + userIdObj.getClass().getName());
            }
        }
        
        String userFullName = (String) session.getAttribute("userFullName");
        
        // If name is empty, use session name
        if ((name == null || name.trim().isEmpty()) && userFullName != null) {
            name = userFullName;
        }
        
        // Calculate sentiment based on rating
        String sentiment = "Neutral";
        if (rating <= 2) {
            sentiment = "Negative";
        } else if (rating == 3) {
            sentiment = "Neutral";
        } else if (rating >= 4) {
            sentiment = "Positive";
        }
        
        // Create Feedback object
        Feedback feedback = new Feedback();
        feedback.setName(name);
        feedback.setEmail(email);
        feedback.setMessage(message);
        feedback.setCategory(category != null ? category : "General");
        feedback.setSentiment(sentiment);
        feedback.setRating(rating);
        
        // Save to database
        boolean success = feedbackService.saveFeedback(feedback, userId);
        
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", 
                "Your feedback has been submitted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", 
                "Failed to submit feedback. Please try again.");
        }
        
        return "redirect:/feedback";
    }
    
    // Show feedback analytics (admin/faculty only)
    @GetMapping("/analytics")
    public String showFeedbackAnalytics(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String sentiment,
            @RequestParam(required = false) String status,
            Model model,
            HttpSession session) {
        
        // Authorization check (handled by interceptor, but double-check here)
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole) && !"faculty".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        // Fetch feedback based on filters
        List<Feedback> feedbackList;
        if ((search != null && !search.trim().isEmpty()) || 
            (sentiment != null && !sentiment.trim().isEmpty()) || 
            (status != null && !status.trim().isEmpty())) {
            feedbackList = feedbackAnalyticsService.searchFeedback(
                search != null ? search.trim() : null, 
                sentiment != null ? sentiment.trim() : null, 
                status != null ? status.trim() : null
            );
        } else {
            feedbackList = feedbackAnalyticsService.getAllFeedback();
        }
        
        // Get statistics
        Map<String, Integer> stats = feedbackAnalyticsService.getFeedbackStats();
        
        // Set attributes for view
        model.addAttribute("feedbackList", feedbackList);
        model.addAttribute("positiveCount", stats.getOrDefault("positive", 0));
        model.addAttribute("neutralCount", stats.getOrDefault("neutral", 0));
        model.addAttribute("negativeCount", stats.getOrDefault("negative", 0));
        model.addAttribute("resolvedCount", stats.getOrDefault("resolved", 0));
        model.addAttribute("totalFeedback", stats.getOrDefault("total", 0));
        
        // Calculate percentages
        int total = stats.getOrDefault("total", 0);
        if (total == 0) {
            model.addAttribute("positivePercent", 0);
            model.addAttribute("neutralPercent", 0);
            model.addAttribute("negativePercent", 0);
            model.addAttribute("resolvedPercent", 0);
        } else {
            model.addAttribute("positivePercent", (stats.getOrDefault("positive", 0) * 100) / total);
            model.addAttribute("neutralPercent", (stats.getOrDefault("neutral", 0) * 100) / total);
            model.addAttribute("negativePercent", (stats.getOrDefault("negative", 0) * 100) / total);
            model.addAttribute("resolvedPercent", (stats.getOrDefault("resolved", 0) * 100) / total);
        }
        
        // Add search parameters back to model
        model.addAttribute("search", search);
        model.addAttribute("sentiment", sentiment);
        model.addAttribute("status", status);
        
        return "feedbackAndAnalyticsModule/feedbackAnalytics";
    }
    
    // Show reply form (admin/faculty only)
    @GetMapping("/reply")
    public String showReplyForm(
            @RequestParam Integer id,
            Model model,
            HttpSession session) {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole) && !"faculty".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        Feedback feedback = feedbackAnalyticsService.getFeedbackById(id);
        
        if (feedback != null) {
            model.addAttribute("feedback", feedback);
            model.addAttribute("feedbackId", id);
            model.addAttribute("feedbackMessage", feedback.getMessage());
            model.addAttribute("userName", feedback.getName() != null ? feedback.getName() : 
                feedback.getUserFullName() != null ? feedback.getUserFullName() : "Anonymous User");
            
            return "feedbackAndAnalyticsModule/feedbackReply";
        } else {
            return "redirect:/feedback/analytics?error=Feedback+not+found";
        }
    }
    
    // Submit reply (admin/faculty only)
    @PostMapping("/reply")
    public String submitReply(
            @RequestParam Integer feedbackId,
            @RequestParam String replyMessage,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole) && !"faculty".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        // Get userId from session - handle both Integer and String types
        Integer userId = null;
        Object userIdObj = session.getAttribute("userId");
        
        if (userIdObj != null) {
            if (userIdObj instanceof Integer) {
                userId = (Integer) userIdObj;
            } else if (userIdObj instanceof String) {
                try {
                    userId = Integer.parseInt((String) userIdObj);
                } catch (NumberFormatException e) {
                    // Log error but continue
                    System.err.println("Warning: Could not parse userId from session: " + userIdObj);
                }
            }
        }
        
        if (replyMessage == null || replyMessage.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Reply message cannot be empty");
            return "redirect:/feedback/reply?id=" + feedbackId;
        }
        
        boolean success = feedbackAnalyticsService.sendReply(feedbackId, replyMessage.trim(), userId);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Reply sent successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to send reply");
        }
        
        return "redirect:/feedback/analytics";
    }
    
    // Mark feedback as resolved (admin/faculty only)
    @PostMapping("/resolve")
    public String resolveFeedback(
            @RequestParam Integer feedbackId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole) && !"faculty".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        // Get userId from session - handle both Integer and String types
        Integer userId = null;
        Object userIdObj = session.getAttribute("userId");
        
        if (userIdObj != null) {
            if (userIdObj instanceof Integer) {
                userId = (Integer) userIdObj;
            } else if (userIdObj instanceof String) {
                try {
                    userId = Integer.parseInt((String) userIdObj);
                } catch (NumberFormatException e) {
                    // Log error but continue
                    System.err.println("Warning: Could not parse userId from session: " + userIdObj);
                }
            }
        }
        
        boolean success = feedbackAnalyticsService.markAsResolved(feedbackId, userId);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Feedback marked as resolved!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to mark as resolved");
        }
        
        return "redirect:/feedback/analytics";
    }
    
    // Show reports (admin/faculty only) - HTML view
    @GetMapping("/report")
    public String showReport(
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer id,
            Model model,
            HttpSession session) {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole) && !"faculty".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        if (type == null) {
            type = "summary";
        }
        
        if ("history".equals(type) && id != null) {
            // Handle history report
            List<Map<String, Object>> history = feedbackAnalyticsService.getFeedbackHistory(id);
            model.addAttribute("history", history);
            model.addAttribute("feedbackId", id);
            model.addAttribute("reportType", "history");
            return "feedbackAndAnalyticsModule/feedbackHistory";
        } 
        else if ("detailed".equals(type)) {
            // Handle detailed report
            Map<String, Integer> stats = feedbackAnalyticsService.getFeedbackStats();
            List<Feedback> allFeedback = feedbackAnalyticsService.getAllFeedback();
            
            model.addAttribute("stats", stats);
            model.addAttribute("allFeedback", allFeedback);
            model.addAttribute("reportType", "detailed");
        }
        else {
            // Default to summary report
            Map<String, Integer> stats = feedbackAnalyticsService.getFeedbackStats();
            model.addAttribute("stats", stats);
            model.addAttribute("reportType", "summary");
        }
        
        return "feedbackAndAnalyticsModule/feedbackReport";
    }
    
    // Export CSV report
    @GetMapping("/export/csv")
    public void exportCSVReport(
            HttpServletResponse response,
            HttpSession session) throws IOException {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole) && !"faculty".equals(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        List<Feedback> allFeedback = feedbackAnalyticsService.getAllFeedback();
        
        // Set response headers for CSV download
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String filename = "feedback_report_" + timestamp + ".csv";
        
        response.setContentType("text/csv");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        
        // Write CSV content
        PrintWriter writer = response.getWriter();
        
        // CSV header
        writer.println("ID,User Name,User Email,Message,Category,Sentiment,Rating,Status,Date Created,Reply Date,Resolved");
        
        // CSV data
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (Feedback feedback : allFeedback) {
            writer.print(feedback.getId() + ",");
            writer.print(escapeCSV(feedback.getName()) + ",");
            writer.print(escapeCSV(feedback.getEmail()) + ",");
            writer.print(escapeCSV(feedback.getMessage()) + ",");
            writer.print(escapeCSV(feedback.getCategory()) + ",");
            writer.print(escapeCSV(feedback.getSentiment()) + ",");
            writer.print(feedback.getRating() != null ? feedback.getRating() : "" + ",");
            writer.print(feedback.isResolved() ? "Resolved" : "Pending" + ",");
            writer.print(feedback.getCreatedAt() != null ? dateFormat.format(feedback.getCreatedAt()) : "" + ",");
            writer.print(feedback.getReplyDate() != null ? dateFormat.format(feedback.getReplyDate()) : "" + ",");
            writer.print(feedback.isResolved() ? "Yes" : "No");
            writer.println();
        }
        
        writer.flush();
    }
    
    // Export PDF report (simple text-based for now, can be enhanced with PDF library)
    @GetMapping("/export/pdf")
    public void exportPDFReport(
            HttpServletResponse response,
            HttpSession session) throws IOException {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole) && !"faculty".equals(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        List<Feedback> allFeedback = feedbackAnalyticsService.getAllFeedback();
        Map<String, Integer> stats = feedbackAnalyticsService.getFeedbackStats();
        
        // Set response headers for PDF download
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String filename = "feedback_report_" + timestamp + ".pdf";
        
        response.setContentType("application/pdf");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        
        // Write simple PDF content (text-based)
        // Note: For real PDF generation, use a library like iText or Apache PDFBox
        PrintWriter writer = response.getWriter();
        
        // Simple PDF header
        writer.println("%PDF-1.4");
        writer.println("1 0 obj");
        writer.println("<< /Type /Catalog /Pages 2 0 R >>");
        writer.println("endobj");
        
        // Create content stream
        writer.println("2 0 obj");
        writer.println("<< /Type /Pages /Kids [3 0 R] /Count 1 >>");
        writer.println("endobj");
        
        writer.println("3 0 obj");
        writer.println("<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R >>");
        writer.println("endobj");
        
        writer.println("4 0 obj");
        writer.println("<< /Length 1000 >>");
        writer.println("stream");
        
        // Add report content
        writer.println("BT");
        writer.println("/F1 12 Tf");
        writer.println("50 750 Td");
        writer.println("(SmileSpace Feedback Report) Tj");
        writer.println("ET");
        
        writer.println("BT");
        writer.println("/F1 10 Tf");
        writer.println("50 720 Td");
        writer.println("(Generated: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + ") Tj");
        writer.println("ET");
        
        writer.println("BT");
        writer.println("/F1 10 Tf");
        writer.println("50 690 Td");
        writer.println("(Total Feedback: " + stats.getOrDefault("total", 0) + ") Tj");
        writer.println("ET");
        
        writer.println("BT");
        writer.println("/F1 10 Tf");
        writer.println("50 660 Td");
        writer.println("(Positive: " + stats.getOrDefault("positive", 0) + ", Neutral: " + 
                      stats.getOrDefault("neutral", 0) + ", Negative: " + stats.getOrDefault("negative", 0) + ") Tj");
        writer.println("ET");
        
        writer.println("BT");
        writer.println("/F1 10 Tf");
        writer.println("50 630 Td");
        writer.println("(Resolved: " + stats.getOrDefault("resolved", 0) + ") Tj");
        writer.println("ET");
        
        // Add feedback list
        int yPos = 600;
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        for (int i = 0; i < Math.min(allFeedback.size(), 20); i++) {
            Feedback feedback = allFeedback.get(i);
            writer.println("BT");
            writer.println("/F1 8 Tf");
            writer.println("50 " + yPos + " Td");
            writer.println("(" + (i + 1) + ". ID: " + feedback.getId() + " - " + 
                          (feedback.getName() != null ? feedback.getName() : "Anonymous") + 
                          " [" + feedback.getSentiment() + "] - " + 
                          (feedback.getCreatedAt() != null ? dateFormat.format(feedback.getCreatedAt()) : "") + 
                          ") Tj");
            writer.println("ET");
            yPos -= 15;
        }
        
        writer.println("endstream");
        writer.println("endobj");
        
        writer.println("trailer");
        writer.println("<< /Root 1 0 R >>");
        writer.println("%%EOF");
        
        writer.flush();
    }
    
    // Helper method to escape CSV special characters
    private String escapeCSV(String value) {
        if (value == null) {
            return "";
        }
        String escaped = value.replace("\"", "\"\"");
        if (escaped.contains(",") || escaped.contains("\"") || escaped.contains("\n") || escaped.contains("\r")) {
            return "\"" + escaped + "\"";
        }
        return escaped;
    }
}