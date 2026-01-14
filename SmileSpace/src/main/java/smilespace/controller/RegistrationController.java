package smilespace.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import smilespace.model.User;
import smilespace.service.UserService;

@Controller
@RequestMapping("/register")
public class RegistrationController {

    @Autowired
    private UserService userService;

    // Show registration page
    @GetMapping
    public String showRegistrationForm() {
        return "/userManagementModule/registrationPage"; // maps to registrationPage.jsp
    }

    // Handle form submission
    @PostMapping
    public String registerUser(
            @RequestParam("username") String username,
            @RequestParam("phone") String phone,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam("confirm") String confirm,
            Model model
    ) {

        StringBuilder error = new StringBuilder();

        // ===== Validation =====
        if (username == null || !username.matches("^[a-zA-Z0-9]{3,20}$")) {
            error.append("Username must be 3-20 alphanumeric characters. ");
        }

        if (phone == null || !phone.matches("^[0-9]{10,15}$")) {
            error.append("Phone must be 10-15 digits. ");
        }

        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            error.append("Invalid email format. ");
        }

        if (password == null || password.length() < 8) {
            error.append("Password must be at least 8 characters. ");
        }

        if (!password.equals(confirm)) {
            error.append("Passwords do not match. ");
        }

        // ===== Check username/email =====
        if (userService.checkUsernameExists(username)) {
            error.append("Username already exists. ");
        }

        if (userService.checkEmailExists(email)) {
            error.append("Email already registered. ");
        }

        if (error.length() > 0) {
            model.addAttribute("error", error.toString());
            return "/userManagementModule/registrationPage";
        }

        // ===== Create User =====
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(password); // will be hashed in UserService
        user.setFullName(username);      // default
        user.setUserRole("student");     // default role
        user.setPhone(phone);
        user.setActive(true);

        boolean success = userService.createUser(user);

        if (success) {
            model.addAttribute("success", "Registration successful! Please login.");
            return "/userManagementModule/loginPage";
        } else {
            model.addAttribute("error", "Registration failed. Please try again.");
            return "/userManagementModule/registrationPage";
        }
    }
}
