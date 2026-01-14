-- Learning modules table
CREATE TABLE IF NOT EXISTS learning_modules (
    id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    level VARCHAR(20),
    author_name VARCHAR(100),
    estimated_duration VARCHAR(50),
    cover_image VARCHAR(255),
    resource_file VARCHAR(255),
    video_url VARCHAR(500),
    content_outline TEXT,
    learning_guide TEXT,
    learning_tip TEXT,
    key_points TEXT,
    views INT DEFAULT 0,
    last_updated DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS module_access_history (
    access_id INT AUTO_INCREMENT PRIMARY KEY,
    module_id VARCHAR(10),
    user_id INT,
    access_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    access_type VARCHAR(20) DEFAULT 'view',
    FOREIGN KEY (module_id) REFERENCES learning_modules(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Quiz Questions Table
CREATE TABLE IF NOT EXISTS quiz_questions (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    module_id VARCHAR(10) NOT NULL,
    question_text TEXT NOT NULL,
    correct_answer BOOLEAN NOT NULL, -- TRUE/FALSE questions
    explanation TEXT,
    question_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (module_id) REFERENCES learning_modules(id) ON DELETE CASCADE,
    INDEX idx_module_id (module_id)
);

-- Quiz Attempts Table
CREATE TABLE IF NOT EXISTS quiz_attempts (
    attempt_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    module_id VARCHAR(10) NOT NULL,
    score INT DEFAULT 0,
    total_questions INT DEFAULT 0,
    percentage INT DEFAULT 0,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    time_taken_seconds INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (module_id) REFERENCES learning_modules(id) ON DELETE CASCADE,
    INDEX idx_user_module (user_id, module_id)
);

-- Quiz Answers Table
CREATE TABLE IF NOT EXISTS quiz_answers (
    answer_id INT AUTO_INCREMENT PRIMARY KEY,
    attempt_id INT NOT NULL,
    question_id INT NOT NULL,
    user_answer BOOLEAN,
    is_correct BOOLEAN DEFAULT FALSE,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (attempt_id) REFERENCES quiz_attempts(attempt_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES quiz_questions(question_id) ON DELETE CASCADE,
    UNIQUE KEY unique_attempt_question (attempt_id, question_id)
);


INSERT INTO learning_modules (id, title, description, category, level, author_name, estimated_duration, video_url, content_outline, learning_guide, learning_tip, key_points, views, last_updated, created_by) VALUES
('LM001', 'Managing Stress in Daily Life', 'Learn how to identify sources of everyday stress and build healthy coping strategies to maintain balance between study, relationships, and rest.', 'Stress', 'Beginner', 'Dr Aisha', '8 minutes', 'https://www.youtube.com/watch?v=zYzFUBMJO9E', 
'Common daily stressors (academic, social, time pressure)$$Recognizing physical and emotional stress signals$$Simple relaxation techniques (breathing, music, short meditation)$$Three-Minute Relax Routine daily practice',
'Estimated time: 8 minutes$$Includes short video + interactive quiz$$Tip: Take short notes while learning and reflect at the end',
'Take short notes while learning and reflect at the end. This will help you retain information better and apply it to your daily life.',
'Identify common sources of daily stress in academic and personal life$$Recognize physical and emotional signals of stress before they become overwhelming$$Apply simple relaxation techniques like deep breathing and short meditation$$Develop a personalized "Three-Minute Relax Routine" for daily practice$$Build healthy coping strategies to maintain balance between study, relationships, and rest$$Create a sustainable stress management plan tailored to your lifestyle',
245, '2025-12-03', 3),

('LM002', 'Dealing with Academic Pressure', 'Learn strategies to manage exam stress, assignment overload, and academic competition effectively.', 'Stress', 'Intermediate', 'Dr Aisha', '10 minutes', 'https://www.youtube.com/watch?v=WPPPFqsECz0',
'Understanding academic pressure sources$$Time management strategies$$Coping with exam stress$$Building resilience',
'Estimated time: 10 minutes$$Includes practical exercises$$Apply techniques to your own schedule',
'Break large tasks into smaller, manageable steps and celebrate small victories along the way.',
'Understand different sources of academic pressure$$Develop effective time management strategies$$Learn exam preparation techniques$$Build resilience against academic setbacks$$Balance academic and personal life$$Seek support when needed',
189, '2025-12-01', 3),

('LM003', 'Understanding Anxiety Disorders', 'Learn about different types of anxiety disorders and their symptoms.', 'Anxiety', 'Beginner', 'Dr. Lisa Wong', '15 minutes', 'https://www.youtube.com/watch?v=dBTGxHtQ96g',
'Understanding different types of anxiety disorders$$Recognizing physical and psychological symptoms$$Common triggers and coping mechanisms$$When to seek professional help',
'Estimated time: 15 minutes$$Interactive content with self-assessment$$Practice exercises included throughout',
'Practice self-compassion and remember that anxiety is a normal human experience that can be managed.',
'Identify different types of anxiety disorders$$Recognize physical symptoms of anxiety$$Understand psychological aspects of anxiety$$Learn coping mechanisms for anxiety$$Know when to seek professional help$$Develop a personal anxiety management plan',
320, '2025-11-20', 3),

('LM004', 'Sleep Hygiene Fundamentals', 'Learn the basics of good sleep hygiene for better mental health.', 'Sleep', 'Beginner', 'Dr. Michael Chen', '12 minutes', 'https://www.youtube.com/watch?v=GqoWk6Jk6TE',
'Importance of sleep for mental health$$Creating an optimal sleep environment$$Sleep schedule and routine establishment$$Avoiding sleep disruptors',
'Estimated time: 12 minutes$$Sleep diary template provided$$Weekly practice assignments',
'Create a consistent bedtime routine and avoid screens at least 30 minutes before sleep.',
'Understand the importance of sleep for mental health$$Create an optimal sleep environment$$Establish consistent sleep schedules$$Identify and avoid sleep disruptors$$Practice relaxation techniques before bed$$Track sleep patterns for improvement',
278, '2025-11-15', 3),

('LM005', 'Building Self-Confidence', 'Exercises to build self-confidence and positive self-image.', 'Self-Esteem', 'Beginner', 'Dr. Robert Kim', '15 minutes', 'https://www.youtube.com/watch?v=8jPQjjsBbIc',
'Building self-confidence foundations$$Positive self-talk techniques$$Achievement recognition exercises$$Overcoming self-doubt',
'Estimated time: 15 minutes$$Daily affirmation practice$$Track your progress weekly',
'Start your day with positive affirmations and end it by noting three things you did well.',
'Understand the foundations of self-confidence$$Practice positive self-talk techniques$$Recognize and celebrate achievements$$Overcome self-doubt and negative thinking$$Set realistic personal goals$$Build a supportive social network',
210, '2025-11-18', 3);

-- Anxiety Category - Additional Module
INSERT INTO learning_modules (id, title, description, category, level, author_name, estimated_duration, video_url, content_outline, learning_guide, learning_tip, key_points, views, last_updated, created_by) VALUES
('LM006', 'Managing Panic Attacks', 'Learn techniques to manage and overcome panic attacks through breathing, grounding, and cognitive strategies.', 'Anxiety', 'Intermediate', 'Dr. Emily Zhang', '14 minutes', 'https://www.youtube.com/watch?v=YpMnXGti_Ko',
'Understanding panic attack symptoms$$Breathing techniques for panic control$$Grounding exercises for immediate relief$$Cognitive restructuring methods$$Long-term prevention strategies$$When to seek emergency help',
'Estimated time: 14 minutes$$Practice exercises included after each section$$Keep a panic attack diary$$Work with a support partner',
'Keep a "panic first aid kit" with grounding objects, breathing reminders, and comforting items in your bag.',
'Recognize early signs of panic attacks$$Master 4-7-8 breathing technique$$Practice 5-4-3-2-1 grounding exercise$$Challenge catastrophic thinking patterns$$Develop a personalized prevention plan$$Create a support network for emergencies',
187, '2025-11-25', 3);

-- Sleep Category - Additional Module
INSERT INTO learning_modules (id, title, description, category, level, author_name, estimated_duration, video_url, content_outline, learning_guide, learning_tip, key_points, views, last_updated, created_by) VALUES
('LM007', 'Overcoming Insomnia', 'Cognitive Behavioral Therapy for Insomnia (CBT-I) techniques to improve sleep quality and duration.', 'Sleep', 'Intermediate', 'Dr. James Wilson', '20 minutes', 'https://www.youtube.com/watch?v=4qBEyRqg-aA',
'Understanding insomnia types$$Stimulus control therapy$$Sleep restriction techniques$$Cognitive restructuring for sleep anxiety$$Relaxation training$$Sleep scheduling methods',
'Estimated time: 20 minutes$$Keep a 2-week sleep diary$$Practice techniques consistently$$Work with sleep coach if needed',
'Use the bed only for sleep and intimacy - avoid working, eating, or watching TV in bed.',
'Differentiate between acute and chronic insomnia$$Master stimulus control techniques$$Implement sleep restriction effectively$$Challenge sleep-related anxiety$$Practice progressive muscle relaxation$$Create optimal sleep schedule',
198, '2025-11-22', 3);

-- Self-Esteem Category - Additional Module
INSERT INTO learning_modules (id, title, description, category, level, author_name, estimated_duration, video_url, content_outline, learning_guide, learning_tip, key_points, views, last_updated, created_by) VALUES
('LM008', 'Overcoming Imposter Syndrome', 'Strategies to recognize and overcome imposter syndrome in academic and professional settings.', 'Self-Esteem', 'Intermediate', 'Dr. Maria Garcia', '17 minutes', 'https://www.youtube.com/watch?v=eqhUHyVpAwE',
'Understanding imposter syndrome$$Recognizing personal patterns$$Cognitive restructuring techniques$$Evidence collection methods$$External validation strategies$$Building authentic confidence',
'Estimated time: 17 minutes$$Keep an achievement log$$Challenge negative thoughts daily$$Seek feedback regularly',
'Create an "evidence file" of your accomplishments, positive feedback, and skills to review when doubting yourself.',
'Identify personal imposter syndrome patterns$$Challenge perfectionistic thinking$$Collect objective evidence of competence$$Seek and internalize positive feedback$$Develop realistic self-assessment skills$$Build sustainable authentic confidence',
167, '2025-11-27', 3);

-- Mindfulness Category - Additional Module
INSERT INTO learning_modules (id, title, description, category, level, author_name, estimated_duration, video_url, content_outline, learning_guide, learning_tip, key_points, views, last_updated, created_by) VALUES
('LM009', 'Mindful Breathing Techniques', 'Learn various mindful breathing techniques for stress reduction, focus improvement, and emotional regulation.', 'Mindfulness', 'Beginner', 'Prof. Amanda Lee', '12 minutes', 'https://www.youtube.com/watch?v=SEfs5TJZ6Nk',
'Introduction to mindful breathing$$4-7-8 breathing technique$$Box breathing method$$Counting breath practice$$Body scan with breathing$$Daily integration techniques',
'Estimated time: 12 minutes$$Practice 5 minutes daily$$Use reminder cues$$Track practice consistency',
'Set phone reminders for brief breathing breaks throughout the day - even one minute makes a difference.',
'Understand benefits of mindful breathing$$Master 4-7-8 breathing for relaxation$$Practice box breathing for focus$$Use counting breath for anxiety$$Integrate breathing with body awareness$$Establish daily breathing routine',
189, '2025-11-29', 3);


INSERT INTO quiz_questions (module_id, question_text, correct_answer, explanation, question_order) VALUES
('LM001', 'Stress is always harmful and should be avoided completely.', FALSE, 'Some stress can be motivating (eustress). It''s about managing stress, not eliminating it completely.', 1),
('LM001', 'Deep breathing exercises can help reduce stress immediately.', TRUE, 'Deep breathing activates the parasympathetic nervous system, helping you relax.', 2),
('LM001', 'Physical exercise has no effect on stress levels.', FALSE, 'Exercise releases endorphins and reduces stress hormones.', 3),
('LM001', 'Time management can help reduce academic stress.', TRUE, 'Proper time management reduces last-minute pressure and anxiety.', 4),
('LM001', 'All stress comes from external factors only.', FALSE, 'Stress can come from both external factors and internal thoughts/perceptions.', 5),
('LM001', 'Taking regular breaks during study sessions can improve focus and reduce stress.', TRUE, 'Short breaks help prevent burnout and maintain productivity.', 6),
('LM001', 'Caffeine helps reduce stress in the long term.', FALSE, 'Caffeine can increase anxiety and stress responses.', 7),
('LM001', 'Mindfulness meditation has been proven to reduce stress levels.', TRUE, 'Studies show mindfulness reduces cortisol (stress hormone) levels.', 8),
('LM001', 'Stress affects only mental health, not physical health.', FALSE, 'Stress can cause headaches, digestive issues, and weaken immune system.', 9),
('LM001', 'Talking to friends about stressors can make stress worse.', FALSE, 'Social support is a key factor in stress management.', 10);



-- Anxiety Category Quiz Questions
INSERT INTO quiz_questions (module_id, question_text, correct_answer, question_order) VALUES
('LM006', 'Panic attacks typically last several hours.', FALSE, 1),
('LM006', 'Breathing techniques can help reduce panic attack intensity.', TRUE, 2),
('LM006', 'Grounding exercises involve focusing on your immediate environment.', TRUE, 3),
('LM006', 'Panic attacks are always caused by underlying medical conditions.', FALSE, 4),
('LM006', 'Progressive exposure to panic triggers can reduce future attacks.', TRUE, 5),
('LM006', 'Caffeine consumption has no effect on panic attacks.', FALSE, 6),
('LM006', 'Keeping a panic attack diary can help identify patterns.', TRUE, 7),
('LM006', 'Panic attacks are a sign of personal weakness.', FALSE, 8),
('LM006', 'Regular exercise can help prevent panic attacks.', TRUE, 9),
('LM006', 'Panic attacks can be completely prevented with medication alone.', FALSE, 10);

-- Sleep Category Quiz Questions
INSERT INTO quiz_questions (module_id, question_text, correct_answer, question_order) VALUES
('LM007', 'Insomnia is defined as difficulty falling or staying asleep.', TRUE, 1),
('LM007', 'Stimulus control therapy involves using the bed only for sleep.', TRUE, 2),
('LM007', 'Sleep restriction initially reduces total sleep time to improve sleep efficiency.', TRUE, 3),
('LM007', 'Watching TV in bed helps with insomnia.', FALSE, 4),
('LM007', 'Cognitive restructuring addresses sleep-related anxiety.', TRUE, 5),
('LM007', 'Progressive muscle relaxation can help with sleep onset.', TRUE, 6),
('LM007', 'Napping during the day improves nighttime sleep for insomniacs.', FALSE, 7),
('LM007', 'Keeping a consistent sleep schedule helps regulate circadian rhythms.', TRUE, 8),
('LM007', 'Alcohol is an effective long-term solution for insomnia.', FALSE, 9),
('LM007', 'CBT-I is considered the gold standard for insomnia treatment.', TRUE, 10);

-- Self-Esteem Category Quiz Questions
INSERT INTO quiz_questions (module_id, question_text, correct_answer, question_order) VALUES
('LM008', 'Imposter syndrome involves feeling like a fraud despite evidence of competence.', TRUE, 1),
('LM008', 'Perfectionism is often associated with imposter syndrome.', TRUE, 2),
('LM008', 'External validation alone can cure imposter syndrome.', FALSE, 3),
('LM008', 'Keeping an achievement log can help combat imposter feelings.', TRUE, 4),
('LM008', 'Imposter syndrome only affects people in high-powered careers.', FALSE, 5),
('LM008', 'Cognitive restructuring can help change imposter-related thoughts.', TRUE, 6),
('LM008', 'Imposter syndrome is a formal mental health diagnosis.', FALSE, 7),
('LM008', 'Sharing feelings with trusted others can reduce imposter syndrome.', TRUE, 8),
('LM008', 'Setting realistic goals can help manage imposter syndrome.', TRUE, 9),
('LM008', 'Imposter syndrome typically goes away completely after one success.', FALSE, 10);

-- Mindfulness Category Quiz Questions
INSERT INTO quiz_questions (module_id, question_text, correct_answer, question_order) VALUES
('LM009', 'Mindful breathing can help reduce stress and anxiety.', TRUE, 1),
('LM009', 'The 4-7-8 breathing technique involves inhaling for 4 seconds.', TRUE, 2),
('LM009', 'Box breathing involves equal inhale, hold, exhale, and pause durations.', TRUE, 3),
('LM009', 'Mindful breathing should only be practiced in quiet environments.', FALSE, 4),
('LM009', 'Counting breaths can help maintain focus during meditation.', TRUE, 5),
('LM009', 'Mindful breathing has no effect on physical health.', FALSE, 6),
('LM009', 'Regular practice improves the benefits of mindful breathing.', TRUE, 7),
('LM009', 'Mindful breathing can be integrated into daily activities.', TRUE, 8),
('LM009', 'Breathing techniques should always be practiced for at least 30 minutes.', FALSE, 9),
('LM009', 'Body scan meditation can be combined with mindful breathing.', TRUE, 10);

SELECT * FROM quiz_attempts;
SELECT * FROM quiz_answers;
SELECT * FROM learning_modules;
