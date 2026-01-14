package smilespace.model;

import java.util.List;
import java.util.Map;

public class QuizResult {
    private int attemptId;
    private int userId;
    private String moduleId;
    private String moduleName;
    private int score;
    private int totalQuestions;
    private int percentage;
    private List<Question> questions;
    private Map<Integer, Boolean> userAnswers; // questionId -> userAnswer (true/false)
    
    public QuizResult() {}
    
    // Getters and Setters
    public int getAttemptId() { return attemptId; }
    public void setAttemptId(int attemptId) { this.attemptId = attemptId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getModuleId() { return moduleId; }
    public void setModuleId(String moduleId) { this.moduleId = moduleId; }
    
    public String getModuleName() { return moduleName; }
    public void setModuleName(String moduleName) { this.moduleName = moduleName; }
    
    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }
    
    public int getTotalQuestions() { return totalQuestions; }
    public void setTotalQuestions(int totalQuestions) { this.totalQuestions = totalQuestions; }
    
    public int getPercentage() { return percentage; }
    public void setPercentage(int percentage) { this.percentage = percentage; }
    
    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }
    
    public Map<Integer, Boolean> getUserAnswers() { return userAnswers; }
    public void setUserAnswers(Map<Integer, Boolean> userAnswers) { this.userAnswers = userAnswers; }
}