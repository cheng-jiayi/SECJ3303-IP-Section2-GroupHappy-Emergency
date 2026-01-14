package smilespace.controller.completeQuiz;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;

@Controller
public class QuizDashboardController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/quiz-dashboard")
    public String showDashboard(@RequestParam(value = "category", required = false) String category,
                               Model model) {
        
        System.out.println("=== QuizDashboardController START ===");
        System.out.println("Requested category: " + category);
        
        List<LearningModule> modules;
        String pageTitle;
        
        if (category == null || category.isEmpty()) {
            modules = moduleService.getAllModules();
            pageTitle = "All Learning Modules";
            System.out.println("No category specified, showing ALL modules");
        } else {
            modules = moduleService.getModulesByCategory(category);
            pageTitle = category + " Management Modules";
            System.out.println("Showing modules for category: " + category);
        }
        
        System.out.println("Modules found: " + modules.size());
        
        for (LearningModule module : modules) {
            System.out.println("Module: " + module.getId() + " - " + 
                             module.getTitle() + " | Category: " + module.getCategory());
        }
        
        model.addAttribute("stressModules", modules);
        model.addAttribute("pageTitle", pageTitle);
        model.addAttribute("selectedCategory", category != null ? category : "all");
        
        System.out.println("=== QuizDashboardController END ===");
        
        return "completeQuiz/quiz-dashboard";
    }
}