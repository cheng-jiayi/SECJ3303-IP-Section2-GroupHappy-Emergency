CREATE TABLE counseling_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    counselor_id INT NULL,  -- Modified to allow NULL
    scheduled_datetime DATETIME NOT NULL,
    actual_datetime DATETIME,
    session_type VARCHAR(50) NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending Assignment',  -- Changed default status
    meeting_link VARCHAR(500),
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