package smilespace.controller.completeQuiz;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Autowired;
import jakarta.servlet.http.HttpSession;

@Controller
public class StudentModuleController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/student-module")
    public String showModule(@RequestParam(value = "id", required = false) String moduleId,
                            @RequestParam(value = "action", required = false) String action,
                            Model model,
                            HttpSession session) {
        
        System.out.println("StudentModuleController: moduleId=" + moduleId + ", action=" + action);
        
        if (moduleId == null) {
            return "redirect:/quiz-dashboard";
        }
        
        try {
            LearningModule module = moduleService.getModuleById(moduleId);
            
            if (module == null) {
                System.out.println("Module not found in DB for ID: " + moduleId);
                return "redirect:/quiz-dashboard";
            }
            
            System.out.println("Found module: " + module.getTitle());
            System.out.println("Video URL: " + module.getVideoUrl());
            System.out.println("Content Outline: " + module.getContentOutline());
            System.out.println("Learning Guide: " + module.getLearningGuide());
            
            moduleService.incrementModuleViews(moduleId);
            
            if ("content".equals(action)) {
                String videoUrl = module.getVideoUrl();
                model.addAttribute("videoUrl", videoUrl);
                model.addAttribute("module", module);
                
                session.setAttribute("currentModule", module);
                
                return "completeQuiz/module-content";
            } else {
                model.addAttribute("module", module);
                model.addAttribute("contentOutline", module.getContentOutlineArray());
                model.addAttribute("learningGuide", module.getLearningGuideArray());
                model.addAttribute("keyPoints", module.getKeyPointsArray());
                
                return "completeQuiz/quiz-intro";
            }
            
        } catch (Exception e) {
            System.err.println("ERROR in StudentModuleController: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/quiz-dashboard";
        }
    }
}