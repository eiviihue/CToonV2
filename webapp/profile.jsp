<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - CToon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <h2>My Profile</h2>
        
        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 2rem; margin: 2rem 0;">
            <div class="card" style="text-align: center;">
                <div style="font-size: 4rem; margin-bottom: 1rem;">👤</div>
                <h3>John Doe</h3>
                <p style="color: #667eea; font-weight: 600;">@johndoe</p>
                <p>Member since: Jan 2024</p>
                <button class="btn" style="width: 100%; margin-top: 1rem;">Edit Profile</button>
            </div>
            
            <div>
                <div class="card">
                    <h3>About</h3>
                    <p>A comic enthusiast who loves exploring new stories and supporting talented creators.</p>
                </div>
                
                <div class="card">
                    <h3>📖 Reading History</h3>
                    <ul style="list-style: none;">
                        <li style="padding: 0.5rem 0;"><a href="${pageContext.request.contextPath}/comic.jsp">Comic Title 1</a> - Last read 2 days ago</li>
                        <li style="padding: 0.5rem 0;"><a href="${pageContext.request.contextPath}/comic.jsp">Comic Title 2</a> - Last read 1 week ago</li>
                        <li style="padding: 0.5rem 0;"><a href="${pageContext.request.contextPath}/comic.jsp">Comic Title 3</a> - Last read 2 weeks ago</li>
                    </ul>
                </div>
                
                <div class="card">
                    <h3>❤️ Bookmarks</h3>
                    <ul style="list-style: none;">
                        <li style="padding: 0.5rem 0;"><a href="${pageContext.request.contextPath}/comic.jsp">Comic Title 1</a></li>
                        <li style="padding: 0.5rem 0;"><a href="${pageContext.request.contextPath}/comic.jsp">Comic Title 2</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
