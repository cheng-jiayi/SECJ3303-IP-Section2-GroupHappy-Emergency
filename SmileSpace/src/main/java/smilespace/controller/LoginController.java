package smilespace.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import smilespace.model.User;
import smilespace.service.UserService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/login")
public class LoginController {
    
    @Autowired
    private UserService userService;
    
    public LoginController() {
        System.out.println("=== DEBUG: LoginController instantiated ===");
    }
    
    @GetMapping
    public String showLoginPage(HttpServletResponse response) {
        System.out.println("=== DEBUG: GET /login ===");
        
        // Prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        return "userManagementModule/loginPage";
    }
    
    @PostMapping
    public String processLogin(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session,
            Model model,
            HttpServletResponse response) {
        
        System.out.println("=== DEBUG: POST /login - Username: " + username + " ===");
        
        try {
            // Prevent caching
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            
            // Validate
            if (username == null || username.trim().isEmpty()) {
                model.addAttribute("error", "Username is required");
                return "userManagementModule/loginPage";
            }
            
            if (password == null || password.trim().isEmpty()) {
                model.addAttribute("error", "Password is required");
                model.addAttribute("username", username); // Keep username
                return "userManagementModule/loginPage";
            }
            
            // Authenticate
            User user = userService.authenticateUser(username, password);
            
            if (user != null && user.isActive()) {
                // Set session attributes
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("userFullName", user.getFullName());
                session.setAttribute("userRole", user.getUserRole());
                session.setAttribute("userEmail", user.getEmail());
                
                System.out.println("=== DEBUG: Login SUCCESS - Role: " + user.getUserRole() + " ===");
                
                // Redirect to appropriate dashboard
                return "redirect:/dashboard";
                
            } else {
                model.addAttribute("error", "Invalid username or password");
                model.addAttribute("username", username); // Keep username
                System.out.println("=== DEBUG: Login FAILED ===");
                return "userManagementModule/loginPage";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "System error: " + e.getMessage());
            model.addAttribute("username", username); // Keep username
            return "userManagementModule/loginPage";
        }
    }
}