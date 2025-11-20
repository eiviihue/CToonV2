<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                <div class="card">
                    <div style="font-size: 8rem; background: #667eea; color: white; padding: 2rem; border-radius: 12px; margin-bottom: 1rem;">
                        <c:choose>
                            <c:when test="${not empty comic && not empty comic.coverPath}">
                                <img src="${pageContext.request.contextPath}${comic.coverPath}" style="width: 100%; height: 300px; object-fit: cover; border-radius: 8px;" alt="Cover">
                            </c:when>
                            <c:otherwise>🎨</c:otherwise>
                        </c:choose>
                    </div>
                    <h3><c:out default="Comic Title" value="${comic.title}"/></h3>
                    <div style="margin: 1rem 0;">
                        <span style="background: #667eea; color: white; padding: 0.4rem 0.8rem; border-radius: 20px; font-size: 0.9rem;">
                            <c:out default="Manga" value="${comic.status}"/>
                        </span>
                    </div>
                    <p style="color: #666;">Author: <c:out default="Unknown" value="${comic.author}"/></p>
                    <p style="margin: 1rem 0;">⭐<c:out default="0" value="${comic.averageRating}"/>/5</p>
                    <div style="display: flex; gap: 0.5rem;">
                        <button class="btn" style="flex: 1;">❤️ Bookmark</button>
                        <button class="btn btn-secondary" style="flex: 1;">⭐ Rate</button>
                    </div>
                </div>
            
            <div>
                <div class="card">
                    <h3>Overview</h3>
                    <p><strong>Status:</strong> Ongoing</p>
                    <p><strong>Views:</strong> <c:out default="0" value="${comic.views}"/></p>
                    <p><strong>Chapters:</strong> 45</p>
                    <p style="margin-top: 1rem; line-height: 1.8;">
                        <c:out default="This is an exciting comic with amazing storytelling and beautiful artwork." value="${comic.description}"/>
                    </p>
                </div>
                
                <div class="card">
                    <h3>📖 Chapters</h3>
                    <c:choose>
                        <c:when test="${not empty chapters}">
                            <ul style="list-style: none;">
                                <c:forEach items="${chapters}" var="chapter">
                                    <li style="padding: 0.8rem; border-bottom: 1px solid #e0e0e0;">
                                        <a href="${pageContext.request.contextPath}/chapter?id=${chapter.id}">
                                            Chapter ${chapter.number} - ${chapter.title}
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <p>No chapters available yet.</p>
                        </c:otherwise>
                    </c:choose>
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
