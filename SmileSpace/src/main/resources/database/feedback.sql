-- Feedback Module Tables
USE smilespace;

-- Feedback table
CREATE TABLE IF NOT EXISTS feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    name VARCHAR(100),
    email VARCHAR(100),
    message TEXT NOT NULL,
    category VARCHAR(50) DEFAULT 'General',
    sentiment VARCHAR(20) DEFAULT 'Neutral',
    is_resolved BOOLEAN DEFAULT FALSE,
    reply_message TEXT,
    reply_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Feedback analytics views/stats table
CREATE TABLE IF NOT EXISTS feedback_analytics (
    analytics_date DATE PRIMARY KEY,
    total_feedback INT DEFAULT 0,
    positive_count INT DEFAULT 0,
    neutral_count INT DEFAULT 0,
    negative_count INT DEFAULT 0,
    resolved_count INT DEFAULT 0,
    pending_count INT DEFAULT 0
);

-- Feedback history for reporting
CREATE TABLE IF NOT EXISTS feedback_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    feedback_id INT,
    user_id INT,
    action_type VARCHAR(20) NOT NULL, -- CREATE, UPDATE, REPLY, RESOLVE
    action_details TEXT,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (feedback_id) REFERENCES feedback(feedback_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Insert sample feedback data
INSERT INTO feedback (user_id, name, email, message, category, sentiment, created_at) VALUES
(1, 'Ali bin Ahmad', 'student1@email.com', 'The platform is really helpful! I appreciate the detailed assessment results and the resources provided. It helped me understand my mental health better.', 'Assessment Experience', 'Positive', '2024-12-01 10:30:00'),
(2, 'Siti binti Mohd', 'student2@email.com', 'The platform works well but can be a little slow at times.', 'User Experience', 'Neutral', '2024-12-02 14:15:00'),
(3, 'Ahmad bin Ismail', 'student3@email.com', 'I found a bug in the mood tracker where it doesnt save my entries properly.', 'Technical Issues', 'Negative', '2024-12-03 09:45:00'),
(1, 'Ali bin Ahmad', 'student1@email.com', 'Great new features! The learning modules are very useful.', 'Features', 'Positive', '2024-12-04 16:20:00'),
(2, NULL, NULL, 'Can we have more customization options for the dashboard?', 'Suggestions', 'Neutral', '2024-12-05 11:10:00');

-- Create indexes for better performance
CREATE INDEX idx_feedback_user ON feedback(user_id);
CREATE INDEX idx_feedback_sentiment ON feedback(sentiment);
CREATE INDEX idx_feedback_resolved ON feedback(is_resolved);
CREATE INDEX idx_feedback_category ON feedback(category);
CREATE INDEX idx_feedback_created ON feedback(created_at);

ALTER TABLE feedback ADD COLUMN rating INT NULL AFTER sentiment;

INSERT INTO users (username, email, password_hash, full_name, user_role, matric_number, program, year, phone) VALUES
('admin1', 'admin1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. Nurain Shafikah', 'admin', NULL, NULL, NULL, '011-3333333');

