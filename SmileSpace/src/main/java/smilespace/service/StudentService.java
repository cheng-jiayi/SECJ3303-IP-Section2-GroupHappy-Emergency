package smilespace.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import smilespace.dao.StudentDAO;
import smilespace.model.Student;
import java.util.List;
import java.util.logging.Logger;

@Service
public class StudentService {
    
    @Autowired
    private StudentDAO studentDAO;
    
    private static final Logger logger = Logger.getLogger(StudentService.class.getName());
    
    public List<Student> getAtRiskStudents() {
        try {
            List<Student> students = studentDAO.getAtRiskStudents();
            logger.info("Retrieved " + students.size() + " at-risk students");
            return students;
        } catch (Exception e) {
            logger.severe("Error retrieving at-risk students: " + e.getMessage());
            return List.of();
        }
    }
    
    public Student getStudentById(String studentId) {
        if (studentId == null || studentId.trim().isEmpty()) {
            logger.warning("Student ID cannot be null or empty");
            return null;
        }
        
        try {
            Student student = studentDAO.getStudentById(studentId);
            if (student == null) {
                logger.warning("Student not found: " + studentId);
            } else {
                logger.info("Retrieved student: " + student.getFullName() + " (ID: " + studentId + ")");
            }
            return student;
        } catch (Exception e) {
            logger.severe("Error retrieving student by ID: " + e.getMessage());
            return null;
        }
    }
    
    public Student getStudentByUserId(int userId) {
        if (userId <= 0) {
            logger.warning("Invalid user ID: " + userId);
            return null;
        }
        
        try {
            Student student = studentDAO.getStudentByUserId(userId);
            if (student == null) {
                logger.warning("Student not found for user ID: " + userId);
            }
            return student;
        } catch (Exception e) {
            logger.severe("Error retrieving student by user ID: " + e.getMessage());
            return null;
        }
    }
}