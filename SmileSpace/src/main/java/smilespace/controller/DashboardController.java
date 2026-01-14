package smilespace.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {
    
    @GetMapping
    public String showDashboard(HttpSession session) {
        
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        
        String userRole = (String) session.getAttribute("userRole");
        if (userRole == null) {
            return "redirect:/login";
        }
        
        // Return VIEW names, not redirects to JSPs
        switch (userRole.toLowerCase()) {
            case "student":
                return "userManagementModule/dashboards/studentDashboard";
            case "faculty":
                return "userManagementModule/dashboards/facultyDashboard";
            case "professional":
                return "userManagementModule/dashboards/professionalDashboard";
            case "admin":
                return "userManagementModule/dashboards/adminDashboard";
            default:
                return "redirect:/login";
        }
    }
}