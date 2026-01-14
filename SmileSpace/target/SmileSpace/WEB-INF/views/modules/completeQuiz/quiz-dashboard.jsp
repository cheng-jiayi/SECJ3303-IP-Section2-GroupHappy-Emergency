<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    List<LearningModule> stressModules = (List<LearningModule>) request.getAttribute("stressModules");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Learning Resources Dashboard - smilespace</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #FFF8E8;
            color: #6B4F36;
            min-height: 100vh;
        }
        
        /* ===== HEADER STYLES ===== */
        .header {
            background-color: #FFF3C8;
            padding: 15px 40px;
            border-bottom: 2px solid #E8D9B5;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .home-link {
            text-decoration: none;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: opacity 0.2s;
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .home-link:hover {
            opacity: 0.7;
            text-decoration: none;
        }
        
        /* ===== MAIN CONTAINER ===== */
        .main-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        /* ===== PAGE HEADER SECTION ===== */
        .page-header {
            margin-bottom: 40px;
        }
        
        .page-title {
            font-size: 32px;
            color: #6B4F36;
            margin-bottom: 10px;
            font-weight: 700;
            letter-spacing: -0.5px;
        }
        
        .page-subtitle {
            font-size: 18px;
            color: #CF8224;
            margin-bottom: 15px;
            font-weight: 500;
        }
        
        .welcome-message {
            color: #8D735B;
            font-size: 16px;
            line-height: 1.6;
            max-width: 800px;
            padding: 20px;
            background-color: #FFFDF6;
            border-radius: 12px;
            border-left: 4px solid #CF8224;
            margin-top: 20px;
        }
        
        /* ===== CONTROLS SECTION ===== */
        .controls-section {
            background-color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 40px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: 1px solid #E8D9B5;
        }
        
        .controls-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }
        
        .search-container {
            flex: 1;
            max-width: 500px;
            position: relative;
        }
        
        .search-input {
            width: 100%;
            padding: 14px 20px 14px 50px;
            border: 2px solid #E8D9B5;
            border-radius: 25px;
            background-color: #FFFDF6;
            font-size: 15px;
            color: #6B4F36;
            transition: all 0.3s ease;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #CF8224;
            box-shadow: 0 0 0 3px rgba(207, 130, 36, 0.1);
        }
        
        .search-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #CF8224;
            font-size: 18px;
        }
        
        .filter-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .filter-label {
            color: #6B4F36;
            font-weight: 600;
            font-size: 15px;
        }
        
        .filter-dropdown {
            padding: 12px 25px;
            border: 2px solid #E8D9B5;
            border-radius: 25px;
            background-color: #FFFDF6;
            color: #6B4F36;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 180px;
        }
        
        .filter-dropdown:focus {
            outline: none;
            border-color: #CF8224;
            box-shadow: 0 0 0 3px rgba(207, 130, 36, 0.1);
        }
        
        /* ===== MODULES SECTION ===== */
        .modules-section {
            margin-bottom: 50px;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .section-title {
            font-size: 24px;
            color: #6B4F36;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .modules-count {
            background-color: #FFF3C8;
            color: #CF8224;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .modules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
        }
        
        /* ===== MODULE CARD ===== */
        .module-card {
            background-color: white;
            border-radius: 18px;
            padding: 30px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.06);
            border: 1px solid #E8D9B5;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        
        .module-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.1);
            border-color: #CF8224;
        }
        
        .module-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }
        
        .module-id {
            background-color: #FFF3C8;
            color: #CF8224;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        
        .module-level {
            padding: 7px 18px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .module-level.beginner {
            background-color: #E8F5E9;
            color: #2E7D32;
        }
        
        .module-level.intermediate {
            background-color: #E3F2FD;
            color: #1565C0;
        }
        
        .module-level.advanced {
            background-color: #FFF3E0;
            color: #EF6C00;
        }
        
        .module-content {
            flex: 1;
            margin-bottom: 25px;
        }
        
        .module-title {
            font-size: 22px;
            color: #6B4F36;
            margin-bottom: 15px;
            font-weight: 700;
            line-height: 1.3;
        }
        
        .module-desc {
            color: #8D735B;
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        
        .module-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid #F0E9DD;
            margin-top: auto;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #8D735B;
            font-size: 13px;
        }
        
        .module-footer {
            margin-top: 20px;
        }
        
        .btn-start {
            display: block;
            width: 100%;
            background: linear-gradient(135deg, #CF8224 0%, #E8A95E 100%);
            color: white;
            text-align: center;
            padding: 14px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 700;
            font-size: 15px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-start:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(207, 130, 36, 0.3);
        }
        
        /* ===== NO MODULES MESSAGE ===== */
        .no-modules-message {
            text-align: center;
            padding: 60px 40px;
            color: #8D735B;
            font-size: 17px;
            grid-column: 1 / -1;
            background-color: white;
            border-radius: 15px;
            border: 1px solid #E8D9B5;
        }
        
        .no-modules-icon {
            font-size: 48px;
            color: #E8D9B5;
            margin-bottom: 20px;
        }
        
        /* ===== RESPONSIVE DESIGN ===== */
        @media (max-width: 768px) {
            .main-container {
                padding: 0 15px;
            }
            
            .header {
                padding: 15px 20px;
            }
            
            .controls-wrapper {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-container {
                max-width: 100%;
            }
            
            .filter-container {
                width: 100%;
                justify-content: space-between;
            }
            
            .filter-dropdown {
                flex: 1;
                min-width: 0;
            }
            
            .modules-grid {
                grid-template-columns: 1fr;
            }
            
            .module-card {
                padding: 25px;
            }
            
            .page-title {
                font-size: 28px;
            }
        }
        
        /* ===== ANIMATIONS ===== */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .module-card {
            animation: fadeIn 0.5s ease forwards;
        }
        
        /* ===== UTILITY CLASSES ===== */
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .mb-20 { margin-bottom: 20px; }
        .mb-30 { margin-bottom: 30px; }
        .mt-20 { margin-top: 20px; }
        .mt-30 { margin-top: 30px; }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <!-- HEADER -->
    <header class="header">
        <a href="<%= request.getContextPath() %>/student-learning-modules" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
    </header>
    
    <!-- MAIN CONTENT -->
    <main class="main-container">
        <!-- PAGE HEADER -->
        <section class="page-header">
            <h1 class="page-title">Learning Modules on Stress Management</h1>
            <p class="page-subtitle">Feeling overwhelmed? These modules will teach you how to stay calm, balanced, and confident even under pressure. Select a module to begin your learning journey.</p>

        </section>
        
        <!-- CONTROLS SECTION -->
        <section class="controls-section">
            <div class="controls-wrapper">
                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-input" placeholder="Search modules by title or description...">
                </div>
                
                <div class="filter-container">
                    <span class="filter-label">Filter by:</span>
                    <select class="filter-dropdown">
                        <option value="all">All Levels</option>
                        <option value="beginner">Beginner</option>
                        <option value="intermediate">Intermediate</option>
                        <option value="advanced">Advanced</option>
                    </select>
                </div>
            </div>
        </section>
        
        <!-- MODULES SECTION -->
        <section class="modules-section">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-graduation-cap"></i>
                    Available Modules
                </h2>
                <span class="modules-count">
                    <%= stressModules != null ? stressModules.size() : 0 %> Modules
                </span>
            </div>
            
            <div class="modules-grid">
                <% if (stressModules != null && !stressModules.isEmpty()) { 
                    for (LearningModule module : stressModules) { 
                        String levelClass = "";
                        // Get the level and ensure it's lowercase for CSS class
                        String level = module.getLevel().toLowerCase();
                        switch(level) {
                            case "beginner": levelClass = "beginner"; break;
                            case "intermediate": levelClass = "intermediate"; break;
                            case "advanced": levelClass = "advanced"; break;
                            default: levelClass = "beginner";
                        }
                %>
                    <article class="module-card">
                        <div class="module-header">
                            <span class="module-id"><%= module.getId() %></span>
                            <span class="module-level <%= levelClass %>"><%= module.getLevel() %></span>
                        </div>
                        
                        <div class="module-content">
                            <h3 class="module-title"><%= module.getTitle() %></h3>
                            <p class="module-desc"><%= module.getDescription() %></p>
                        </div>
                        
                        <div class="module-meta">
                            <div class="meta-item">
                                <i class="far fa-eye"></i>
                                <span><%= module.getViews() %> views</span>
                            </div>
                            <div class="meta-item">
                                <i class="far fa-calendar-alt"></i>
                                <span><%= module.getLastUpdated() %></span>
                            </div>
                        </div>
                        
                        <div class="module-footer">
                            <a href="student-module?id=<%= module.getId() %>" class="btn-start">
                                <i class="fas fa-play-circle"></i>
                                Begin Journey
                            </a>
                        </div>
                    </article>
                <%   }
                   } else { %>
                    <div class="no-modules-message">
                        <div class="no-modules-icon">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <h3>No Modules Available</h3>
                        <p>Learning modules will be available soon. Please check back later.</p>
                    </div>
                <% } %>
            </div>
        </section>
    </main>
    
    <!-- JAVASCRIPT -->
    <script>
        // Wait for DOM to be fully loaded
        document.addEventListener('DOMContentLoaded', function() {
            // Get all modules
            const modules = document.querySelectorAll('.module-card');
            const searchInput = document.querySelector('.search-input');
            const filterDropdown = document.querySelector('.filter-dropdown');
            
            // Search functionality
            searchInput.addEventListener('input', function(e) {
                const searchTerm = e.target.value.trim().toLowerCase();
                
                modules.forEach(module => {
                    if (module.style.display === 'none') return;
                    
                    const title = module.querySelector('.module-title').textContent.toLowerCase();
                    const desc = module.querySelector('.module-desc').textContent.toLowerCase();
                    
                    if (searchTerm === '' || title.includes(searchTerm) || desc.includes(searchTerm)) {
                        module.style.display = 'flex';
                        module.style.animation = 'fadeIn 0.5s ease forwards';
                    } else {
                        module.style.display = 'none';
                    }
                });
            });
            
            // Filter functionality
            filterDropdown.addEventListener('change', function(e) {
                const selectedLevel = e.target.value.toLowerCase();
                
                modules.forEach(module => {
                    const levelElement = module.querySelector('.module-level');
                    if (levelElement) {
                        // Get the CSS class that contains the level (beginner, intermediate, advanced)
                        const levelClasses = Array.from(levelElement.classList);
                        const levelClass = levelClasses.find(cls => 
                            cls === 'beginner' || cls === 'intermediate' || cls === 'advanced'
                        );
                        
                        if (selectedLevel === 'all' || (levelClass && levelClass === selectedLevel)) {
                            module.style.display = 'flex';
                            module.style.animation = 'fadeIn 0.5s ease forwards';
                        } else {
                            module.style.display = 'none';
                        }
                    } else {
                        module.style.display = 'none';
                    }
                });
                
                // Update search input to reflect filtering
                searchInput.dispatchEvent(new Event('input'));
            });
            
            // Add click effects to module cards
            modules.forEach(module => {
                module.addEventListener('click', function(e) {
                    // Only trigger if not clicking on the button
                    if (!e.target.closest('.btn-start')) {
                        const link = this.querySelector('.btn-start');
                        if (link) {
                            link.style.transform = 'scale(0.98)';
                            setTimeout(() => {
                                link.style.transform = '';
                            }, 150);
                        }
                    }
                });
            });
            
            // Add subtle hover effect to filter dropdown
            filterDropdown.addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateY(-2px)';
            });
            
            filterDropdown.addEventListener('blur', function() {
                this.parentElement.style.transform = '';
            });
        });
    </script>
</body>
</html>