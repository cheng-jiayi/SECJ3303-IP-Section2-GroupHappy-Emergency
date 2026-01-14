package smilespace.controller;

import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

import smilespace.model.LearningModule;
import smilespace.dao.LearningModuleDAO;

import jakarta.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/ai")
public class ChatPageController {
    
    @Autowired
    private LearningModuleDAO learningModuleDAO;
    
    @Autowired
    private HttpSession httpSession;
    
    // ====================
    // 1. LEARNING HUB PAGE
    // ====================
    @GetMapping("/learn")
    public String learningHub(
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "level", required = false) String level,
            @RequestParam(name = "search", required = false) String search,
            Model model) {
        
        try {
            // Fetch modules from database with filters
            List<LearningModule> modules;
            
            if (search != null && !search.trim().isEmpty() || 
                (category != null && !"all".equals(category)) || 
                (level != null && !"all".equals(level))) {
                // Filtered search
                modules = learningModuleDAO.search(search, category, level);
            } else {
                // All modules
                modules = learningModuleDAO.findAll();
            }
            
            // Get statistics for sidebar
            Map<String, Object> stats = learningModuleDAO.getModuleStatistics();
            
            // Prepare categories for filter dropdown
            List<String> categories = new ArrayList<>();
            categories.add("Stress");
            categories.add("Anxiety");
            categories.add("Mindfulness");
            categories.add("Self-Esteem");
            categories.add("Sleep");
            
            // Prepare levels for filter dropdown
            List<String> levels = new ArrayList<>();
            levels.add("Beginner");
            levels.add("Intermediate");
            levels.add("Advanced");
            levels.add("All Levels");
            
            // Add to model
            model.addAttribute("modules", modules);
            model.addAttribute("stats", stats);
            model.addAttribute("categories", categories);
            model.addAttribute("levels", levels);
            model.addAttribute("selectedCategory", category);
            model.addAttribute("selectedLevel", level);
            model.addAttribute("searchTerm", search);
            
            // Get user info from session
            String userFullName = (String) httpSession.getAttribute("userFullName");
            if (userFullName == null) {
                userFullName = "Guest Student";
            }
            model.addAttribute("userFullName", userFullName);
            
            System.out.println("Loaded " + modules.size() + " modules for learning hub");
            
        } catch (Exception e) {
            System.err.println("Error loading learning hub: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("modules", new ArrayList<LearningModule>());
            model.addAttribute("error", "Unable to load learning modules. Please try again later.");
        }
        
        return "AIAssistant/Learn/AILearningHub";
    }
    
    // ========================
    // 2. MODULE DETAILS PAGE
    // ========================
    @GetMapping("/learn/{moduleId}")
    public String moduleDetails(
            @PathVariable("moduleId") String moduleId,
            @RequestParam(name = "action", required = false) String action,
            Model model) {
        
        try {
            // Increment views when viewing module
            learningModuleDAO.incrementViews(moduleId);
            
            // Fetch module from database
            LearningModule module = learningModuleDAO.findById(moduleId);
            
            if (module == null) {
                model.addAttribute("error", "Module not found!");
                return "redirect:/ai/learn";
            }
            
            // Record access if user is logged in
            Integer userId = (Integer) httpSession.getAttribute("userId");
            if (userId != null) {
                learningModuleDAO.recordAccess(moduleId, userId, "view");
            }
            
            // Parse content arrays
            String[] outlineArray = module.getContentOutlineArray();
            String[] guideArray = module.getLearningGuideArray();
            String[] keyPointsArray = module.getKeyPointsArray();
            
            // Get access history (for admin view)
            List<Map<String, Object>> accessHistory = learningModuleDAO.getAccessHistory(moduleId);
            
            // Add to model
            model.addAttribute("module", module);
            model.addAttribute("outlineArray", outlineArray);
            model.addAttribute("guideArray", guideArray);
            model.addAttribute("keyPointsArray", keyPointsArray);
            model.addAttribute("accessHistory", accessHistory);
            
            // Get user info
            String userFullName = (String) httpSession.getAttribute("userFullName");
            if (userFullName == null) {
                userFullName = "Guest Student";
            }
            model.addAttribute("userFullName", userFullName);
            
            System.out.println("Loaded module: " + module.getTitle());
            
        } catch (Exception e) {
            System.err.println("Error loading module details: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Unable to load module. Please try again later.");
            return "redirect:/ai/learn";
        }
        
        return "AIAssistant/Learn/module-details";
    }
    
    // ==========================
    // 3. INTERACTIVE LEARNING MODE
    // ==========================
    @GetMapping("/learn/{moduleId}/interactive")
    public String interactiveLearning(
            @PathVariable("moduleId") String moduleId,
            @RequestParam(name = "topic", defaultValue = "1") String topicParam,
            @RequestParam(name = "complete", defaultValue = "false") String complete,
            Model model) {
        
        try {
            // Fetch module from database
            LearningModule module = learningModuleDAO.findById(moduleId);
            
            if (module == null) {
                model.addAttribute("error", "Module not found!");
                return "redirect:/ai/learn";
            }
            
            // Record access for interactive learning
            Integer userId = (Integer) httpSession.getAttribute("userId");
            if (userId != null) {
                learningModuleDAO.recordAccess(moduleId, userId, "interactive_learning");
            }
            
            // Parse topic number
            int currentTopic = 1;
            boolean isComplete = "true".equals(complete);
            
            if (!isComplete) {
                try {
                    currentTopic = Integer.parseInt(topicParam);
                    // Validate topic number (1-3 for basic modules)
                    if (currentTopic < 1) currentTopic = 1;
                    if (currentTopic > 3) {
                        currentTopic = 3;
                        isComplete = true;
                    }
                } catch (NumberFormatException e) {
                    currentTopic = 1;
                }
            }
            
            // Get topic-specific content based on module category
            Map<String, Object> topicData = getTopicContent(module.getCategory(), currentTopic);
            
            // Calculate progress
            int widthPercent = 0;
            if (!isComplete) {
                widthPercent = (currentTopic * 100) / 3; // Assuming 3 topics per module
            } else {
                widthPercent = 100;
            }
            
            // Add to model
            model.addAttribute("module", module);
            model.addAttribute("currentTopic", currentTopic);
            model.addAttribute("isComplete", isComplete);
            model.addAttribute("topicTitle", topicData.get("title"));
            model.addAttribute("aiMessage", topicData.get("aiMessage"));
            model.addAttribute("mainContent", topicData.get("mainContent"));
            model.addAttribute("exampleContent", topicData.get("exampleContent"));
            model.addAttribute("progress", widthPercent);
            model.addAttribute("topicData", topicData);
            
            // Get user info
            String userFullName = (String) httpSession.getAttribute("userFullName");
            if (userFullName == null) {
                userFullName = "Guest Student";
            }
            model.addAttribute("userFullName", userFullName);
            
            System.out.println("Interactive learning for module: " + module.getTitle() + ", topic: " + currentTopic);
            
        } catch (Exception e) {
            System.err.println("Error in interactive learning: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Unable to start interactive learning. Please try again later.");
            return "redirect:/ai/learn";
        }
        
        return "AIAssistant/Learn/learn-module";
    }
    
    // ==========================
    // 4. START LEARNING SESSION
    // ==========================
    @PostMapping("/learn/{moduleId}/start")
    public String startLearningSession(
            @PathVariable("moduleId") String moduleId,
            @RequestParam(name = "mode", defaultValue = "interactive") String mode) {
        
        if ("interactive".equals(mode)) {
            return "redirect:/ai/learn/" + moduleId + "/interactive?topic=1";
        } else {
            return "redirect:/ai/learn/" + moduleId;
        }
    }
    
    // ==========================
    // 5. NEXT TOPIC
    // ==========================
    @GetMapping("/learn/{moduleId}/next")
    public String nextTopic(
            @PathVariable("moduleId") String moduleId,
            @RequestParam(name = "currentTopic") int currentTopic) {
        
        if (currentTopic < 3) {
            return "redirect:/ai/learn/" + moduleId + "/interactive?topic=" + (currentTopic + 1);
        } else {
            return "redirect:/ai/learn/" + moduleId + "/interactive?complete=true";
        }
    }
    
    // ==========================
    // 6. COMPLETE MODULE
    // ==========================
    @PostMapping("/learn/{moduleId}/complete")
    @ResponseBody
    public Map<String, Object> completeModule(
            @PathVariable("moduleId") String moduleId) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Record completion
            Integer userId = (Integer) httpSession.getAttribute("userId");
            if (userId != null) {
                learningModuleDAO.recordAccess(moduleId, userId, "completed");
            }
            
            response.put("success", true);
            response.put("message", "Module completed successfully!");
            response.put("redirect", "/ai/learn/" + moduleId + "/interactive?complete=true");
            
        } catch (Exception e) {
            System.err.println("Error completing module: " + e.getMessage());
            response.put("success", false);
            response.put("message", "Error completing module");
        }
        
        return response;
    }
    
    // ==========================
    // 7. AI CHAT HUB (for comparison)
    // ==========================
    @GetMapping("/chat")
    public String aiConservation() {
        return "AIAssistant/Chat/AIConservationHub";
    }
    
    // ==========================
    // HELPER METHODS
    // ==========================
    
    private Map<String, Object> getTopicContent(String category, int topicNumber) {
        Map<String, Object> topicData = new HashMap<>();
        
        // Default topic data (can be extended based on category)
        switch (topicNumber) {
            case 1:
                topicData.put("title", "Understanding " + category);
                topicData.put("aiMessage", "Let's start learning about " + category + ". Understanding the basics is the first step toward improvement.");
                topicData.put("mainContent", "This module will help you understand the fundamentals of " + category.toLowerCase() + ". Knowledge is power when it comes to mental wellness.");
                topicData.put("exampleContent", "For example, many people experience " + category.toLowerCase() + " without recognizing the symptoms. Awareness is the first step to management.");
                topicData.put("responses", Map.of(
                    "what is " + category.toLowerCase(), "This is a comprehensive introduction to " + category.toLowerCase() + " and its effects on mental health.",
                    "symptoms", "Common symptoms include both physical and emotional changes that affect daily functioning.",
                    "causes", "Various factors can contribute, including biological, psychological, and environmental elements."
                ));
                topicData.put("tip", "Start by observing your own experiences without judgment.");
                topicData.put("explainMore", "This topic covers the foundational knowledge needed to understand " + category.toLowerCase() + " and its impact.");
                topicData.put("showExample", "Real-world examples will help you recognize patterns in your own experience.");
                break;
                
            case 2:
                topicData.put("title", "Coping with " + category);
                topicData.put("aiMessage", "Now let's explore practical strategies for managing " + category.toLowerCase() + ".");
                topicData.put("mainContent", "Effective coping strategies can significantly improve your ability to manage " + category.toLowerCase() + ". Practice makes progress.");
                topicData.put("exampleContent", "Try implementing one new strategy this week and observe its effects.");
                topicData.put("responses", Map.of(
                    "strategies", "There are multiple evidence-based strategies for managing " + category.toLowerCase() + ".",
                    "techniques", "Different techniques work for different people - it's about finding what works for you.",
                    "practice", "Consistent practice is key to making these strategies effective."
                ));
                topicData.put("tip", "Small, consistent efforts are more effective than occasional intense efforts.");
                topicData.put("explainMore", "This section covers practical techniques and approaches for managing " + category.toLowerCase() + ".");
                topicData.put("showExample", "Case studies show how others have successfully implemented these strategies.");
                break;
                
            case 3:
                topicData.put("title", "Advanced " + category + " Management");
                topicData.put("aiMessage", "Let's discuss long-term strategies for sustainable " + category.toLowerCase() + " management.");
                topicData.put("mainContent", "Building lasting habits and resilience is crucial for long-term success in managing " + category.toLowerCase() + ".");
                topicData.put("exampleContent", "Creating a personalized wellness plan can help maintain progress over time.");
                topicData.put("responses", Map.of(
                    "long term", "Sustainable management requires ongoing attention and adaptation.",
                    "habits", "Building positive habits creates a foundation for lasting change.",
                    "maintenance", "Regular check-ins and adjustments help maintain progress."
                ));
                topicData.put("tip", "Review and adjust your approach regularly based on what's working.");
                topicData.put("explainMore", "This final section focuses on creating sustainable systems for ongoing management.");
                topicData.put("showExample", "Success stories demonstrate how consistent practice leads to lasting improvement.");
                break;
                
            default:
                topicData.put("title", "Module Complete");
                topicData.put("aiMessage", "Congratulations on completing this module!");
                topicData.put("mainContent", "You've taken important steps toward better understanding and managing " + category.toLowerCase() + ".");
                topicData.put("exampleContent", "Continue practicing what you've learned and consider exploring related modules.");
                break;
        }
        
        return topicData;
    }
}