package smilespace.controller.ManageLearningModule;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;

@Controller
public class CreateModuleController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    private static final String UPLOAD_DIR = "uploads";
    
    @GetMapping("/create-module")
    public String showCreateForm(Model model, HttpServletRequest request) {
        // Check authorization via interceptor
        return "manageLearningModule/create-module";
    }
    
    @PostMapping("/create-module")
    public String createModule(
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("category") String category,
            @RequestParam("level") String level,
            @RequestParam("authorName") String authorName,
            @RequestParam("estimatedDuration") String estimatedDuration,
            @RequestParam(value = "videoUrl", required = false) String videoUrl,
            @RequestParam(value = "contentOutline", required = false) String contentOutline,
            @RequestParam(value = "learningGuide", required = false) String learningGuide,
            @RequestParam(value = "learningTip", required = false) String learningTip,
            @RequestParam(value = "keyPoints", required = false) String keyPoints,
            @RequestParam(value = "notes", required = false) String notes,
            @RequestParam(value = "coverImage", required = false) MultipartFile coverImage,
            @RequestParam(value = "resourceFile", required = false) MultipartFile resourceFile,
            HttpSession session,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        
        try {
            System.out.println("=== Creating Module ===");
            System.out.println("Title: " + title);
            System.out.println("Category: " + category);
            System.out.println("Level: " + level);
            System.out.println("Video URL: " + videoUrl);
            System.out.println("Content Outline: " + contentOutline);
            System.out.println("Learning Guide: " + learningGuide);
            System.out.println("Learning Tip: " + learningTip);
            System.out.println("Key Points: " + keyPoints);
            
            // Get user ID from session
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("error", "Please login first");
                return "redirect:/modules/userManagementModule/loginPage.jsp";
            }
            
            // Create module object
            LearningModule module = new LearningModule();
            module.setTitle(title);
            module.setDescription(description);
            module.setCategory(category);
            
            // Handle learning level
            if ("Advanced".equals(level)) {
                module.setLevel("Advance");
            } else {
                module.setLevel(level);
            }
            
            module.setAuthorName(authorName);
            module.setEstimatedDuration(estimatedDuration);
            module.setVideoUrl(videoUrl != null ? videoUrl : "");
            module.setContentOutline(contentOutline != null ? contentOutline : "");
            module.setLearningGuide(learningGuide != null ? learningGuide : "");
            module.setLearningTip(learningTip != null ? learningTip : "");
            module.setKeyPoints(keyPoints != null ? keyPoints : "");
            module.setNotes(notes != null ? notes : "");
            module.setViews(0);
            
            // Set current date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            module.setLastUpdated(sdf.format(new Date()));
            
            // Handle file uploads
            if (coverImage != null && !coverImage.isEmpty()) {
                String coverImagePath = saveUploadedFile(coverImage, request);
                module.setCoverImage(coverImagePath);
            }
            
            if (resourceFile != null && !resourceFile.isEmpty()) {
                String resourceFilePath = saveUploadedFile(resourceFile, request);
                module.setResourceFile(resourceFilePath);
            }
            
            System.out.println("Module created with ID: " + module.getId());
            
            // Create module
            boolean success = moduleService.createModule(module, userId);
            
            if (success) {
                // Record creation history
                moduleService.recordModuleAccess(module.getId(), userId, "create");
                redirectAttributes.addFlashAttribute("success", "Module created successfully");
                return "redirect:/dashboard";
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to create module");
                return "redirect:/create-module";
            }
            
        } catch (Exception e) {
            System.err.println("Error creating module: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error creating module: " + e.getMessage());
            return "redirect:/create-module";
        }
    }
    
    private String saveUploadedFile(MultipartFile file, HttpServletRequest request) throws IOException {
        if (file == null || file.isEmpty()) {
            return "";
        }
        
        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        fileName = new File(fileName).getName(); // Clean filename
        
        // Get upload directory
        String uploadDir = request.getServletContext().getRealPath("/" + UPLOAD_DIR);
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        
        // Save file
        Path filePath = Paths.get(uploadDir, fileName);
        Files.copy(file.getInputStream(), filePath);
        
        // Return relative path
        return UPLOAD_DIR + "/" + fileName;
    }
}