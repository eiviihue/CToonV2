<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chapter View - CToon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
            <div>
                <a href="${pageContext.request.contextPath}/comic.jsp" style="font-weight: 600;">← Back to Comic</a>
                <h2>Chapter 45 - The Final Showdown</h2>
            </div>
            <div style="display: flex; gap: 1rem;">
                <button class="btn btn-secondary">← Previous Chapter</button>
                <button class="btn">Next Chapter →</button>
            </div>
        </div>

        <div class="card" style="text-align: center; margin: 2rem 0;">
            <p style="color: #999; margin-bottom: 2rem;">Chapter Image 1 of 20</p>
            <div style="background: #e0e0e0; height: 600px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 2rem;">
                <p style="color: #999; font-size: 1.2rem;">📖 [Chapter Content Here]</p>
            </div>
            
            <div style="display: flex; gap: 1rem; justify-content: center; margin: 2rem 0;">
                <button class="btn btn-secondary">← Previous</button>
                <select style="padding: 0.8rem; border-radius: 8px; border: 2px solid #667eea;">
                    <option>Go to page...</option>
                    <option>Page 1</option>
                    <option>Page 2</option>
                    <option>Page 3</option>
                </select>
                <button class="btn">Next →</button>
            </div>
        </div>

        <div class="card">
            <h3>💬 Chapter Comments</h3>
            <textarea placeholder="Share your thoughts about this chapter..." style="margin-bottom: 1rem; height: 100px;"></textarea>
            <button class="btn" style="width: 100%;">Post Comment</button>
            
            <div style="margin-top: 2rem; border-top: 1px solid #e0e0e0; padding-top: 1rem;">
                <div style="margin-bottom: 1.5rem;">
                    <strong>ComicFan99</strong> <span style="color: #999; font-size: 0.9rem;">1 day ago</span>
                    <p>Wow! That plot twist was insane! Can't wait for the next chapter!</p>
                </div>
                <div style="margin-bottom: 1.5rem;">
                    <strong>MangaReader</strong> <span style="color: #999; font-size: 0.9rem;">2 days ago</span>
                    <p>The art in this chapter is absolutely stunning. The action sequences are perfectly drawn!</p>
                </div>
                <div>
                    <strong>StoryLover</strong> <span style="color: #999; font-size: 0.9rem;">3 days ago</span>
                    <p>This is becoming my favorite manga! The character development is amazing!</p>
                </div>
            </div>
        </div>

        <div style="text-align: center; margin: 3rem 0; display: flex; gap: 1rem; justify-content: center;">
            <button class="btn btn-secondary">← Previous Chapter</button>
            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">Back to Comic</a>
            <button class="btn">Next Chapter →</button>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
