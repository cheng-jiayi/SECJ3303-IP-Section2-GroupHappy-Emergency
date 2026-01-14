package smilespace.controller;

import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import smilespace.dao.UserDAO;
import smilespace.model.User;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    @Autowired
    private UserDAO userDAO;

    /* ================= VIEW PROFILE ================= */
    @GetMapping
    public String viewProfile(HttpSession session, Model model) {

        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole");

        if (userId == null) {
            return "redirect:/login";
        }

        User user = userDAO.getUserById(userId);
        model.addAttribute("user", user);
        model.addAttribute("userRole", role);

        return "/userManagementModule/profile"; // profile.jsp
    }

    /* ================= UPDATE PROFILE ================= */
    @PostMapping("/update")
    public String updateProfile(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam(required = false) String matricNumber,
            @RequestParam(required = false) String faculty,
            @RequestParam(required = false) Integer year,
            HttpSession session
    ) {

        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole");

        if (userId == null) {
            return "redirect:/login";
        }

        User user = userDAO.getUserById(userId);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);

        // Only students can update these
        if ("student".equals(role)) {
            user.setMatricNumber(matricNumber);
            user.setFaculty(faculty);
            user.setYear(year);
        }

        userDAO.updateUser(user);

        // Update session values
        session.setAttribute("userFullName", fullName);
        session.setAttribute("email", email);
        session.setAttribute("phone", phone);

        return "redirect:/profile";
    }

    /* ================= CHANGE PASSWORD ================= */
    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam String newPassword,
            HttpSession session
    ) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        // Hash the password using BCrypt
        String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());

        // Update in DB
        userDAO.updatePassword(userId, hashed);

        // Optionally, set a session attribute or flash message
        session.setAttribute("message", "Password updated successfully!");

        return "redirect:/profile";
    }
}
