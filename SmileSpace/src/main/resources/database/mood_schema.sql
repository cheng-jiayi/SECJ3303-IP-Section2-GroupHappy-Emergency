-- Create database
CREATE DATABASE IF NOT EXISTS smilespace;
USE smilespace;

-- Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    user_role ENUM('student', 'faculty', 'admin', 'professional') NOT NULL,
    phone VARCHAR(20),
    matric_number VARCHAR(20),
    program VARCHAR(100),
    year INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Mood entries table
CREATE TABLE mood_entries (
    entry_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    entry_date DATE NOT NULL,
    reflection TEXT,
    image_path VARCHAR(255),
    tags TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_date (user_id, entry_date)
);

-- Mood feelings table
CREATE TABLE mood_feelings (
    entry_id INT NOT NULL,
    feeling_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (entry_id, feeling_name),
    FOREIGN KEY (entry_id) REFERENCES mood_entries(entry_id) ON DELETE CASCADE
);


-- Insert sample data
-- Note: Password hash is for 'password123' (bcrypt)
-- Insert sample data with CORRECT BCrypt hashes
-- Password: 'password123'
INSERT INTO users (username, email, password_hash, full_name, user_role, matric_number, program, year, phone) VALUES
('student1', 'student1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Ali bin Ahmad', 'student', 'A123456', 'Computer Science', 2, '012-3456789'),
('student2', 'student2@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Siti binti Mohd', 'student', 'B234567', 'Psychology', 3, '013-4567890'),
('student3', 'student3@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Ahmad bin Ismail', 'student', 'C345678', 'Engineering', 1, '014-5678901'),
('faculty1', 'faculty1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. John Smith', 'faculty', NULL, NULL, NULL, '011-1111111'),
('mhp1', 'mhp1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. Sarah Johnson', 'professional', NULL, NULL, NULL, '012-2222222');

-- Insert sample mood entries
INSERT INTO mood_entries (user_id, entry_date, reflection, tags) VALUES
(1, CURDATE() - INTERVAL 1 DAY, 'Feeling good about my project progress', 'productive,good_day'),
(1, CURDATE() - INTERVAL 2 DAY, 'A bit stressed about upcoming exams', 'exam_stress,anxious'),
(1, CURDATE() - INTERVAL 3 DAY, 'Feeling lonely today', 'lonely,sad'),
(1, CURDATE() - INTERVAL 4 DAY, 'Overwhelmed with assignments','stressed'),
(2, CURDATE() - INTERVAL 1 DAY, 'Enjoying my coursework this week', 'motivated,happy'),
(2, CURDATE() - INTERVAL 3 DAY, 'Feeling overwhelmed with assignments', 'overwhelmed,stressed,assignment_due'),
(3, CURDATE() - INTERVAL 2 DAY, 'Everything is going well', 'happy,content'),
(3, CURDATE() - INTERVAL 5 DAY, 'Missing home', 'homesick,sad');

-- Insert sample mood feelings
INSERT INTO mood_feelings (entry_id, feeling_name) VALUES
(1, 'happy'), (1, 'relaxed'),
(2, 'stressed'), (2, 'anxious'),
(3, 'sad'),
(4, 'stressed'),
(5, 'happy'), (5, 'excited'),
(6, 'stressed'), 
(7, 'happy'),
(8, 'sad');

CREATE TABLE mood_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    action_type VARCHAR(20) NOT NULL,
    entry_id INT,
    action_details TEXT,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_entry_id (entry_id)
);
