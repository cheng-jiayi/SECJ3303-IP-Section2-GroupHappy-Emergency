package smilespace.dao;

import smilespace.model.Question;
import smilespace.model.QuizResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.sql.*;
import java.util.*;

@Repository
@Transactional
public class QuizDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private final RowMapper<Question> questionRowMapper = (rs, rowNum) -> {
        Question question = new Question();
        question.setId(rs.getInt("question_id"));
        question.setText(rs.getString("question_text"));
        question.setCorrectAnswer(rs.getBoolean("correct_answer"));
        question.setModuleId(rs.getString("module_id"));
        return question;
    };
    
    private final RowMapper<QuizResult> quizResultRowMapper = (rs, rowNum) -> {
        QuizResult result = new QuizResult();
        result.setAttemptId(rs.getInt("attempt_id"));
        result.setScore(rs.getInt("score"));
        result.setTotalQuestions(rs.getInt("total_questions"));
        result.setPercentage(rs.getInt("percentage"));
        result.setModuleId(rs.getString("module_id"));
        result.setModuleName(rs.getString("module_name"));
        return result;
    };
    
    public List<Question> getQuestionsByModule(String moduleId) {
        System.out.println("QuizDAO.getQuestionsByModule called for module: " + moduleId);
        
        String sql = "SELECT question_id, question_text, correct_answer, module_id " +
                    "FROM quiz_questions WHERE module_id = ? ORDER BY question_order";
        
        try {
            List<Question> questions = jdbcTemplate.query(sql, questionRowMapper, moduleId);
            System.out.println("Retrieved " + questions.size() + " questions");
            return questions;
            
        } catch (Exception e) {
            System.err.println("ERROR in getQuestionsByModule: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error in getQuestionsByModule: " + e.getMessage(), e);
        }
    }
    
    public int startQuizAttempt(int userId, String moduleId) {
        System.out.println("QuizDAO.startQuizAttempt called for user=" + userId + ", module=" + moduleId);
        
        String sql = "INSERT INTO quiz_attempts (user_id, module_id, started_at) VALUES (?, ?, NOW())";
        
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, userId);
                ps.setString(2, moduleId);
                return ps;
            }, keyHolder);
            
            Number key = keyHolder.getKey();
            if (key != null) {
                int attemptId = key.intValue();
                System.out.println("Generated attempt ID: " + attemptId);
                return attemptId;
            }
            
        } catch (Exception e) {
            System.err.println("ERROR in startQuizAttempt: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error in startQuizAttempt: " + e.getMessage(), e);
        }
        
        System.err.println("Failed to generate attempt ID");
        return -1;
    }
    
    public void saveQuizResult(int attemptId, Map<Integer, Boolean> userAnswers) {
        System.out.println("QuizDAO.saveQuizResult called for attempt=" + attemptId + ", answers=" + userAnswers.size());
        
        try {
            jdbcTemplate.execute("SET autocommit=0");
            
            int correctCount = 0;
            int totalQuestions = userAnswers.size();
            
            System.out.println("Processing " + totalQuestions + " answers");
            
            // Save each answer
            for (Map.Entry<Integer, Boolean> entry : userAnswers.entrySet()) {
                int questionId = entry.getKey();
                boolean userAnswer = entry.getValue();
                
                // Get correct answer
                String checkSql = "SELECT correct_answer FROM quiz_questions WHERE question_id = ?";
                Boolean correctAnswer = jdbcTemplate.queryForObject(checkSql, Boolean.class, questionId);
                
                if (correctAnswer != null) {
                    boolean isCorrect = (userAnswer == correctAnswer);
                    
                    if (isCorrect) {
                        correctCount++;
                    }
                    
                    // Insert answer
                    String insertSql = "INSERT INTO quiz_answers (attempt_id, question_id, user_answer, is_correct) " +
                                     "VALUES (?, ?, ?, ?)";
                    jdbcTemplate.update(insertSql, attemptId, questionId, userAnswer, isCorrect);
                } else {
                    System.err.println("Question not found: " + questionId);
                }
            }
            
            // Update attempt with final score
            int percentage = totalQuestions > 0 ? (correctCount * 100) / totalQuestions : 0;
            System.out.println("Calculated score: " + correctCount + "/" + totalQuestions + " = " + percentage + "%");
            
            String updateSql = "UPDATE quiz_attempts SET score = ?, total_questions = ?, percentage = ?, completed_at = NOW() " +
                             "WHERE attempt_id = ?";
            int updated = jdbcTemplate.update(updateSql, correctCount, totalQuestions, percentage, attemptId);
            System.out.println("Updated " + updated + " rows in quiz_attempts");
            
            jdbcTemplate.execute("COMMIT");
            System.out.println("Transaction committed successfully");
            
        } catch (Exception e) {
            jdbcTemplate.execute("ROLLBACK");
            System.err.println("ERROR in saveQuizResult: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error in saveQuizResult: " + e.getMessage(), e);
        } finally {
            try {
                jdbcTemplate.execute("SET autocommit=1");
            } catch (Exception e) {
                System.err.println("Error resetting autocommit: " + e.getMessage());
            }
        }
    }
    
    public QuizResult getQuizResult(int attemptId) {
        System.out.println("QuizDAO.getQuizResult called for attempt=" + attemptId);
        
        String sql = "SELECT qa.attempt_id, qa.score, qa.total_questions, qa.percentage, " +
                    "qa.completed_at, lm.id as module_id, lm.title as module_name " +
                    "FROM quiz_attempts qa " +
                    "JOIN learning_modules lm ON qa.module_id = lm.id " +
                    "WHERE qa.attempt_id = ?";
        
        try {
            QuizResult result = jdbcTemplate.queryForObject(sql, quizResultRowMapper, attemptId);
            
            if (result != null) {
                System.out.println("Found quiz result: " + result.getScore() + "/" + result.getTotalQuestions());
                
                // Get user answers
                result.setUserAnswers(getUserAnswers(attemptId));
                
                // Get questions
                result.setQuestions(getQuestionsForAttempt(attemptId));
                
                return result;
            } else {
                System.err.println("No quiz result found for attempt: " + attemptId);
            }
            
        } catch (Exception e) {
            System.err.println("ERROR in getQuizResult: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error in getQuizResult: " + e.getMessage(), e);
        }
        
        return null;
    }
    
    private Map<Integer, Boolean> getUserAnswers(int attemptId) {
        System.out.println("QuizDAO.getUserAnswers called for attempt=" + attemptId);
        
        Map<Integer, Boolean> answers = new HashMap<>();
        String sql = "SELECT question_id, user_answer FROM quiz_answers WHERE attempt_id = ?";
        
        try {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, attemptId);
            
            for (Map<String, Object> row : rows) {
                answers.put(((Number) row.get("question_id")).intValue(), 
                           (Boolean) row.get("user_answer"));
            }
            
            System.out.println("Retrieved " + answers.size() + " user answers");
            
        } catch (Exception e) {
            System.err.println("ERROR in getUserAnswers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return answers;
    }
    
    private List<Question> getQuestionsForAttempt(int attemptId) {
        System.out.println("QuizDAO.getQuestionsForAttempt called for attempt=" + attemptId);
        
        String sql = "SELECT qq.question_id, qq.question_text, qq.correct_answer, qq.module_id " +
                    "FROM quiz_questions qq " +
                    "JOIN quiz_answers qa ON qq.question_id = qa.question_id " +
                    "WHERE qa.attempt_id = ? " +
                    "ORDER BY qq.question_order";
        
        try {
            return jdbcTemplate.query(sql, questionRowMapper, attemptId);
        } catch (Exception e) {
            System.err.println("ERROR in getQuestionsForAttempt: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}