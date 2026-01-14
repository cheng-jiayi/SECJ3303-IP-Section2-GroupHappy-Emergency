package smilespace.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;

@Controller
@RequestMapping("/logout")
public class LogoutController {
    
    @GetMapping
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        
        // Invalidate session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Clear cookies
        clearCookies(request, response);
        
        // Redirect to login page
        return "redirect:/login?logout=success";
    }
    
    private void clearCookies(HttpServletRequest request, HttpServletResponse response) {
        // Clear JSESSIONID cookie
        Cookie cookie = new Cookie("JSESSIONID", "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}