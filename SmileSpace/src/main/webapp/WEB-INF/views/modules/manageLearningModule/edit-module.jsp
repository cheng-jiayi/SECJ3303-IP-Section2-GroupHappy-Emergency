<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
    String category = module.getCategory();
    String level = module.getLevel();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Learning Module</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Fredoka', sans-serif; 
        }
        
        body { 
            background: #FBF6EA; 
            color: #713C0B; 
            min-height: 100vh;
        }
        
        /* Top Navigation */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 30px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
            justify-content: flex-end;
            margin-left: auto; 
        }
        
        .logo i {
            color: #F0A548;
            font-size: 22px;
        }
        
        .container { 
            max-width: 1200px; 
            margin: 20px auto;
            padding: 0 15px;
        }
        
        /* Page Title */
        .page-title {
            text-align: left;
            margin: 20px 0 30px 0;
        }
        
        .page-title h1 {
            font-size: 36px;
            font-weight: 700;
            color: #F0A548;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }
        
        .page-title p {
            font-size: 16px;
            color: #713C0B;
            opacity: 0.9;
        }
        
        /* Content */
        .content { 
            background: white; 
            border-radius: 20px; 
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 2px solid #F0D5B8;
            margin-top: 10px;
        }
        
        /* Module ID Display */
        .module-id-display {
            background: #F4DBAF;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 600;
            color: #713C0B;
            border: 2px solid #713C0B;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .module-id-display i {
            color: #F0A548;
        }
        
        /* Back Link */
        .back-link { 
            display: inline-flex; 
            align-items: center; 
            gap: 8px;
            margin-bottom: 25px; 
            color: #713C0B; 
            text-decoration: none; 
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 8px;
            background: #F4DBAF;
            border: 2px solid #713C0B;
            transition: all 0.3s;
        }
        
        .back-link:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateX(-3px);
        }
        
        /* Form Layout */
        .form-layout {
            display: grid;
            grid-template-columns: 1fr 2fr; 
            gap: 30px;
        }

        @media (max-width: 900px) {
            .form-layout {
                grid-template-columns: 1fr;
            }
        }
        
        /* Left Column - Cover, Category, Learning Level */
        .left-column {
            background: #FFF9F0;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            display: flex;
            flex-direction: column;
            gap: 25px;
        }
        
        /* Right Column - Other Form Fields */
        .right-column {
            background: #FFF9F0;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            display: flex;
            flex-direction: column;
            gap: 25px;
        }
        
        /* Form Groups */
        .form-group { 
            width: 100%;
        }
        
        .form-label { 
            display: block; 
            margin-bottom: 10px; 
            font-weight: 600; 
            color: #713C0B;
            font-size: 16px;
        }
        
        .required::after { 
            content: " *"; 
            color: #FF4757; 
        }
        
        .form-input, .form-textarea, .form-select { 
            width: 100%; 
            padding: 14px 18px; 
            border: 2px solid #F0D5B8; 
            border-radius: 12px; 
            font-size: 15px;
            background: #FBF6EA;
            color: #713C0B;
            transition: all 0.3s;
        }
        
        .form-input:focus, .form-textarea:focus, .form-select:focus { 
            outline: none; 
            border-color: #F0A548; 
            box-shadow: 0 0 0 3px rgba(240, 165, 72, 0.2); 
            background: white;
        }
        
        .form-input::placeholder, .form-textarea::placeholder {
            color: #C7A178;
        }
        
        .form-textarea { 
            min-height: 120px; 
            resize: vertical; 
        }
        
        /* Checkbox Group */
        .checkbox-group {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 10px;
        }
        
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
        }
        
        .checkbox-input {
            display: none;
        }
        
        .checkbox-custom {
            width: 22px;
            height: 22px;
            border: 2px solid #713C0B;
            border-radius: 6px;
            background: #FBF6EA;
            position: relative;
            transition: all 0.3s;
        }
        
        .checkbox-input:checked + .checkbox-custom {
            background: #F0A548;
            border-color: #F0A548;
        }
        
        .checkbox-input:checked + .checkbox-custom::after {
            content: "✓";
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-weight: bold;
            font-size: 14px;
        }

        .checkbox-input[type="radio"] + .checkbox-custom {
            border-radius: 50%;
        }

        .checkbox-input[type="radio"]:checked + .checkbox-custom::after {
            content: "";
            width: 10px;
            height: 10px;
            background: white;
            border-radius: 50%;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-weight: normal;
            font-size: 0;
        }
                
        .checkbox-label {
            font-weight: 500;
            color: #713C0B;
            user-select: none;
        }
        
        /* File Upload */
        .file-upload { 
            border: 2px dashed #F0D5B8; 
            border-radius: 12px; 
            padding: 25px;
            text-align: center;
            background: #FBF6EA;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .file-upload:hover {
            border-color: #F0A548;
            background: #F9EEDB;
        }
        
        .upload-icon {
            font-size: 40px;
            color: #F0A548;
            margin-bottom: 15px;
        }
        
        .upload-text {
            color: #713C0B;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .upload-subtext {
            color: #C7A178;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .browse-btn { 
            background: #F0A548; 
            color: white; 
            border: none; 
            padding: 10px 25px; 
            border-radius: 8px; 
            cursor: pointer; 
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .browse-btn:hover { 
            background: #D18A2C;
            transform: translateY(-2px);
        }
        
        .file-info {
            margin-top: 10px;
            font-size: 14px;
            color: #713C0B;
            background: #F4DBAF;
            padding: 8px 12px;
            border-radius: 8px;
            display: none;
        }
        
        .current-file {
            margin-top: 10px;
            font-size: 14px;
            color: #713C0B;
            background: #F4DBAF;
            padding: 8px 12px;
            border-radius: 8px;
        }
        
        .file-types { 
            font-size: 13px; 
            color: #C7A178; 
            margin-top: 8px; 
            font-style: italic; 
        }
        
        /* Form Row for two columns */
        .form-row { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 20px; 
            width: 100%;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
        
        /* Button Group */
        .button-group { 
            display: flex; 
            gap: 15px; 
            justify-content: flex-end; 
            margin-top: 30px;
            padding-top: 25px;
            border-top: 2px solid #F0D5B8;
            grid-column: 1 / -1;
        }
        
        .btn { 
            padding: 14px 35px; 
            border: none; 
            border-radius: 12px; 
            font-weight: 600; 
            font-size: 16px; 
            cursor: pointer; 
            transition: all 0.3s; 
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-primary { 
            background: #F0A548; 
            color: white; 
        }
        
        .btn-primary:hover { 
            background: #D18A2C; 
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(240, 165, 72, 0.25);
        }
        
        .btn-secondary { 
            background: #F0D5B8; 
            color: #713C0B; 
            border: 2px solid #713C0B;
        }
        
        .btn-secondary:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateY(-2px);
        }
        
        /* Help Text */
        .help-text {
            font-size: 14px;
            color: #C7A178;
            margin-top: 5px;
        }
        
        /* Resource File Upload in Right Column */
        .resource-upload {
            margin-top: 10px;
        }
        
        /* Image Preview */
        .image-preview-container {
            margin-top: 15px;
        }
        
        .image-preview {
            max-width: 100%;
            border-radius: 12px;
            display: none;
            margin-top: 10px;
            border: 2px solid #F0D5B8;
        }
    </style>
</head>
<body>
    <!-- Top Navigation -->
    <div class="top-nav">
        <div class="logo">
            <i class="fas fa-home"></i>
            SmileSpace
        </div>
    </div>
    
    <div class="container">
        <!-- Page Title -->
        <div class="page-title">
            <h1>Edit Learning Module</h1>
            <p>Update the learning module information</p>
        </div>
        
        <div class="content">
            
            <div class="module-id-display">
                <i class="fas fa-edit"></i>
                <span>Editing: <%= module.getId() %> - <%= module.getTitle() %></span>
            </div>
            
            <form action="edit-module" method="POST" enctype="multipart/form-data" id="moduleForm">
                <input type="hidden" name="id" value="<%= module.getId() %>">
                
                <div class="form-layout">
                    <!-- Left Column: Cover, Category, Learning Level -->
                    <div class="left-column">
                        <!-- Cover Page Image Upload -->
                        <div class="form-group">
                            <label class="form-label required">Cover Page Image</label>
                            <div class="file-upload" id="coverUpload">
                                <div class="upload-icon">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                </div>
                                <div class="upload-text" id="coverUploadText">Upload New Cover Image</div>
                                <div class="upload-subtext">Click to browse or drag & drop</div>
                                <input type="file" name="coverImage" id="coverImageInput" accept="image/*" style="display: none;">
                                <button type="button" class="browse-btn" onclick="document.getElementById('coverImageInput').click()">Browse Files</button>
                                <div class="file-types">PNG, JPG, JPEG, GIF, BMP (Max: 10MB)</div>
                            </div>
                            <% if (module.getCoverImage() != null && !module.getCoverImage().isEmpty()) { %>
                                <div class="current-file" id="currentCoverFile">
                                    <i class="fas fa-image"></i> Current: <%= module.getCoverImage() %>
                                </div>
                            <% } else { %>
                                <div class="current-file" id="currentCoverFile" style="display: none;">
                                    No cover image selected
                                </div>
                            <% } %>
                            <div class="file-info" id="coverFileInfo"></div>
                            <div class="image-preview-container">
                                <img id="coverPreview" class="image-preview" src="" alt="Cover Preview">
                            </div>
                        </div>
                        
                        <!-- Category -->
                        <div class="form-group">
                            <label class="form-label required">Category</label>
                            <div class="checkbox-group">
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Stress" class="checkbox-input" 
                                           <%= "Stress".equals(category) ? "checked" : "" %> required>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Stress</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Sleep" class="checkbox-input"
                                           <%= "Sleep".equals(category) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Sleep</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Anxiety" class="checkbox-input"
                                           <%= "Anxiety".equals(category) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Anxiety</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Self-Esteem" class="checkbox-input"
                                           <%= "Self-Esteem".equals(category) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Self-Esteem</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Mindfulness" class="checkbox-input"
                                           <%= "Mindfulness".equals(category) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Mindfulness</span>
                                </label>
                            </div>
                            <div class="help-text">Select one category for this module</div>
                        </div>
                        
                        <!-- Learning Level -->
                        <div class="form-group">
                            <label class="form-label required">Learning Level</label>
                            <div class="checkbox-group">
                                <label class="checkbox-item">
                                    <input type="radio" name="level" value="Beginner" class="checkbox-input"
                                           <%= "Beginner".equals(level) ? "checked" : "" %> required>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Beginner</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="level" value="Intermediate" class="checkbox-input"
                                           <%= "Intermediate".equals(level) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Intermediate</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="level" value="Advanced" class="checkbox-input"
                                           <%= "Advanced".equals(level) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Advanced</span>
                                </label>
                            </div>
                            <div class="help-text">Select one learning level for this module</div>
                        </div>
                    </div>
                    
                    <!-- Right Column: Other Form Fields -->
                    <div class="right-column">
                        <!-- Title -->
                        <div class="form-group">
                            <label for="title" class="form-label required">Title</label>
                            <input type="text" name="title" id="title" class="form-input" 
                                   value="<%= module.getTitle() %>" 
                                   placeholder="Enter a descriptive title for the module..." required>
                        </div>
                        
                        <!-- Description -->
                        <div class="form-group">
                            <label for="description" class="form-label required">Description</label>
                            <textarea name="description" id="description" class="form-textarea" 
                                      placeholder="Provide a detailed description of what this module covers..." 
                                      required><%= module.getDescription() != null ? module.getDescription() : "" %></textarea>
                        </div>
                        
                        <!-- Author Name and Estimated Duration -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="authorName" class="form-label required">Author Name</label>
                                <input type="text" name="authorName" id="authorName" class="form-input" 
                                       value="<%= module.getAuthorName() != null ? module.getAuthorName() : "" %>" 
                                       placeholder="Enter the author/lecturer name..." required>
                            </div>
                            
                            <div class="form-group">
                                <label for="estimatedDuration" class="form-label required">Estimated Duration</label>
                                <input type="text" name="estimatedDuration" id="estimatedDuration" class="form-input" 
                                       value="<%= module.getEstimatedDuration() != null ? module.getEstimatedDuration() : "" %>" 
                                       placeholder="e.g., 30 minutes, 2 hours, 1 week..." required>
                            </div>
                        </div>
                        
                        <!-- Video URL -->
                        <div class="form-group">
                            <label for="videoUrl" class="form-label">Video URL</label>
                            <input type="url" name="videoUrl" id="videoUrl" class="form-input" 
                                   value="<%= module.getVideoUrl() != null ? module.getVideoUrl() : "" %>"
                                   placeholder="https://www.youtube.com/watch?v=... or Vimeo link">
                            <div class="help-text">Optional: Link to instructional video</div>
                        </div>
                        
                        <!-- Content Outline -->
                        <div class="form-group">
                            <label for="contentOutline" class="form-label">Content Outline</label>
                            <textarea name="contentOutline" id="contentOutline" class="form-textarea" 
                                      placeholder="Enter learning points separated by double dollar signs ($$)"><%= module.getContentOutline() != null ? module.getContentOutline() : "" %></textarea>
                            <div class="help-text">Separate each point with "$$" (e.g., "Introduction$$Lesson 1$$Lesson 2")</div>
                        </div>
                        
                        <!-- Learning Guide -->
                        <div class="form-group">
                            <label for="learningGuide" class="form-label">Learning Guide</label>
                            <textarea name="learningGuide" id="learningGuide" class="form-textarea" 
                                      placeholder="Step-by-step guide separated by double dollar signs ($$)"><%= module.getLearningGuide() != null ? module.getLearningGuide() : "" %></textarea>
                            <div class="help-text">Separate each step with "$$"</div>
                        </div>
                        
                        <!-- Learning Tip -->
                        <div class="form-group">
                            <label for="learningTip" class="form-label">Learning Tip</label>
                            <input type="text" name="learningTip" id="learningTip" class="form-input" 
                                   value="<%= module.getLearningTip() != null ? module.getLearningTip() : "" %>"
                                   placeholder="Short helpful tip for learners">
                        </div>
                        
                        <!-- Key Points -->
                        <div class="form-group">
                            <label for="keyPoints" class="form-label">Key Points</label>
                            <textarea name="keyPoints" id="keyPoints" class="form-textarea" 
                                      placeholder="Key takeaways separated by double dollar signs ($$)"><%= module.getKeyPoints() != null ? module.getKeyPoints() : "" %></textarea>
                            <div class="help-text">Separate each key point with "$$"</div>
                        </div>
                        
                        <!-- Resource File Upload -->
                        <div class="form-group resource-upload">
                            <label class="form-label">Upload Resource File</label>
                            <div class="file-upload" id="resourceUpload">
                                <div class="upload-icon">
                                    <i class="fas fa-file-upload"></i>
                                </div>
                                <div class="upload-text" id="resourceUploadText">Upload New Resource File</div>
                                <div class="upload-subtext">Lecture slides, articles, or videos</div>
                                <input type="file" name="resourceFile" id="resourceFileInput" style="display: none;">
                                <button type="button" class="browse-btn" onclick="document.getElementById('resourceFileInput').click()">Browse Files</button>
                                <div class="file-types">MP4, PDF, DOCX, PPT, PNG, JPG, JPEG (Max: 50MB)</div>
                            </div>
                            <% if (module.getResourceFile() != null && !module.getResourceFile().isEmpty()) { %>
                                <div class="current-file" id="currentResourceFile">
                                    <i class="fas fa-file"></i> Current: <%= module.getResourceFile() %>
                                </div>
                            <% } else { %>
                                <div class="current-file" id="currentResourceFile" style="display: none;">
                                    No resource file uploaded
                                </div>
                            <% } %>
                            <div class="file-info" id="resourceFileInfo"></div>
                            <div class="help-text">Optional: Upload supporting materials for this module</div>
                        </div>
                        
                        <!-- Additional Notes (Optional) -->
                        <div class="form-group">
                            <label for="notes" class="form-label">Additional Notes</label>
                            <textarea name="notes" id="notes" class="form-textarea" 
                                      placeholder="Any additional information or prerequisites for this module..."><%= module.getNotes() != null ? module.getNotes() : "" %></textarea>
                        </div>
                    </div>
                </div>
                
                <!-- Submit Buttons -->
                <div class="button-group">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='admin-module-dashboard'">
                        <i class="fas fa-times"></i>
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check"></i>
                        Update Module
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // File Upload Functions with preview support
        function setupFileUpload(uploadAreaId, fileInputId, uploadTextId, fileInfoId, previewImgId, currentFileId, isImage = false) {
            const uploadArea = document.getElementById(uploadAreaId);
            const fileInput = document.getElementById(fileInputId);
            const uploadText = document.getElementById(uploadTextId);
            const fileInfo = document.getElementById(fileInfoId);
            const previewImg = previewImgId ? document.getElementById(previewImgId) : null;
            const currentFileDiv = currentFileId ? document.getElementById(currentFileId) : null;
            
            if (!uploadArea || !fileInput) return;
            
            // Click to upload
            uploadArea.addEventListener('click', function(e) {
                if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'BUTTON') {
                    fileInput.click();
                }
            });
            
            // File input change
            fileInput.addEventListener('change', function(e) {
                if (this.files && this.files[0]) {
                    const file = this.files[0];
                    const fileName = file.name;
                    const fileSize = (file.size / (1024 * 1024)).toFixed(2); // Convert to MB
                    
                    // Update upload text
                    uploadText.textContent = `Selected: ${fileName}`;
                    
                    // Show file info
                    fileInfo.textContent = `${fileName} (${fileSize} MB)`;
                    fileInfo.style.display = 'block';
                    
                    // Hide current file display
                    if (currentFileDiv) {
                        currentFileDiv.style.display = 'none';
                    }
                    
                    // Validate file if needed
                    if (isImage) {
                        const validImageTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/bmp'];
                        if (!validImageTypes.includes(file.type)) {
                            fileInfo.innerHTML = `<span style="color: #FF4757;">Invalid image format. Please upload PNG, JPG, GIF, or BMP.</span>`;
                            fileInfo.style.display = 'block';
                        }
                        
                        // Show image preview
                        if (previewImg) {
                            const reader = new FileReader();
                            reader.onload = function(e) {
                                previewImg.src = e.target.result;
                                previewImg.style.display = 'block';
                            };
                            reader.readAsDataURL(file);
                        }
                    }
                } else {
                    // Reset to default text
                    const defaultText = uploadAreaId === 'coverUpload' ? 'Upload New Cover Image' : 'Upload New Resource File';
                    uploadText.textContent = defaultText;
                    fileInfo.style.display = 'none';
                    
                    if (previewImg) {
                        previewImg.style.display = 'none';
                    }
                    
                    // Show current file display again
                    if (currentFileDiv && currentFileDiv.textContent.includes("Current:")) {
                        currentFileDiv.style.display = 'block';
                    }
                }
            });
            
            // Drag and drop
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                uploadArea.addEventListener(eventName, preventDefaults, false);
            });
            
            function preventDefaults(e) {
                e.preventDefault();
                e.stopPropagation();
            }
            
            ['dragenter', 'dragover'].forEach(eventName => {
                uploadArea.addEventListener(eventName, highlight, false);
            });
            
            ['dragleave', 'drop'].forEach(eventName => {
                uploadArea.addEventListener(eventName, unhighlight, false);
            });
            
            function highlight() {
                uploadArea.style.borderColor = '#F0A548';
                uploadArea.style.background = '#F9EEDB';
            }
            
            function unhighlight() {
                uploadArea.style.borderColor = '#F0D5B8';
                uploadArea.style.background = '#FBF6EA';
            }
            
            uploadArea.addEventListener('drop', function(e) {
                const dt = e.dataTransfer;
                const files = dt.files;
                
                if (files.length > 0) {
                    fileInput.files = files;
                    
                    // Trigger change event
                    const event = new Event('change');
                    fileInput.dispatchEvent(event);
                }
                
                unhighlight();
            });
        }
        
        // Setup file uploads
        document.addEventListener('DOMContentLoaded', function() {
            // Cover image upload with preview
            setupFileUpload('coverUpload', 'coverImageInput', 'coverUploadText', 'coverFileInfo', 'coverPreview', 'currentCoverFile', true);
            
            // Resource file upload
            setupFileUpload('resourceUpload', 'resourceFileInput', 'resourceUploadText', 'resourceFileInfo', null, 'currentResourceFile', false);
        });
        
        // Form Validation (cover image is optional for editing)
        document.getElementById('moduleForm').addEventListener('submit', function(e) {
            // Clear previous error styles
            document.querySelectorAll('.form-input, .form-textarea, .form-select').forEach(field => {
                field.style.borderColor = '#F0D5B8';
                field.style.boxShadow = 'none';
            });
            
            document.querySelectorAll('.checkbox-group').forEach(group => {
                group.style.color = '';
            });
            
            const coverUpload = document.getElementById('coverUpload');
            const resourceUpload = document.getElementById('resourceUpload');
            coverUpload.style.borderColor = '#F0D5B8';
            resourceUpload.style.borderColor = '#F0D5B8';
            
            let isValid = true;
            let errorMessages = [];
            
            // Check category
            const categorySelected = document.querySelector('input[name="category"]:checked');
            if (!categorySelected) {
                isValid = false;
                const categoryGroup = document.querySelector('.form-group:nth-child(2) .checkbox-group');
                if (categoryGroup) {
                    categoryGroup.style.color = '#FF4757';
                }
                errorMessages.push('Please select a category');
            }
            
            // Check learning level
            const levelSelected = document.querySelector('input[name="level"]:checked');
            if (!levelSelected) {
                isValid = false;
                const levelGroup = document.querySelector('.form-group:nth-child(3) .checkbox-group');
                if (levelGroup) {
                    levelGroup.style.color = '#FF4757';
                }
                errorMessages.push('Please select a learning level');
            }
            
            // Check required text fields
            const requiredFields = ['title', 'description', 'authorName', 'estimatedDuration'];
            requiredFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (field && !field.value.trim()) {
                    isValid = false;
                    field.style.borderColor = '#FF4757';
                    field.style.boxShadow = '0 0 0 3px rgba(255, 71, 87, 0.2)';
                    
                    const fieldName = field.previousElementSibling?.textContent || 'This field';
                    if (!errorMessages.includes(`${fieldName} is required`)) {
                        errorMessages.push(`${fieldName} is required`);
                    }
                }
            });
            
            // Check cover image (optional for edit)
            const coverImageInput = document.getElementById('coverImageInput');
            if (coverImageInput.files && coverImageInput.files.length > 0) {
                const file = coverImageInput.files[0];
                const validImageTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/bmp'];
                if (!validImageTypes.includes(file.type)) {
                    isValid = false;
                    coverUpload.style.borderColor = '#FF4757';
                    errorMessages.push('Please upload a valid image file (JPEG, PNG, GIF, BMP)');
                }
            }
            
            if (!isValid) {
                e.preventDefault();
                alert('Please fix the following errors:\n\n' + errorMessages.join('\n'));
                return false;
            }
            
            return true;
        });
        
        // Clear validation styles on input
        document.querySelectorAll('.form-input, .form-textarea, .form-select').forEach(field => {
            field.addEventListener('input', function() {
                this.style.borderColor = '#F0D5B8';
                this.style.boxShadow = 'none';
            });
        });
        
        // Clear validation styles on radio change
        document.querySelectorAll('.checkbox-input').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                const groupName = this.name;
                const groupItems = document.querySelectorAll(`.checkbox-item input[name="${groupName}"]`);
                groupItems.forEach(item => {
                    item.parentElement.parentElement.style.color = '';
                });
            });
        });
    </script>
</body>
</html>