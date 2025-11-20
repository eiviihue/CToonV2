<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comic Info - CToon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <div style="display: grid; grid-template-columns: 300px 1fr; gap: 2rem; margin: 2rem 0;">
            <div class="card" style="text-align: center;">
                <div style="font-size: 8rem; background: #667eea; color: white; padding: 2rem; border-radius: 12px; margin-bottom: 1rem;">🎨</div>
                <h3>Comic Title</h3>
                <div style="margin: 1rem 0;">
                    <span style="background: #667eea; color: white; padding: 0.4rem 0.8rem; border-radius: 20px; font-size: 0.9rem;">Fantasy</span>
                </div>
                <p style="color: #666;">Author: Creator Name</p>
                <p style="margin: 1rem 0;">⭐⭐⭐⭐⭐ (4.5/5)</p>
                <div style="display: flex; gap: 0.5rem;">
                    <button class="btn" style="flex: 1;">❤️ Bookmark</button>
                    <button class="btn btn-secondary" style="flex: 1;">⭐ Rate</button>
                </div>
            </div>
            
            <div>
                <div class="card">
                    <h3>Overview</h3>
                    <p><strong>Status:</strong> Ongoing</p>
                    <p><strong>Views:</strong> 1.2M</p>
                    <p><strong>Chapters:</strong> 45</p>
                    <p style="margin-top: 1rem; line-height: 1.8;">
                        This is an exciting comic with amazing storytelling and beautiful artwork. 
                        Follow the journey of our heroes as they explore a magical world filled with 
                        adventures, mysteries, and epic battles. Perfect for fans of fantasy and action.
                    </p>
                </div>
                
                <div class="card">
                    <h3>📖 Chapters</h3>
                    <ul style="list-style: none;">
                        <li style="padding: 0.8rem; border-bottom: 1px solid #e0e0e0;"><a href="${pageContext.request.contextPath}/chapter.jsp?id=45">Chapter 45 - The Final Showdown</a> <span style="float: right; color: #999;">2 days ago</span></li>
                        <li style="padding: 0.8rem; border-bottom: 1px solid #e0e0e0;"><a href="${pageContext.request.contextPath}/chapter.jsp?id=44">Chapter 44 - Secrets Revealed</a> <span style="float: right; color: #999;">1 week ago</span></li>
                        <li style="padding: 0.8rem; border-bottom: 1px solid #e0e0e0;"><a href="${pageContext.request.contextPath}/chapter.jsp?id=43">Chapter 43 - Unexpected Turn</a> <span style="float: right; color: #999;">2 weeks ago</span></li>
                        <li style="padding: 0.8rem;"><a href="${pageContext.request.contextPath}/chapter.jsp?id=42">Chapter 42 - The Beginning</a> <span style="float: right; color: #999;">3 weeks ago</span></li>
                    </ul>
                </div>

                <div class="card">
                    <h3>💬 Comments</h3>
                    <textarea placeholder="Add a comment..." style="margin-bottom: 1rem;"></textarea>
                    <button class="btn" style="width: 100%;">Post Comment</button>
                    
                    <div style="margin-top: 2rem; border-top: 1px solid #e0e0e0; padding-top: 1rem;">
                        <div style="margin-bottom: 1.5rem;">
                            <strong>User123</strong> <span style="color: #999; font-size: 0.9rem;">2 days ago</span>
                            <p>Amazing chapter! Can't wait for the next one!</p>
                        </div>
                        <div>
                            <strong>ComicLover</strong> <span style="color: #999; font-size: 0.9rem;">1 day ago</span>
                            <p>The art style is just incredible. Love this comic so much!</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
