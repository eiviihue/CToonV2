<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Comics - CToon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <h2>Browse Comics</h2>
        
        <div style="margin: 2rem 0; display: flex; gap: 1rem; flex-wrap: wrap;">
            <select style="padding: 0.8rem; border-radius: 8px; border: 2px solid #667eea;">
                <option>All Categories</option>
                <option>Action</option>
                <option>Romance</option>
                <option>Comedy</option>
                <option>Drama</option>
                <option>Fantasy</option>
            </select>
            <select style="padding: 0.8rem; border-radius: 8px; border: 2px solid #667eea;">
                <option>Sort By</option>
                <option>Most Viewed</option>
                <option>Recently Updated</option>
                <option>Highest Rated</option>
                <option>Newest</option>
            </select>
        </div>

        <div class="cards-grid">
            <div class="card">
                <h3>Comic Title 1</h3>
                <p>Genre: Action | Rating: ⭐⭐⭐⭐⭐</p>
                <p>An epic adventure filled with action and suspense.</p>
                <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">View</a>
            </div>
            <div class="card">
                <h3>Comic Title 2</h3>
                <p>Genre: Romance | Rating: ⭐⭐⭐⭐</p>
                <p>A touching love story between two souls.</p>
                <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">View</a>
            </div>
            <div class="card">
                <h3>Comic Title 3</h3>
                <p>Genre: Fantasy | Rating: ⭐⭐⭐⭐⭐</p>
                <p>A magical world awaits your discovery.</p>
                <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">View</a>
            </div>
            <div class="card">
                <h3>Comic Title 4</h3>
                <p>Genre: Comedy | Rating: ⭐⭐⭐⭐</p>
                <p>Laugh out loud with hilarious moments.</p>
                <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">View</a>
            </div>
            <div class="card">
                <h3>Comic Title 5</h3>
                <p>Genre: Drama | Rating: ⭐⭐⭐⭐⭐</p>
                <p>Deep emotions and compelling storytelling.</p>
                <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">View</a>
            </div>
            <div class="card">
                <h3>Comic Title 6</h3>
                <p>Genre: Action | Rating: ⭐⭐⭐⭐</p>
                <p>Intense battles and breathtaking scenes.</p>
                <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">View</a>
            </div>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
