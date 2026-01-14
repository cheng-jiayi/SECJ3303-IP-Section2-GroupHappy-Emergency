package smilespace.model;

public class Question {
    private int id;
    private String moduleId;
    private String text;
    private boolean correctAnswer; 
    private String explanation;
    private int order;
    
    public Question() {}
    
    public Question(int id, String moduleId, String text, boolean correctAnswer, String explanation, int order) {
        this.id = id;
        this.moduleId = moduleId;
        this.text = text;
        this.correctAnswer = correctAnswer;
        this.explanation = explanation;
        this.order = order;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getModuleId() { return moduleId; }
    public void setModuleId(String moduleId) { this.moduleId = moduleId; }
    
    public String getText() { return text; }
    public void setText(String text) { this.text = text; }
    
    public boolean isTrue() { return correctAnswer; }
    public void setCorrectAnswer(boolean correctAnswer) { this.correctAnswer = correctAnswer; }
    
    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }
    
    public int getOrder() { return order; }
    public void setOrder(int order) { this.order = order; }
}