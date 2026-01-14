package smilespace.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

// @WebFilter("/mood/*")
public class MoodAuthorizationFilter implements Filter {
    private static final Logger logger = Logger.getLogger(MoodAuthorizationFilter.class.getName());
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            // Store original URL for redirect back
            String originalURL = httpRequest.getRequestURI();
            if (httpRequest.getQueryString() != null) {
                originalURL += "?" + httpRequest.getQueryString();
            }
            
            // Create new session to store URL
            session = httpRequest.getSession(true);
            session.setAttribute("originalURL", originalURL);
            
            // Redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/userManagementModule/loginPage.jsp");
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("MoodAuthorizationFilter initialized");
    }
    
    @Override
    public void destroy() {
        logger.info("MoodAuthorizationFilter destroyed");
    }
}