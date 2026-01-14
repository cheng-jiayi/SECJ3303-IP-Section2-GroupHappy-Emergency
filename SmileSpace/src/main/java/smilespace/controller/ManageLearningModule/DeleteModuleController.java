package smilespace.controller.ManageLearningModule;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;

@Controller
public class DeleteModuleController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/delete-module")
    public String showDeleteConfirmation(@RequestParam("id") String id, Model model) {
        
        if (id == null || id.isEmpty()) {
            return "redirect:/dashboard";
        }
        
        LearningModule module = moduleService.getModuleById(id);
        
        if (module == null) {
            return "redirect:/dashboard";
        }
        
        model.addAttribute("module", module);
        return "manageLearningModule/delete-module";
    }
    
    @PostMapping("/delete-module")
    public String deleteModule(@RequestParam("id") String id, RedirectAttributes redirectAttributes) {
        
        if (id == null || id.isEmpty()) {
            return "redirect:/dashboard";
        }
        
        boolean success = moduleService.deleteModule(id);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Module deleted successfully");
            return "redirect:/dashboard";
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to delete module");
            return "redirect:/delete-module?id=" + id;
        }
    }
}