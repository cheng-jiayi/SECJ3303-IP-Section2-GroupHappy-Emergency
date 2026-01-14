package smilespace.controller.ManageLearningModule;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class ViewModuleController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/view-module")
    public String viewModule(@RequestParam("id") String id, Model model, HttpSession session) {
        
        if (id == null || id.isEmpty()) {
            return "redirect:/dashboard";
        }
        
        LearningModule module = moduleService.getModuleById(id);
        
        if (module == null) {
            return "redirect:/dashboard";
        }
        
        // Get user info from session
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        
        // Record access history (if user is logged in)
        if (userId != null) {
            moduleService.recordModuleAccess(id, userId, "view");
        }
        
        // Get access history (only visible to admin, faculty, professional)
        if (userId != null && ("admin".equals(userRole) || "faculty".equals(userRole) || "professional".equals(userRole))) {
            List<Map<String, Object>> accessHistory = moduleService.getAccessHistory(id);
            model.addAttribute("accessHistory", accessHistory);
        }
        
        model.addAttribute("module", module);
        model.addAttribute("userRole", userRole);
        return "manageLearningModule/view-module";
    }
}