package smilespace.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import smilespace.dao.FeedbackDAO;
import smilespace.model.Feedback;

@Service
@Transactional
public class FeedbackAnalyticsService {
    
    @Autowired
    private FeedbackDAO feedbackDAO;
    
    public List<Feedback> getAllFeedback() {
        return feedbackDAO.getAllFeedback();
    }
    
    public Feedback getFeedbackById(int feedbackId) {
        return feedbackDAO.getFeedbackById(feedbackId);
    }
    
    public boolean sendReply(int feedbackId, String replyMessage, Integer userId) {
        return feedbackDAO.updateFeedbackReply(feedbackId, replyMessage, userId);
    }
    
    public boolean markAsResolved(int feedbackId, Integer userId) {
        return feedbackDAO.markAsResolved(feedbackId, userId);
    }
    
    public List<Feedback> searchFeedback(String searchTerm, String sentiment, String status) {
        return feedbackDAO.searchFeedback(searchTerm, sentiment, status);
    }
    
    public Map<String, Integer> getFeedbackStats() {
        return feedbackDAO.getFeedbackStats();
    }
    
    public List<Map<String, Object>> getFeedbackHistory(int feedbackId) {
        return feedbackDAO.getFeedbackHistory(feedbackId);
    }
}