package smilespace.controller.completeQuiz;

import smilespace.model.Question;
import smilespace.model.QuizResult;
import smilespace.model.LearningModule;
import smilespace.service.QuizService;
import smilespace.service.LearningModuleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import jakarta.servlet.http.HttpSession;
import java.util.*;

@Controller
public class QuizController {
    
    @Autowired
    private QuizService quizService;
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/quiz")
    public String handleQuizRequest(@RequestParam(value = "action", required = false) String action,
                                   @RequestParam(value = "moduleId", required = false) String moduleId,
                                   Model model,
                                   HttpSession session) {
        
        try {
            if ("start".equals(action)) {
                System.out.println("QuizController: Starting quiz instruction for action=" + action);
                
                String currentModuleId = moduleId;
                if (currentModuleId == null || currentModuleId.isEmpty()) {
                    currentModuleId = (String) session.getAttribute("currentModuleId");
                    if (currentModuleId == null) {
                        currentModuleId = quizService.getFirstModuleWithQuestions(moduleService);
                        System.out.println("No module in session, using first available: " + currentModuleId);
                    }
                }
                
                session.setAttribute("currentModuleId", currentModuleId);
                
                LearningModule module = moduleService.getModuleById(currentModuleId);
                String moduleName = module != null ? module.getTitle() : "Quiz";
                System.out.println("Module found: " + moduleName + " (ID: " + currentModuleId + ")");
                
                List<Question> questions = quizService.getQuestionsByModule(currentModuleId);
                int questionCount = questions.size();
                System.out.println("Number of questions: " + questionCount);
                
                if (questionCount == 0) {
                    System.out.println("No questions found for module: " + currentModuleId + ", trying another module");
                    currentModuleId = quizService.getFirstModuleWithQuestions(moduleService);
                    module = moduleService.getModuleById(currentModuleId);
                    moduleName = module != null ? module.getTitle() : "Quiz";
                    questions = quizService.getQuestionsByModule(currentModuleId);
                    questionCount = questions.size();
                    session.setAttribute("currentModuleId", currentModuleId);
                    System.out.println("Switched to module: " + currentModuleId + " with " + questionCount + " questions");
                }
                
                model.addAttribute("duration", questionCount + " minutes");
                model.addAttribute("type", "True/False (" + questionCount + " questions)");
                model.addAttribute("moduleName", moduleName);
                model.addAttribute("moduleId", currentModuleId);
                
                System.out.println("Forwarding to quiz-instruction.jsp");
                return "completeQuiz/quiz-instruction";
                
            } else if ("take".equals(action)) {
                System.out.println("QuizController: Taking quiz for action=" + action);
                
                String currentModuleId = moduleId;
                if (currentModuleId == null || currentModuleId.isEmpty()) {
                    currentModuleId = (String) session.getAttribute("currentModuleId");
                    System.out.println("Module from session: " + currentModuleId);
                }
                
                if (currentModuleId == null) {
                    currentModuleId = quizService.getFirstModuleWithQuestions(moduleService);
                    System.out.println("No module found, using first available: " + currentModuleId);
                }
                
                List<Question> questions = quizService.getQuestionsByModule(currentModuleId);
                System.out.println("Retrieved " + questions.size() + " questions");
                
                if (questions.isEmpty()) {
                    System.out.println("Questions empty, finding another module");
                    currentModuleId = quizService.getFirstModuleWithQuestions(moduleService);
                    questions = quizService.getQuestionsByModule(currentModuleId);
                }
                
                LearningModule module = moduleService.getModuleById(currentModuleId);
                String moduleName = module != null ? module.getTitle() : "Quiz";
                
                session.setAttribute("currentModuleId", currentModuleId);
                
                model.addAttribute("questions", questions);
                model.addAttribute("moduleName", moduleName);
                model.addAttribute("moduleId", currentModuleId);
                
                System.out.println("Forwarding to quiz.jsp with " + questions.size() + " questions");
                return "completeQuiz/quiz";
                
            } else if ("result".equals(action)) {
                System.out.println("QuizController: Showing result");
                
                QuizResult result = (QuizResult) session.getAttribute("quizResult");
                
                if (result == null) {
                    System.out.println("No quiz result found in session, redirecting to dashboard");
                    return "redirect:/quiz-dashboard";
                }
                
                System.out.println("Quiz result found: score=" + result.getScore() + "/" + result.getTotalQuestions());
                model.addAttribute("quizResult", result);
                return "completeQuiz/quiz-result";
                
            } else {
                System.out.println("Unknown action: " + action + ", redirecting to dashboard");
                return "redirect:/quiz-dashboard";
            }
            
        } catch (Exception e) {
            System.err.println("ERROR in QuizController: " + e.getMessage());
            e.printStackTrace();
            
            model.addAttribute("error", e.getMessage());
            model.addAttribute("stackTrace", getStackTraceAsString(e));
            
            return "error";
        }
    }
    
    @PostMapping("/quiz")
    public String submitQuiz(@RequestParam Map<String, String> allParams,
                            HttpSession session,
                            Model model) {
        
        System.out.println("QuizController: Processing POST request");
        
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                userId = 1; // Default to student1
                System.out.println("Using default userId: " + userId);
            }
            
            String moduleId = (String) session.getAttribute("currentModuleId");
            if (moduleId == null) {
                moduleId = quizService.getFirstModuleWithQuestions(moduleService);
                System.out.println("No module in session, using: " + moduleId);
            }
            
            Map<Integer, Boolean> userAnswers = new HashMap<>();
            
            System.out.println("Parsing user answers...");
            for (Map.Entry<String, String> entry : allParams.entrySet()) {
                String paramName = entry.getKey();
                if (paramName.startsWith("q")) {
                    try {
                        int questionId = Integer.parseInt(paramName.substring(1));
                        String answerValue = entry.getValue();
                        boolean userAnswer = "true".equalsIgnoreCase(answerValue);
                        userAnswers.put(questionId, userAnswer);
                        System.out.println("Question " + questionId + ": " + answerValue + " -> " + userAnswer);
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid parameter: " + paramName);
                    }
                }
            }
            
            System.out.println("Total answers parsed: " + userAnswers.size());
            
            QuizResult result = quizService.processQuizSubmission(userId, moduleId, userAnswers);
            
            if (result != null) {
                System.out.println("Quiz result processed: " + result.getScore() + "/" + result.getTotalQuestions());
                session.setAttribute("quizResult", result);
                return "redirect:/quiz?action=result";
            }
            
            System.err.println("Something went wrong, redirecting to dashboard");
            return "redirect:/quiz-dashboard";
            
        } catch (Exception e) {
            System.err.println("ERROR in QuizController.submitQuiz: " + e.getMessage());
            e.printStackTrace();
            
            model.addAttribute("error", e.getMessage());
            model.addAttribute("stackTrace", getStackTraceAsString(e));
            
            return "error";
        }
    }
    
    private String getStackTraceAsString(Exception e) {
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        e.printStackTrace(pw);
        return sw.toString();
    }
}