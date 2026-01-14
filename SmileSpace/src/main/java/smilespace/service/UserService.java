package smilespace.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import smilespace.model.User;
import smilespace.dao.UserDAO;
import org.mindrot.jbcrypt.BCrypt;
import java.util.List;

@Service
public class UserService {
    
    @Autowired
    private UserDAO userDAO;
    
    public User authenticateUser(String username, String password) {
        System.out.println("DEBUG: Authenticating user: " + username);
        
        User user = userDAO.getUserByUsername(username);
        if (user == null) {
            System.out.println("DEBUG: User not found in database");
            return null;
        }
        
        System.out.println("DEBUG: User found: " + user.getFullName());
        
        try {
            if (BCrypt.checkpw(password, user.getPasswordHash())) {
                System.out.println("DEBUG: Password matches!");
                return user;
            } else {
                System.out.println("DEBUG: Password does NOT match");
                return null;
            }
        } catch (Exception e) {
            System.out.println("DEBUG: Error checking password: " + e.getMessage());
            return null;
        }
    }
    
    public boolean updateLastLogin(int userId) {
        return userDAO.updateLastLogin(userId);
    }
    
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }
    
    public User getUserByUsername(String username) {
        return userDAO.getUserByUsername(username);
    }
    
    public boolean createUser(User user) {
        String hashedPassword = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt());
        user.setPasswordHash(hashedPassword);
        return userDAO.createUser(user);
    }
    
    public boolean updateUser(User user) {
        return userDAO.updateUser(user);
    }
    
    public boolean checkUsernameExists(String username) {
        return userDAO.checkUsernameExists(username);
    }
    
    public boolean checkEmailExists(String email) {
        return userDAO.checkEmailExists(email);
    }
    
    public List<User> getAllStudents() {
        return userDAO.getUsersByRole("student");
    }
    
    public List<User> getUsersByRole(String role) {
        return userDAO.getUsersByRole(role);
    }
    
    public List<User> getAllFaculty() {
        return userDAO.getUsersByRole("faculty");
    }
    
    public List<User> getAllProfessionals() {
        return userDAO.getUsersByRole("professional");
    }
    
    public List<User> getAllAdmins() {
        return userDAO.getUsersByRole("admin");
    }
    
    public List<User> getActiveUsers() {
        return userDAO.getActiveUsers();
    }
    
    public boolean deactivateUser(int userId) {
        return userDAO.deactivateUser(userId);
    }
    
    public boolean activateUser(int userId) {
        return userDAO.activateUser(userId);
    }

    public boolean updatePassword(int userId, String newPassword) {
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        return userDAO.updatePassword(userId, hashedPassword);
    }
    
    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }

    public List<User> getAtRiskStudents() {
        return userDAO.getAtRiskStudents();
    }

    public User getAtRiskStudentById(int studentId) {
        return userDAO.getAtRiskStudentById(studentId);
    }
}