package smilespace.controller.completeQuiz;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;

@Controller
public class StudentLearningModuleController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/student-learning-modules")
    public String showAllModules(Model model) {
        
        System.out.println("=== StudentLearningModuleController START ===");
        
        List<LearningModule> allModules = moduleService.getAllModules();
        
        if (allModules == null) {
            System.out.println("ERROR: moduleService.getAllModules() returned null!");
            allModules = new java.util.ArrayList<>();
        }
        
        System.out.println("Total modules retrieved: " + allModules.size());
        
        model.addAttribute("allModules", allModules);
        
        System.out.println("=== StudentLearningModuleController END ===");
        
        return "completeQuiz/student-module";
    }
}