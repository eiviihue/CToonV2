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
                    <p style="margin: 1rem 0;">⭐<strong><c:out value="${avgRating}" default="0.00"/></strong>/5</p>
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
                    <c:choose>
                        <c:when test="${not empty chapters}">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <form method="post" action="${pageContext.request.contextPath}/comic-detail" style="margin-bottom: 1rem;">
                                        <input type="hidden" name="action" value="addComment" />
                                        <input type="hidden" name="comicId" value="${comic.id}" />
                                        <label for="chapterId">Comment for chapter:</label>
                                        <select name="chapterId" id="chapterId" style="display:block; margin:0.5rem 0 0.75rem; padding:0.6rem; border-radius:8px;">
                                            <c:forEach items="${chapters}" var="ch">
                                                <option value="${ch.id}">Chapter ${ch.number} - ${ch.title}</option>
                                            </c:forEach>
                                        </select>
                                        <textarea name="content" placeholder="Add a comment..." style="width:100%; min-height:100px; padding:0.8rem; border-radius:8px; border:1px solid #e0e0e0;"></textarea>
                                        <div style="display:flex; gap:0.5rem; margin-top:0.5rem;">
                                            <button class="btn" type="submit">Post Comment</button>
                                        </div>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <p>Please <a href="${pageContext.request.contextPath}/login.jsp">login</a> to comment.</p>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                    </c:choose>

                    <div style="margin-top: 1.5rem; border-top: 1px solid #e0e0e0; padding-top: 1rem;">
                        <c:choose>
                            <c:when test="${not empty comments}">
                                <c:forEach items="${comments}" var="comment">
                                    <div style="margin-bottom:1.2rem;">
                                        <strong>User</strong> <span style="color:#999; font-size:0.9rem;">${comment.createdAt}</span>
                                        <p style="margin-top:0.4rem;">${comment.content}</p>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p>No comments yet. Be the first to comment!</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card">
                    <h3>⭐ Ratings</h3>
                    <p>Average: <strong><c:out value="${comic.averageRating}" default="0"/></strong> / 5</p>
                    <c:choose>
                        <c:when test="${not empty ratings}">
                            <div style="margin-top:1rem;">
                                <c:forEach items="${ratings}" var="r">
                                    <div style="padding:0.6rem 0; border-bottom:1px solid #f0f0f0;">
                                        <strong>User</strong>
                                        <span style="color:#ffb400; margin-left:0.5rem;">
                                            <c:forEach begin="1" end="5" varStatus="s">
                                                <c:choose>
                                                    <c:when test="${s.count <= r.stars}">★</c:when>
                                                    <c:otherwise>☆</c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p>No ratings yet.</p>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <form method="post" action="${pageContext.request.contextPath}/comic-detail" style="margin-top:1rem;">
                                <input type="hidden" name="action" value="addRating" />
                                <input type="hidden" name="comicId" value="${comic.id}" />
                                <label for="stars">Give a rating:</label>
                                <select name="stars" id="stars" style="display:block; margin:0.5rem 0 1rem; padding:0.6rem; border-radius:8px;">
                                    <option value="5">5 - Excellent</option>
                                    <option value="4">4 - Very Good</option>
                                    <option value="3">3 - Good</option>
                                    <option value="2">2 - Fair</option>
                                    <option value="1">1 - Poor</option>
                                </select>
                                <button class="btn" type="submit">Submit Rating</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <p>Please <a href="${pageContext.request.contextPath}/login.jsp">login</a> to rate.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
