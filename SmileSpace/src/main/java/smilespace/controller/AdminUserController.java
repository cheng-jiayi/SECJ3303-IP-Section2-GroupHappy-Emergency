package smilespace.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import smilespace.model.User;
import smilespace.service.UserService;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminUserController {

    @Autowired
    private UserService userService;

    // Render the manage users page
    @GetMapping("/manageUsers")
    public String manageUsers(@RequestParam(value = "filter", required = false, defaultValue = "student") String filter,
                              Model model) {

        List<User> users;

        switch (filter.toLowerCase()) {
            case "faculty":
                users = userService.getAllFaculty();
                break;
            case "professional":
                users = userService.getAllProfessionals();
                break;
            case "admin":
                users = userService.getAllAdmins();
                break;
            default:
                users = userService.getAllStudents();
        }

        model.addAttribute("users", users);
        model.addAttribute("filter", filter);
        return "/userManagementModule/manageUsers"; // JSP path
    }

    // Delete a user via AJAX
    @PostMapping("/deleteUser")
    @ResponseBody
    public ResponseEntity<String> deleteUser(@RequestParam("userId") int userId) {
        try {
            boolean deleted = userService.deleteUser(userId);
            if (deleted) return ResponseEntity.ok("success");
            else return ResponseEntity.ok("fail");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("error");
        }
    }
}