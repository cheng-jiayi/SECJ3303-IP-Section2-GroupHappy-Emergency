package smilespace.controller;

import jakarta.servlet.http.HttpServletRequest;
import smilespace.model.MoodEntry;
import smilespace.model.MoodWeeklySummary;
import smilespace.model.User;
import smilespace.service.MoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;

@Controller
@RequestMapping("/mood")
public class MoodController {
    
    @Autowired
    private MoodService moodService;
    
    // ===== MAIN ENTRY POINTS =====
    
    // GET /mood - main page
    @GetMapping
    public String handleGet(@RequestParam(value = "action", required = false) String action,
                           @RequestParam(value = "id", required = false) Integer id,
                           @RequestParam(value = "date", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
                           @RequestParam(value = "period", defaultValue = "week") String period,
                           @RequestParam(value = "success", required = false) String success,
                           HttpSession session,
                           Model model) {
        
        System.out.println("===== DEBUG: MoodController.handleGet =====");
        System.out.println("DEBUG: Action: " + action);
        System.out.println("DEBUG: Date: " + date);
        System.out.println("DEBUG: ID: " + id);
        
        // Check session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            // Store original URL
            String originalURL = "/mood";
            if (action != null) originalURL += "?action=" + action;
            if (date != null) originalURL += "&date=" + date;
            session.setAttribute("originalURL", originalURL);
            return "redirect:/login";
        }
        
        int userId = user.getUserId();
        
        try {
            if ("viewTrends".equals(action)) {
                return showMoodTrends(userId, period, model);
            } else if ("add".equals(action)) {
                return showAddMoodFeelings(userId, date, session, model);
            } else if ("viewDaily".equals(action)) {
                return showDailyMood(userId, date, model);
            } else if ("edit".equals(action)) {
                return showEditMood(userId, id, model);
            } else if ("thankyou".equals(action)) {
                return showThankYouPage(session, model);
            } else {
                return showMainPage(userId, success, model);
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error: " + e.getMessage());
            return "error";
        }
    }
    
    // POST /mood
    @PostMapping
    public String handlePost(@RequestParam(value = "action", required = false) String action,
                            @RequestParam(value = "id", required = false) Integer id,
                            @RequestParam(value = "feelings", required = false) String[] feelingArray,
                            @RequestParam(value = "reflection", required = false) String reflection,
                            @RequestParam(value = "tags", required = false) String[] tags,
                            @RequestParam(value = "referrer", required = false) String referrer,
                            @RequestParam(value = "imagePath", required = false) MultipartFile imageFile,
                            @RequestParam(value = "date", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date, // This already exists
                            HttpSession session,
                            HttpServletRequest request,
                            Model model) throws IOException {
        
        System.out.println("===== DEBUG: MoodController.handlePost =====");
        System.out.println("DEBUG: Action: " + action);
        
        // Check session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            // Store original URL
            String originalURL = "/mood";
            if (action != null) originalURL += "?action=" + action;
            session.setAttribute("originalURL", originalURL);
            return "redirect:/login";
        }
        
        int userId = user.getUserId();
        
        try {
            if ("addMoodDetails".equals(action)) {
                return showAddMoodDetails(userId, feelingArray, date, model);
            } else if ("addMood".equals(action)) {
                return addNewMoodEntry(userId, feelingArray, reflection, tags, referrer, imageFile, date, request, model);
            } else if ("updateMood".equals(action)) {
                return updateMoodEntry(userId, id, feelingArray, reflection, tags, referrer, imageFile, request, model);
            } else if ("deleteMood".equals(action)) {
                return deleteMoodEntry(userId, id);
            } else if ("edit".equals(action)) {
                return handleEditFlow(userId, id, feelingArray, model);
            } else {
                return showMainPage(userId, null, model);
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error: " + e.getMessage());
            return "error";
        }
    }
    // ===== PRIVATE METHODS =====
    
    private String showMainPage(int userId, String success, Model model) {
        MoodEntry latestMood = moodService.getLatestMoodEntry(userId);
        
        if (latestMood != null) {
            model.addAttribute("lastMood", latestMood.getFeelingsAsString());
            model.addAttribute("lastDate", latestMood.getFormattedDate());
        } else {
            model.addAttribute("lastMood", "No mood recorded yet");
            model.addAttribute("lastDate", "Never");
        }
        
        if ("true".equals(success)) {
            model.addAttribute("successMessage", "Mood entry added successfully!");
        }
        
        return "moodAndWellnessModule/recordMood";
    }
    
    private String addNewMoodEntry(int userId, String[] feelingArray, String reflection, 
                              String[] tags, String referrer, MultipartFile imageFile,
                              LocalDate selectedDate, // Changed parameter name
                              HttpServletRequest request, Model model) throws IOException {
    
        System.out.println("DEBUG: ======== addNewMoodEntry START ========");
        System.out.println("DEBUG: User ID: " + userId);
        System.out.println("DEBUG: Selected date: " + selectedDate);
        System.out.println("DEBUG: Current date: " + LocalDate.now());
        System.out.println("DEBUG: Feeling count: " + (feelingArray != null ? feelingArray.length : 0));
        
        try {
            List<String> feelingList = new ArrayList<>();
            if (feelingArray != null) {
                for (String feeling : feelingArray) {
                    if (feeling != null && !feeling.trim().isEmpty()) {
                        feelingList.add(feeling.trim().toLowerCase());
                    }
                }
            }

            if (feelingList.isEmpty()) {
                model.addAttribute("error", "Please select at least one feeling");
                model.addAttribute("selectedFeelings", feelingArray);
                return "moodAndWellnessModule/addMoodFeelings";
            }

            Set<String> tagSet = new HashSet<>();
            if (tags != null) {
                for (String tag : tags) {
                    if (tag != null && !tag.trim().isEmpty()) {
                        tagSet.add(tag.trim());
                    }
                }
            }

            // Handle file upload
            String uploadedImagePath = null;
            if (imageFile != null && !imageFile.isEmpty()) {
                String fileName = imageFile.getOriginalFilename();
                if (fileName != null && !fileName.isEmpty()) {
                    // Sanitize filename - replace spaces with underscores
                    String sanitizedFileName = fileName.replaceAll("\\s+", "_");
                    
                    // Use your specific project path
                    String projectPath = System.getProperty("user.dir");
                    String uploadDir = projectPath + File.separator + "uploads" + File.separator + "moods";
                    
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) {
                        boolean created = uploadDirFile.mkdirs();
                        System.out.println("DEBUG: Created upload directory: " + created);
                        System.out.println("DEBUG: Directory path: " + uploadDirFile.getAbsolutePath());
                    }
                    
                    String uniqueFileName = userId + "_" + System.currentTimeMillis() + "_" + sanitizedFileName;
                    String filePath = uploadDir + File.separator + uniqueFileName;
                    
                    // Debug output
                    System.out.println("=== DEBUG: Image Upload ===");
                    System.out.println("Project Path: " + projectPath);
                    System.out.println("Upload Directory: " + uploadDir);
                    System.out.println("Unique Filename: " + uniqueFileName);
                    System.out.println("Full File Path: " + filePath);
                    
                    // Save the file
                    try {
                        imageFile.transferTo(new File(filePath));
                        System.out.println("DEBUG: File saved successfully!");
                        
                        // Verify
                        File savedFile = new File(filePath);
                        System.out.println("DEBUG: File exists: " + savedFile.exists());
                        System.out.println("DEBUG: File size: " + savedFile.length() + " bytes");
                    } catch (IOException e) {
                        System.err.println("ERROR saving file: " + e.getMessage());
                        e.printStackTrace();
                    }
                    
                    // Store relative path for database - WITHOUT leading slash
                    uploadedImagePath = "uploads/moods/" + uniqueFileName;
                    System.out.println("DEBUG: Path to store in DB: " + uploadedImagePath);
                }
            }

            MoodEntry newEntry = new MoodEntry();
            newEntry.setUserId(userId);
            newEntry.setFeelings(feelingList);
            newEntry.setReflection(reflection != null ? reflection.trim() : "");
            newEntry.setTags(tagSet);
            newEntry.setImagePath(uploadedImagePath);
            
            // FIX: Use selectedDate if provided, otherwise use today
            if (selectedDate != null) {
                newEntry.setEntryDate(selectedDate);
            } else {
                newEntry.setEntryDate(LocalDate.now());
            }
            
            System.out.println("DEBUG: Final entry date: " + newEntry.getEntryDate());

            System.out.println("DEBUG: Attempting to save mood entry...");
            boolean success = moodService.createMoodEntry(newEntry);
            System.out.println("DEBUG: createMoodEntry result: " + success);

            if (success) {
                System.out.println("DEBUG: Success! Redirecting to thank you page");
                if ("trends".equals(referrer)) {
                    return "redirect:/mood?action=viewDaily&date=" + newEntry.getEntryDate();
                } else {
                    // Store in session for thank you page
                    model.addAttribute("savedEntry", newEntry);
                    return "moodAndWellnessModule/moodThankYou";
                }
            } else {
                System.out.println("DEBUG: Save failed! Checking why...");
                
                // Check if entry already exists for the selected date
                MoodEntry existingEntry = moodService.getMoodEntryByDate(userId, selectedDate != null ? selectedDate : LocalDate.now());
                if (existingEntry != null) {
                    System.out.println("DEBUG: Entry already exists for selected date. Redirecting to daily view page.");
                    return "redirect:/mood?action=viewDaily&date=" + (selectedDate != null ? selectedDate : LocalDate.now());
                } else {
                    System.out.println("DEBUG: No existing entry found, but save still failed.");
                    // Go back to details page with feelings preserved
                    model.addAttribute("selectedFeelings", feelingArray);
                    model.addAttribute("error", "Failed to save mood entry. Please try again.");
                    return "moodAndWellnessModule/addMoodDetails";
                }
            }
            
        } catch (Exception e) {
            System.err.println("DEBUG: Exception in addNewMoodEntry: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "An error occurred: " + e.getMessage());
            model.addAttribute("selectedFeelings", feelingArray);
            return "moodAndWellnessModule/addMoodDetails";
        }
    }

    private String showAddMoodFeelings(int userId, LocalDate date, HttpSession session, Model model) {
        System.out.println("DEBUG: showAddMoodFeelings called");
        System.out.println("DEBUG: Date parameter: " + date);
        System.out.println("DEBUG: Today's date: " + LocalDate.now());
        
        LocalDate checkDate = (date != null) ? date : LocalDate.now();
        MoodEntry existingEntry = moodService.getMoodEntryByDate(userId, checkDate);
        
        if (existingEntry != null) {
            System.out.println("DEBUG: Entry already exists for date: " + checkDate);
            System.out.println("DEBUG: Redirecting to daily view for date: " + checkDate);
            return "redirect:/mood?action=viewDaily&date=" + checkDate;
        }
        
        System.out.println("DEBUG: No entry exists for date: " + checkDate + ". Showing add feelings page.");
        return "moodAndWellnessModule/addMoodFeelings";
    }

    private String showAddMoodDetails(int userId, String[] selectedFeelings, 
                                 LocalDate date,
                                 Model model) {
        if (selectedFeelings == null || selectedFeelings.length == 0) {
            model.addAttribute("error", "Please select at least one feeling");
            return "moodAndWellnessModule/addMoodFeelings";
        }
        
        model.addAttribute("selectedFeelings", selectedFeelings);

        if (date != null) {
            model.addAttribute("date", date.toString());
        }
        return "moodAndWellnessModule/addMoodDetails";
    }
    
    private String showMoodTrends(int userId, String period, Model model) {
        List<MoodEntry> allEntries = moodService.getMoodEntriesByUser(userId);
        MoodWeeklySummary summary = moodService.getWeeklySummary(userId, LocalDate.now());
    
        model.addAttribute("selectedPeriod", period);
        model.addAttribute("weeklySummary", summary);
        model.addAttribute("allMoodEntries", allEntries);
        model.addAttribute("moodTrends", moodService.getMoodTrends(userId));
    
        return "moodAndWellnessModule/viewMoodTrends";
    }
    
    private String showDailyMood(int userId, LocalDate date, Model model) {
        System.out.println("DEBUG: showDailyMood called with date: " + date);
        
        if (date != null) {
            try {
                MoodEntry dailyMood = moodService.getMoodEntryByDate(userId, date);
                
                if (dailyMood != null) {
                    System.out.println("DEBUG: Found mood entry for date: " + date);
                    model.addAttribute("dailyMood", dailyMood);
                    return "moodAndWellnessModule/viewDailyMood";
                } else {
                    System.out.println("DEBUG: No mood entry found for date: " + date);
                    model.addAttribute("message", "No mood entry found for " + date);
                    return "redirect:/mood?action=add&date=" + date;
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("DEBUG: Error parsing date: " + date);
                model.addAttribute("error", "Invalid date format");
                return "redirect:/mood?action=viewTrends";
            }
        } else {
            System.out.println("DEBUG: No date parameter provided");
            return "redirect:/mood?action=viewTrends";
        }
    }
    
    private String showEditMood(int userId, Integer id, Model model) {
        if (id == null) {
            return "redirect:/mood?action=viewTrends";
        }
        
        try {
            MoodEntry moodToEdit = moodService.getMoodEntryById(id, userId);
            
            if (moodToEdit != null) {
                model.addAttribute("selectedFeelings", moodToEdit.getFeelings().toArray(new String[0]));
                model.addAttribute("moodToEdit", moodToEdit);
                model.addAttribute("isEdit", true);
                model.addAttribute("date", moodToEdit.getEntryDate().toString());
                System.out.println("DEBUG showEditMood: Adding date to model: " + moodToEdit.getEntryDate());
                
                return "moodAndWellnessModule/addMoodFeelings";
            } else {
                return "redirect:/mood?action=viewTrends";
            }
        } catch (Exception e) {
            return "redirect:/mood?action=viewTrends";
        }
    }
    
    private String handleEditFlow(int userId, Integer id, String[] feelings, Model model) {
        if (id == null || feelings == null) {
            return "redirect:/mood?action=viewTrends";
        }
        
        try {
            MoodEntry moodToEdit = moodService.getMoodEntryById(id, userId);
            
            if (moodToEdit != null) {
                model.addAttribute("selectedFeelings", feelings);
                model.addAttribute("moodToEdit", moodToEdit);
                model.addAttribute("isEdit", true);
                return "moodAndWellnessModule/addMoodDetails";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/mood?action=viewTrends";
    }
    
    private String updateMoodEntry(int userId, Integer id, String[] feelingArray, 
                              String reflection, String[] tags, String referrer,
                              MultipartFile imageFile, HttpServletRequest request,
                              Model model) throws IOException {
    
        if (id == null) {
            return "redirect:/mood?action=viewTrends";
        }

        try {
            MoodEntry updatedEntry = moodService.getMoodEntryById(id, userId);
            if (updatedEntry == null) {
                return "redirect:/mood?action=viewTrends";
            }

            List<String> feelingList = new ArrayList<>();
            if (feelingArray != null) {
                for (String feeling : feelingArray) {
                    if (feeling != null && !feeling.trim().isEmpty()) {
                        feelingList.add(feeling.trim().toLowerCase());
                    }
                }
            }

            if (feelingList.isEmpty()) {
                model.addAttribute("error", "Please select at least one feeling");
                model.addAttribute("moodToEdit", updatedEntry);
                model.addAttribute("isEdit", true);
                return "moodAndWellnessModule/addMoodFeelings";
            }

            Set<String> tagSet = new HashSet<>();
            if (tags != null) {
                for (String tag : tags) {
                    if (tag != null && !tag.trim().isEmpty()) {
                        tagSet.add(tag.trim());
                    }
                }
            }

            // Handle file upload - USE THE SAME PATH AS addNewMoodEntry
            if (imageFile != null && !imageFile.isEmpty()) {
                String fileName = imageFile.getOriginalFilename();
                if (fileName != null && !fileName.isEmpty()) {
                    // Sanitize filename - replace spaces with underscores
                    String sanitizedFileName = fileName.replaceAll("\\s+", "_");
                    
                    // USE THE SAME PATH AS addNewMoodEntry
                    String projectPath = System.getProperty("user.dir");
                    String uploadDir = projectPath + File.separator + "uploads" + File.separator + "moods";
                    
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) {
                        boolean created = uploadDirFile.mkdirs();
                        System.out.println("DEBUG: Created upload directory: " + created);
                    }
                    
                    String uniqueFileName = userId + "_" + System.currentTimeMillis() + "_" + sanitizedFileName;
                    String filePath = uploadDir + File.separator + uniqueFileName;
                    
                    System.out.println("=== DEBUG: Uploading image in edit ===");
                    System.out.println("Project Path: " + projectPath);
                    System.out.println("Upload Directory: " + uploadDir);
                    System.out.println("File path: " + filePath);
                    
                    imageFile.transferTo(new File(filePath));
                    
                    // Store path WITHOUT leading slash
                    updatedEntry.setImagePath("uploads/moods/" + uniqueFileName);
                    
                    System.out.println("Image path saved to DB: " + updatedEntry.getImagePath());
                }
            }

            updatedEntry.setFeelings(feelingList);
            updatedEntry.setReflection(reflection != null ? reflection.trim() : "");
            updatedEntry.setTags(tagSet);

            boolean success = moodService.updateMoodEntry(updatedEntry);
            
            System.out.println("=== DEBUG: Update result ===");
            System.out.println("Success: " + success);
            System.out.println("Entry date: " + updatedEntry.getEntryDate());
            
            if (success) {
                // FIX: ALWAYS redirect to daily view after editing (not thank you page)
                // Add timestamp to prevent browser caching
                String timestamp = "&t=" + System.currentTimeMillis();
                String redirectUrl = "redirect:/mood?action=viewDaily&date=" + updatedEntry.getEntryDate() + timestamp;
                
                System.out.println("Redirecting to: " + redirectUrl);
                return redirectUrl;
            } else {
                return "redirect:/mood?action=viewTrends";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "An error occurred: " + e.getMessage());
            return showEditMood(userId, id, model);
        }
    }

    private String deleteMoodEntry(int userId, Integer id) {
        System.out.println("DEBUG: deleteMoodEntry called");
        System.out.println("DEBUG: id parameter = " + id);
        System.out.println("DEBUG: userId = " + userId);
        
        if (id != null) {
            try {
                boolean deleted = moodService.deleteMoodEntry(id, userId);
                System.out.println("DEBUG: Delete operation result = " + deleted);
                
                if (deleted) {
                    System.out.println("DEBUG: Successfully deleted mood entry " + id);
                    return "redirect:/mood?action=viewTrends&deleted=true&t=" + System.currentTimeMillis();
                } else {
                    System.out.println("DEBUG: Failed to delete mood entry " + id);
                }
            } catch (Exception e) {
                System.out.println("DEBUG: Invalid mood ID: " + id);
                e.printStackTrace();
            }
        } else {
            System.out.println("DEBUG: No id parameter provided");
        }
        
        return "redirect:/mood?action=viewTrends";
    }
    
    private String showThankYouPage(HttpSession session, Model model) {
        MoodEntry savedEntry = (MoodEntry) session.getAttribute("lastMoodEntry");
        if (savedEntry == null) {
            return "redirect:/mood";
        }
        
        model.addAttribute("savedEntry", savedEntry);
        return "moodAndWellnessModule/moodThankYou";
    }
}