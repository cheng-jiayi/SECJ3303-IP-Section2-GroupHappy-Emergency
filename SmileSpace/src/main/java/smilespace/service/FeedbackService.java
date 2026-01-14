package smilespace.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import smilespace.dao.FeedbackDAO;
import smilespace.model.Feedback;

@Service
@Transactional
public class FeedbackService {
    
    @Autowired
    private FeedbackDAO feedbackDAO;
    
    public boolean saveFeedback(Feedback feedback, Integer userId) {
        return feedbackDAO.createFeedback(feedback, userId);
    }
    
    public List<Feedback> getFeedbackByUser(int userId) {
        return feedbackDAO.getFeedbackByUserId(userId);
    }
    
    public List<Feedback> getAllFeedback() {
        return feedbackDAO.getAllFeedback();
    }
}