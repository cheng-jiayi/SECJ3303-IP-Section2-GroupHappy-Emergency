package smilespace.controller.ManageLearningModule;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class ModuleDashboardController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/admin-module-dashboard")
    public String showDashboard(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "level", required = false) String level,
            Model model,
            HttpServletRequest request,
            HttpSession session) {
        
        // Get user role and ID from session
        String userRole = (String) session.getAttribute("userRole");
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Get module list
        List<LearningModule> filteredModules;
        if ((search != null && !search.trim().isEmpty()) || 
            (category != null && !"all".equals(category)) || 
            (level != null && !"all".equals(level))) {
            filteredModules = moduleService.searchModules(search, category, level);
        } else {
            filteredModules = moduleService.getAllModules();
        }
        
        // Get statistics (only visible to admin and faculty)
        if ("admin".equals(userRole) || "faculty".equals(userRole)) {
            Map<String, Object> statistics = moduleService.getModuleStatistics();
            model.addAttribute("statistics", statistics);
        }
        
        model.addAttribute("modules", filteredModules);
        model.addAttribute("searchTerm", search != null ? search : "");
        model.addAttribute("selectedCategory", category != null ? category : "all");
        model.addAttribute("selectedLevel", level != null ? level : "all");
        model.addAttribute("userRole", userRole);
        
        return "manageLearningModule/dashboard";
    }
}