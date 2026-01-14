-- First, cancel any pending multi-line input
\c

-- Clear the database and start fresh
DROP DATABASE IF EXISTS smilespace;
CREATE DATABASE smilespace;
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
    faculty VARCHAR(100),
    year INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    risk_level ENUM('HIGH', 'MEDIUM', 'LOW') DEFAULT 'LOW',
    recent_mood VARCHAR(100),
    mood_stability DECIMAL(5,2) DEFAULT 0.0,
    frequent_tags VARCHAR(255),
    assessment_category VARCHAR(100)
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

-- Mood history table
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

-- Counseling sessions table
CREATE TABLE counseling_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    counselor_id INT NULL,
    scheduled_datetime DATETIME NOT NULL,
    actual_datetime DATETIME,
    session_type VARCHAR(50) NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending Assignment',
    meeting_link VARCHAR(500),
    location VARCHAR(200),
    current_mood TEXT,
    reason TEXT NOT NULL,
    additional_notes TEXT,
    follow_up_method VARCHAR(50),
    session_summary TEXT,
    observed_mood VARCHAR(100),
    progress_notes TEXT,
    follow_up_actions TEXT,
    attachment_path VARCHAR(500),
    student_feedback TEXT,
    rating INT,
    next_session_suggested DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (counselor_id) REFERENCES users(user_id)
);

-- Referrals table (faculty to MHP)
CREATE TABLE referrals (
    referral_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    faculty_id INT NOT NULL,
    reason VARCHAR(255) NOT NULL,
    urgency ENUM('HIGH', 'MEDIUM', 'LOW') NOT NULL,
    notes TEXT,
    referral_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'ACCEPTED', 'REJECTED', 'COMPLETED') DEFAULT 'PENDING',
    counselor_id INT NULL,
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (faculty_id) REFERENCES users(user_id),
    FOREIGN KEY (counselor_id) REFERENCES users(user_id)
);

-- Professionals table for MHP details
CREATE TABLE professionals (
    professional_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    specialization VARCHAR(100),
    experience_years INT,
    qualifications TEXT,
    bio TEXT,
    office_hours TEXT,
    max_sessions_per_week INT DEFAULT 20,
    current_sessions_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- NOW INSERT USERS (This must come AFTER table creation)
-- Password: 'password123' (bcrypt hash)
INSERT INTO users (username, email, password_hash, full_name, user_role, matric_number, faculty, year, phone, risk_level, recent_mood, mood_stability, frequent_tags, assessment_category) VALUES
-- Students with risk data
('student1', 'student1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Ali bin Ahmad', 'student', 'A123456', 'Faculty of Computing', 2, '012-3456789', 'HIGH', 'Anxious', 35.5, 'stress,anxious,overwhelmed', 'Needs Immediate Support'),
('student2', 'student2@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Siti binti Mohd', 'student', 'B234567', 'Faculty of Computing', 3, '013-4567890', 'MEDIUM', 'Stressed', 65.2, 'assignment_due,stressed', 'Monitor Closely'),
('student3', 'student3@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Ahmad bin Ismail', 'student', 'C345678', 'Faculty of Computing', 1, '014-5678901', 'LOW', 'Happy', 85.7, 'happy,content', 'Doing Well'),
('student4', 'student4@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Fatimah binti Ali', 'student', 'D456789', 'Faculty of Engineering', 2, '015-6789012', 'HIGH', 'Depressed', 25.8, 'lonely,depressed,withdrawn', 'High Risk - Immediate Attention'),
('student5', 'student5@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Rajesh Kumar', 'student', 'E567890', 'Faculty of Business', 3, '016-7890123', 'MEDIUM', 'Overwhelmed', 55.3, 'overwhelmed,assignment_due', 'Needs Support'),

-- Faculty
('faculty1', 'faculty1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. John Smith', 'faculty', NULL, 'Faculty of Computing', NULL, '011-1111111', NULL, NULL, NULL, NULL, NULL),
('faculty2', 'faculty2@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Prof. Sarah Lee', 'faculty', NULL, 'Faculty of Engineering', NULL, '012-2222222', NULL, NULL, NULL, NULL, NULL),

-- Mental Health Professionals
('mhp1', 'mhp1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. Sarah Johnson', 'professional', NULL, NULL, NULL, '013-3333333', NULL, NULL, NULL, NULL, NULL),
('mhp2', 'mhp2@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. Michael Chen', 'professional', NULL, NULL, NULL, '014-4444444', NULL, NULL, NULL, NULL, NULL),

-- Admin
('admin1', 'admin1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. Nurain Shafikah', 'admin', NULL, NULL, NULL, '011-3333333', NULL, NULL, NULL, NULL, NULL);

-- Insert professional details
-- Note: user_id values are based on the order they were inserted
INSERT INTO professionals (user_id, specialization, experience_years, qualifications, bio, office_hours, max_sessions_per_week) VALUES
(9, 'Anxiety & Depression, Student Counseling', 8, 'PhD in Clinical Psychology, Licensed Professional Counselor', 'Specializes in working with university students dealing with academic stress, anxiety, and depression.', 'Mon-Fri: 9am-5pm', 25),
(10, 'Crisis Intervention, Cognitive Behavioral Therapy', 12, 'MA in Counseling Psychology, Certified Crisis Counselor', 'Experienced in crisis intervention and helping students through difficult transitions.', 'Tue-Thu: 10am-6pm', 20);

-- Insert sample mood entries
INSERT INTO mood_entries (user_id, entry_date, reflection, tags) VALUES
(1, CURDATE() - INTERVAL 1 DAY, 'Feeling anxious about final exams. Cant sleep well.', 'anxious,exam_stress,sleep_issues'),
(1, CURDATE() - INTERVAL 2 DAY, 'Still feeling overwhelmed with assignments', 'overwhelmed,stressed'),
(1, CURDATE() - INTERVAL 3 DAY, 'Feeling lonely in hostel. Missing family.', 'lonely,homesick,sad'),
(2, CURDATE() - INTERVAL 1 DAY, 'Managing stress better today. Used breathing exercises.', 'stress_management,better_day'),
(2, CURDATE() - INTERVAL 2 DAY, 'Project deadline approaching. Feeling pressure.', 'project_deadline,pressure'),
(3, CURDATE() - INTERVAL 1 DAY, 'Enjoying my classes. Made new friends.', 'happy,social,engaged'),
(4, CURDATE() - INTERVAL 1 DAY, 'Feeling very low today. Dont want to get out of bed.', 'depressed,low_energy'),
(4, CURDATE() - INTERVAL 2 DAY, 'Skipped classes again. Cant focus on anything.', 'withdrawn,no_motivation'),
(5, CURDATE() - INTERVAL 1 DAY, 'Too many assignments due this week. Overwhelmed.', 'overwhelmed,assignment_due');

-- Insert sample mood feelings
INSERT INTO mood_feelings (entry_id, feeling_name) VALUES
(1, 'anxious'), (1, 'stressed'),
(2, 'overwhelmed'), (2, 'stressed'),
(3, 'sad'), (3, 'lonely'),
(4, 'calm'), (4, 'hopeful'),
(5, 'stressed'), (5, 'anxious'),
(6, 'happy'), (6, 'excited'),
(7, 'sad'), (7, 'depressed'),
(8, 'tired'), (8, 'hopeless'),
(9, 'overwhelmed'), (9, 'anxious');

-- Insert sample counseling sessions
INSERT INTO counseling_sessions (student_id, counselor_id, scheduled_datetime, session_type, status, current_mood, reason, follow_up_method) VALUES
(1, NULL, DATE_ADD(NOW(), INTERVAL 2 DAY), 'Individual Therapy', 'Pending Assignment', 'Anxious', 'Exam anxiety affecting sleep and studies', 'Email'),
(2, NULL, DATE_ADD(NOW(), INTERVAL 3 DAY), 'Stress Management', 'Pending Assignment', 'Stressed', 'Overwhelmed with multiple assignments', 'WhatsApp'),
(4, NULL, DATE_ADD(NOW(), INTERVAL 1 DAY), 'Crisis Intervention', 'Pending Assignment', 'Depressed', 'Severe depression, withdrawn from social activities', 'Email'),
(1, 9, DATE_ADD(NOW(), INTERVAL 5 DAY), 'Follow-up Session', 'Scheduled', 'Anxious', 'Follow-up on previous anxiety issues', 'Email'),
(2, 10, DATE_ADD(NOW(), INTERVAL 4 DAY), 'Initial Assessment', 'Scheduled', 'Stressed', 'Academic stress management', 'WhatsApp');

-- Insert sample referrals from faculty to MHP
INSERT INTO referrals (student_id, faculty_id, reason, urgency, notes, referral_date, status) VALUES
(1, 6, 'Academic Stress & Anxiety', 'HIGH', 'Student shows signs of severe anxiety affecting academic performance. Has missed multiple classes.', NOW() - INTERVAL 2 DAY, 'PENDING'),
(4, 7, 'Depression Signs', 'HIGH', 'Student appears withdrawn, shows signs of depression. Expressed feelings of hopelessness.', NOW() - INTERVAL 1 DAY, 'PENDING'),
(2, 6, 'Academic Pressure', 'MEDIUM', 'Student struggling with workload management. Shows signs of stress.', NOW() - INTERVAL 3 DAY, 'PENDING'),
(5, 7, 'Overwhelmed with Studies', 'MEDIUM', 'Student expressed feeling overwhelmed with multiple deadlines.', NOW(), 'PENDING');

-- Insert a completed referral (accepted by MHP)
INSERT INTO referrals (student_id, faculty_id, reason, urgency, notes, referral_date, status, counselor_id) VALUES
(1, 6, 'Severe Anxiety', 'HIGH', 'Immediate attention needed', NOW() - INTERVAL 5 DAY, 'ACCEPTED', 9);

-- Continue with the rest of your indexes, views, stored procedures, and triggers...
-- Create indexes for performance
CREATE INDEX idx_users_role ON users(user_role);
CREATE INDEX idx_users_risk ON users(risk_level);
CREATE INDEX idx_sessions_status ON counseling_sessions(status);
CREATE INDEX idx_sessions_counselor ON counseling_sessions(counselor_id);
CREATE INDEX idx_sessions_student ON counseling_sessions(student_id);
CREATE INDEX idx_referrals_status ON referrals(status);
CREATE INDEX idx_referrals_student ON referrals(student_id);
CREATE INDEX idx_referrals_counselor ON referrals(counselor_id);
CREATE INDEX idx_mood_user_date ON mood_entries(user_id, entry_date);

-- Create view for at-risk students
CREATE VIEW at_risk_students AS
SELECT 
    u.user_id as student_id,
    u.full_name as name,
    u.matric_number,
    u.recent_mood,
    u.risk_level,
    u.frequent_tags,
    u.mood_stability,
    u.phone,
    u.email,
    u.faculty as program_year,
    u.assessment_category,
    CASE 
        WHEN u.mood_stability >= 80 THEN 'Very Stable'
        WHEN u.mood_stability >= 60 THEN 'Moderately Stable'
        WHEN u.mood_stability >= 40 THEN 'Somewhat Unstable'
        ELSE 'Very Unstable'
    END as mood_stability_text
FROM users u
WHERE u.user_role = 'student' 
AND u.risk_level IN ('HIGH', 'MEDIUM')
ORDER BY 
    CASE u.risk_level 
        WHEN 'HIGH' THEN 1
        WHEN 'MEDIUM' THEN 2
        WHEN 'LOW' THEN 3
    END,
    u.mood_stability ASC;

-- Create view for MHP dashboard
CREATE VIEW mhp_dashboard AS
SELECT 
    'SESSION' as item_type,
    s.session_id as id,
    s.student_id,
    u.full_name as student_name,
    u.email as student_email,
    s.scheduled_datetime,
    s.session_type,
    s.current_mood,
    s.reason,
    s.status,
    NULL as urgency,
    NULL as faculty_name
FROM counseling_sessions s
JOIN users u ON s.student_id = u.user_id
WHERE s.status = 'Pending Assignment'

UNION ALL

SELECT 
    'REFERRAL' as item_type,
    r.referral_id as id,
    r.student_id,
    u.full_name as student_name,
    u.email as student_email,
    r.referral_date as scheduled_datetime,
    'Referral from Faculty' as session_type,
    NULL as current_mood,
    r.reason,
    r.status,
    r.urgency,
    f.full_name as faculty_name
FROM referrals r
JOIN users u ON r.student_id = u.user_id
JOIN users f ON r.faculty_id = f.user_id
WHERE r.status = 'PENDING'
ORDER BY 
    CASE 
        WHEN item_type = 'REFERRAL' AND urgency = 'HIGH' THEN 1
        WHEN item_type = 'SESSION' THEN 2
        WHEN item_type = 'REFERRAL' AND urgency = 'MEDIUM' THEN 3
        ELSE 4
    END,
    scheduled_datetime ASC;

-- Stored procedure for accepting referrals
DELIMITER $$
CREATE PROCEDURE AcceptReferral(IN p_referral_id INT, IN p_counselor_id INT)
BEGIN
    DECLARE v_student_id INT;
    
    -- Get student ID from referral
    SELECT student_id INTO v_student_id 
    FROM referrals 
    WHERE referral_id = p_referral_id AND status = 'PENDING';
    
    IF v_student_id IS NOT NULL THEN
        -- Update referral status
        UPDATE referrals 
        SET status = 'ACCEPTED', counselor_id = p_counselor_id
        WHERE referral_id = p_referral_id;
        
        -- Create a counseling session from the referral
        INSERT INTO counseling_sessions (student_id, counselor_id, scheduled_datetime, session_type, status, reason, follow_up_method)
        SELECT 
            r.student_id,
            p_counselor_id,
            DATE_ADD(NOW(), INTERVAL 3 DAY), -- Schedule for 3 days from now
            'Initial Assessment',
            'Scheduled',
            CONCAT('Referral: ', r.reason),
            'Email'
        FROM referrals r
        WHERE r.referral_id = p_referral_id;
    END IF;
END$$
DELIMITER ;

-- Trigger to update risk level based on mood stability
DELIMITER $$
CREATE TRIGGER update_student_risk_level
AFTER INSERT ON mood_entries
FOR EACH ROW
BEGIN
    DECLARE avg_mood_stability DECIMAL(5,2);
    DECLARE new_risk_level VARCHAR(10);
    
    -- Calculate average mood stability for this student (last 30 days)
    SELECT AVG(
        CASE 
            WHEN LOWER(tags) LIKE '%happy%' OR LOWER(tags) LIKE '%content%' OR LOWER(tags) LIKE '%calm%' THEN 80
            WHEN LOWER(tags) LIKE '%stressed%' OR LOWER(tags) LIKE '%anxious%' THEN 50
            WHEN LOWER(tags) LIKE '%sad%' OR LOWER(tags) LIKE '%depressed%' OR LOWER(tags) LIKE '%lonely%' THEN 30
            ELSE 60
        END
    ) INTO avg_mood_stability
    FROM mood_entries 
    WHERE user_id = NEW.user_id 
    AND entry_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);
    
    -- Set risk level based on mood stability
    IF avg_mood_stability < 40 THEN
        SET new_risk_level = 'HIGH';
    ELSEIF avg_mood_stability < 65 THEN
        SET new_risk_level = 'MEDIUM';
    ELSE
        SET new_risk_level = 'LOW';
    END IF;
    
    -- Update user's risk level and mood stability
    UPDATE users 
    SET risk_level = new_risk_level, 
        mood_stability = COALESCE(avg_mood_stability, 0.0),
        recent_mood = (
            SELECT GROUP_CONCAT(DISTINCT mf.feeling_name ORDER BY mf.feeling_name SEPARATOR ', ')
            FROM mood_feelings mf
            JOIN mood_entries me ON mf.entry_id = me.entry_id
            WHERE me.user_id = NEW.user_id
            AND me.entry_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
            LIMIT 5
        ),
        frequent_tags = (
            SELECT GROUP_CONCAT(DISTINCT SUBSTRING_INDEX(SUBSTRING_INDEX(me.tags, ',', n.n), ',', -1) SEPARATOR ', ')
            FROM mood_entries me
            CROSS JOIN (
                SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            ) n
            WHERE me.user_id = NEW.user_id
            AND me.entry_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
            AND LENGTH(me.tags) - LENGTH(REPLACE(me.tags, ',', '')) >= n.n - 1
            GROUP BY me.user_id
        )
    WHERE user_id = NEW.user_id;
END$$
DELIMITER ;