package smilespace.service;

import smilespace.model.Question;
import smilespace.model.QuizResult;
import smilespace.dao.QuizDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;

@Service
@Transactional
public class QuizService {
    
    @Autowired
    private QuizDAO quizDAO;
    
    public List<Question> getQuestionsByModule(String moduleId) {
        return quizDAO.getQuestionsByModule(moduleId);
    }
    
    public QuizResult processQuizSubmission(int userId, String moduleId, Map<Integer, Boolean> userAnswers) {
        int attemptId = quizDAO.startQuizAttempt(userId, moduleId);
        
        if (attemptId > 0) {
            quizDAO.saveQuizResult(attemptId, userAnswers);
            return quizDAO.getQuizResult(attemptId);
        }
        
        return null;
    }
    
    public QuizResult getQuizResult(int attemptId) {
        return quizDAO.getQuizResult(attemptId);
    }
    
    public String getFirstModuleWithQuestions(LearningModuleService moduleService) {
        System.out.println("Finding first module with questions...");
        
        List<smilespace.model.LearningModule> allModules = moduleService.getAllModules();
        System.out.println("Total modules found: " + (allModules != null ? allModules.size() : 0));
        
        for (smilespace.model.LearningModule module : allModules) {
            System.out.println("Checking module: " + module.getId());
            List<Question> questions = getQuestionsByModule(module.getId());
            if (!questions.isEmpty()) {
                System.out.println("Found module with questions: " + module.getId());
                return module.getId();
            }
        }
        
        System.out.println("No module with questions found, defaulting to LM001");
        return "LM001";
    }
}