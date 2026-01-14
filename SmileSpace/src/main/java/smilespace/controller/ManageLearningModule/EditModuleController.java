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
public class EditModuleController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    private static final String UPLOAD_DIR = "uploads";
    
    @GetMapping("/edit-module")
    public String showEditForm(@RequestParam("id") String id, Model model) {
        System.out.println("=== EditModuleController called ===");
        
        if (id == null || id.isEmpty()) {
            System.out.println("ERROR: ID is null or empty!");
            return "redirect:/dashboard";
        }
        
        LearningModule module = moduleService.getModuleById(id);
        
        if (module == null) {
            System.out.println("ERROR: Module with ID " + id + " not found!");
            return "redirect:/dashboard";
        }
        
        // Debug module data
        System.out.println("Module details:");
        System.out.println("  ID: " + module.getId());
        System.out.println("  Title: " + module.getTitle());
        System.out.println("  Category: " + module.getCategory());
        System.out.println("  Level: " + module.getLevel());
        System.out.println("  Video URL: " + module.getVideoUrl());
        System.out.println("  Content Outline: " + module.getContentOutline());
        System.out.println("  Learning Guide: " + module.getLearningGuide());
        System.out.println("  Learning Tip: " + module.getLearningTip());
        System.out.println("  Key Points: " + module.getKeyPoints());
        
        model.addAttribute("module", module);
        return "manageLearningModule/edit-module";
    }
    
    @PostMapping("/edit-module")
    public String updateModule(
            @RequestParam("id") String id,
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
        
        System.out.println("=== Processing Edit Module ===");
        
        try {
            System.out.println("ID: " + id);
            System.out.println("Title: " + title);
            System.out.println("Video URL: " + videoUrl);
            System.out.println("Content Outline: " + contentOutline);
            System.out.println("Learning Guide: " + learningGuide);
            System.out.println("Learning Tip: " + learningTip);
            System.out.println("Key Points: " + keyPoints);
            
            if (id == null || id.isEmpty()) {
                System.out.println("ERROR: ID is null or empty!");
                return "redirect:/dashboard";
            }
            
            // Get existing module
            LearningModule existingModule = moduleService.getModuleById(id);
            if (existingModule == null) {
                System.out.println("ERROR: Module with ID " + id + " not found!");
                return "redirect:/dashboard";
            }
            
            System.out.println("Found existing module: " + existingModule.getId() + " - " + existingModule.getTitle());
            
            // Update module information
            existingModule.setTitle(title != null ? title : existingModule.getTitle());
            existingModule.setDescription(description != null ? description : existingModule.getDescription());
            existingModule.setCategory(category != null ? category : existingModule.getCategory());
            
            // Handle learning level
            if (level != null) {
                if ("Advanced".equals(level)) {
                    existingModule.setLevel("Advance");
                } else {
                    existingModule.setLevel(level);
                }
            }
            
            existingModule.setAuthorName(authorName != null ? authorName : existingModule.getAuthorName());
            existingModule.setEstimatedDuration(estimatedDuration != null ? estimatedDuration : existingModule.getEstimatedDuration());
            existingModule.setVideoUrl(videoUrl != null ? videoUrl : existingModule.getVideoUrl());
            existingModule.setContentOutline(contentOutline != null ? contentOutline : existingModule.getContentOutline());
            existingModule.setLearningGuide(learningGuide != null ? learningGuide : existingModule.getLearningGuide());
            existingModule.setLearningTip(learningTip != null ? learningTip : existingModule.getLearningTip());
            existingModule.setKeyPoints(keyPoints != null ? keyPoints : existingModule.getKeyPoints());
            existingModule.setNotes(notes != null ? notes : existingModule.getNotes());
            
            // Get upload directory
            String uploadDir = request.getServletContext().getRealPath("/" + UPLOAD_DIR);
            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists()) {
                uploadFolder.mkdirs();
            }
            
            // Handle cover image upload
            if (coverImage != null && !coverImage.isEmpty()) {
                // Delete old cover image if exists
                if (existingModule.getCoverImage() != null && !existingModule.getCoverImage().isEmpty()) {
                    deleteOldFile(uploadDir, existingModule.getCoverImage());
                }
                
                // Save new file
                String savedFileName = saveUploadedFile(coverImage, uploadDir);
                if (savedFileName != null) {
                    existingModule.setCoverImage(UPLOAD_DIR + "/" + savedFileName);
                }
            }
            
            // Handle resource file upload
            if (resourceFile != null && !resourceFile.isEmpty()) {
                // Delete old resource file if exists
                if (existingModule.getResourceFile() != null && !existingModule.getResourceFile().isEmpty()) {
                    deleteOldFile(uploadDir, existingModule.getResourceFile());
                }
                
                // Save new file
                String savedFileName = saveUploadedFile(resourceFile, uploadDir);
                if (savedFileName != null) {
                    existingModule.setResourceFile(UPLOAD_DIR + "/" + savedFileName);
                }
            }
            
            // Update last modified date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            existingModule.setLastUpdated(sdf.format(new Date()));
            
            System.out.println("Updated module: " + existingModule.getId());
            System.out.println("New video URL: " + existingModule.getVideoUrl());
            System.out.println("New content outline: " + existingModule.getContentOutline());
            
            // Update module in database
            boolean success = moduleService.updateModule(id, existingModule);
            
            if (success) {
                // Get user ID from session
                Integer userId = (Integer) session.getAttribute("userId");
                
                // Record edit history
                if (userId != null) {
                    moduleService.recordModuleAccess(id, userId, "edit");
                }
                
                System.out.println("Edit module completed successfully");
                redirectAttributes.addFlashAttribute("success", "Module updated successfully");
                return "redirect:/dashboard";
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to update module");
                return "redirect:/edit-module?id=" + id;
            }
            
        } catch (Exception e) {
            System.out.println("ERROR in EditModuleController: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Server error: " + e.getMessage());
            return "redirect:/dashboard";
        }
    }
    
    private String saveUploadedFile(MultipartFile file, String uploadDir) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }
        
        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        fileName = new File(fileName).getName(); // Clean filename
        
        Path filePath = Paths.get(uploadDir, fileName);
        Files.copy(file.getInputStream(), filePath);
        
        return fileName;
    }
    
    private void deleteOldFile(String uploadDir, String filePath) {
        try {
            // Extract filename from "uploads/filename"
            String fileName = filePath.substring(filePath.lastIndexOf('/') + 1);
            File oldFile = new File(uploadDir + File.separator + fileName);
            if (oldFile.exists()) {
                if (oldFile.delete()) {
                    System.out.println("Deleted old file: " + fileName);
                } else {
                    System.out.println("Failed to delete old file: " + fileName);
                }
            }
        } catch (Exception e) {
            System.err.println("Error deleting old file: " + e.getMessage());
        }
    }
}