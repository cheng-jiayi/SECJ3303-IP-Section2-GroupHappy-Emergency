package smilespace.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/ai")  
public class AIController {
    
    @GetMapping("/chat")
    public String showChat(HttpSession session, Model model) {
        // Set default user if not logged in
        if (session.getAttribute("userRole") == null) {
            session.setAttribute("userRole", "student");
            session.setAttribute("userFullName", "Guest Student");
        }
        
        model.addAttribute("userFullName", session.getAttribute("userFullName"));
        model.addAttribute("userRole", session.getAttribute("userRole"));
        
        return "AIAssistant/Chat/AIConservationHub";
    }
    
    @PostMapping("/chat")
    @ResponseBody
    public Map<String, String> handleChat(@RequestParam("message") String message, HttpSession session) {
        Map<String, String> response = new HashMap<>();
        
        // Simple AI response logic - you can replace this with actual AI integration
        String userMessage = message.toLowerCase();
        String aiResponse;
        
        if (userMessage.contains("stress") || userMessage.contains("anxious") || userMessage.contains("overwhelm")) {
            aiResponse = "I understand you're feeling stressed. Would you like to try a breathing exercise or talk more about what's bothering you?";
        } else if (userMessage.contains("sad") || userMessage.contains("depress") || userMessage.contains("down")) {
            aiResponse = "I'm here for you. Remember, it's okay to feel this way. Would you like to practice gratitude or talk about what's making you feel this way?";
        } else if (userMessage.contains("happy") || userMessage.contains("good") || userMessage.contains("great")) {
            aiResponse = "That's wonderful to hear! Would you like to explore ways to maintain this positive mindset?";
        } else if (userMessage.contains("sleep") || userMessage.contains("tired")) {
            aiResponse = "Sleep issues can be challenging. Would you like some tips for better sleep or a relaxation exercise?";
        } else {
            // Default responses
            String[] defaultResponses = {
                "I'm here to support you. Could you tell me more about how you're feeling?",
                "Thank you for sharing. How does that make you feel?",
                "I understand. How can I support you right now?",
                "That's interesting. Would you like to explore this further?"
            };
            aiResponse = defaultResponses[(int)(Math.random() * defaultResponses.length)];
        }
        
        response.put("response", aiResponse);
        return response;
    }
    
    @GetMapping("/learn")
    public String showLearningHub(HttpSession session, Model model) {
        // Set default user if not logged in
        if (session.getAttribute("userFullName") == null) {
            session.setAttribute("userFullName", "Guest Student");
        }
        
        model.addAttribute("userFullName", session.getAttribute("userFullName"));
        model.addAttribute("contextPath", "/smilespace");
        
        return "AIAssistant/Learn/AILearningHub";
    }
    
    @GetMapping("/learn/module")
    public String showLearnModule(
            HttpSession session,
            Model model,
            @RequestParam(value = "module", defaultValue = "stress") String module,
            @RequestParam(value = "topic", defaultValue = "1") String topic) {
        
        // Set default user if not logged in
        if (session.getAttribute("userFullName") == null) {
            session.setAttribute("userFullName", "Guest Student");
        }
        
        model.addAttribute("userFullName", session.getAttribute("userFullName"));
        model.addAttribute("module", module);
        model.addAttribute("topic", topic);
        model.addAttribute("contextPath", "/smilespace");
        
        // Topic data
        String[] topicTitles = {
            "Understanding Stress",
            "Coping Strategies", 
            "Maintaining Long-Term Stress Management"
        };
        
        String[] aiMessages = {
            "Let's talk about stress management today. Stress is a normal response to challenges, but too much can affect your health.",
            "Now that you understand stress, let's explore practical ways to cope with it effectively.",
            "Great! Let's discuss maintaining a healthy mindset and preventing burnout over the long term."
        };
        
        String[] mainContents = {
            "Stress triggers physical reactions like faster heartbeat and tense muscles. Understanding these reactions helps you manage them effectively.<br><br>Here's a quick tip: Take 5 deep breaths whenever you feel overwhelmed — it can calm your mind instantly.",
            "One common method is time management. Breaking tasks into smaller steps reduces overwhelm and boosts focus.<br><br>Another tip: Physical activity like a 10-minute walk can relieve tension and improve your mood.",
            "Regular sleep, balanced diet, and mindfulness practices help keep stress levels manageable.<br><br>Try scheduling a weekly self-care routine: start meditation, journaling, or talking with a friend."
        };
        
        String[] exampleContents = {
            "When you feel overwhelmed with work, stop and take 5 deep breaths. This simple technique can help calm your nervous system and clear your mind.",
            "Imagine having multiple assignments. Try creating a checklist and tackling one task at a time.",
            "Managing Stress in Daily Life: Learn how to identify sources of everyday stress, and build healthy habits.<br><br>Time Management to Reduce Stress: Understand how effective time management can lower stress levels."
        };
        
        int currentTopic;
        boolean isComplete = topic.equals("complete");
        
        if (isComplete) {
            currentTopic = 3;
        } else {
            try {
                currentTopic = Integer.parseInt(topic);
            } catch (NumberFormatException e) {
                currentTopic = 1;
            }
        }
        
        if (currentTopic >= 1 && currentTopic <= 3) {
            model.addAttribute("currentTopic", currentTopic);
            model.addAttribute("topicTitle", topicTitles[currentTopic-1]);
            model.addAttribute("aiMessage", aiMessages[currentTopic-1]);
            model.addAttribute("mainContent", mainContents[currentTopic-1]);
            model.addAttribute("exampleContent", exampleContents[currentTopic-1]);
        } else {
            model.addAttribute("currentTopic", 1);
            model.addAttribute("topicTitle", topicTitles[0]);
            model.addAttribute("aiMessage", aiMessages[0]);
            model.addAttribute("mainContent", mainContents[0]);
            model.addAttribute("exampleContent", exampleContents[0]);
        }
        
        model.addAttribute("isComplete", isComplete);
        model.addAttribute("progressWidth", isComplete ? 100 : (currentTopic * 100) / 3);
        
        return "AIAssistant/Learn/learn-module";
    }
}