package smilespace.filter;

import java.util.logging.Logger;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class FeedbackAuthorizationFilter implements HandlerInterceptor {
    private static final Logger logger = Logger.getLogger(FeedbackAuthorizationFilter.class.getName());
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        logger.info("FeedbackAuthorizationInterceptor checking access to: " + requestURI);
        
        // Only intercept feedback analytics URLs
        if (!(requestURI.contains("/feedback-analytics") || 
              requestURI.contains("/feedback/reply") || 
              requestURI.contains("/feedback/report") ||
              requestURI.contains("/feedback-resolve"))) {
            return true;
        }
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            logger.warning("User not logged in, redirecting to login page");
            String loginPage = contextPath + "/login";
            response.sendRedirect(loginPage);
            return false;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        Object userIdObj = session.getAttribute("userId");
        int userId = 0;
        
        // Safely handle user ID
        if (userIdObj instanceof Integer) {
            userId = (Integer) userIdObj;
        } else if (userIdObj instanceof String) {
            try {
                userId = Integer.parseInt((String) userIdObj);
            } catch (NumberFormatException e) {
                logger.warning("Invalid user ID format: " + userIdObj);
            }
        }
        
        logger.info("User ID: " + userId + ", Role: " + userRole);
        
        // Check authorization: only admin or faculty can access analytics
        if (!isAuthorized(userRole)) {
            logger.warning("User " + userId + " with role " + userRole + " not authorized for: " + requestURI);
            response.sendRedirect(contextPath + "/dashboard?error=unauthorized");
            return false;
        }
        
        // Add user info to request
        request.setAttribute("loggedInUserId", userId);
        request.setAttribute("loggedInUserRole", userRole);
        
        return true;
    }
    
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, 
                          Object handler, ModelAndView modelAndView) throws Exception {
        // Post-handle logic if needed
    }
    
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, 
                               Object handler, Exception ex) throws Exception {
        // After completion logic if needed
    }
    
    private boolean isAuthorized(String userRole) {
        return "admin".equals(userRole) || "faculty".equals(userRole);
    }
}