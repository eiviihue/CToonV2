<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${comic != null ? comic.title : 'Comic Info'} - CToon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <div style="display: grid; grid-template-columns: 300px 1fr; gap: 2rem; margin: 2rem 0;">
            <div class="card" style="text-align: center;">
                <c:choose>
                    <c:when test="${comic != null}">
                        <img src="${pageContext.request.contextPath}${comic.coverPath}" alt="${comic.title} cover" style="width:100%; border-radius:8px; margin-bottom:1rem;">
                        <h3>${comic.title}</h3>
                        <div style="margin: 1rem 0;">
                            <span style="background: #667eea; color: white; padding: 0.4rem 0.8rem; border-radius: 20px; font-size: 0.9rem;">${comic.status}</span>
                        </div>
                        <p style="color: #666;">Author: ${comic.author}</p>
                        <p style="margin: 1rem 0;">Rating: ${comic.averageRating} / 5</p>
                        <div style="display: flex; gap: 0.5rem;">
                            <button class="btn" style="flex: 1;">❤️ Bookmark</button>
                            <button class="btn btn-secondary" style="flex: 1;">⭐ Rate</button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="font-size: 8rem; background: #667eea; color: white; padding: 2rem; border-radius: 12px; margin-bottom: 1rem;">🎨</div>
                        <h3>Comic Title</h3>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div>
                <div class="card">
                    <h3>Overview</h3>
                    <c:if test="${comic != null}">
                        <p><strong>Status:</strong> ${comic.status}</p>
                        <p><strong>Views:</strong> ${comic.views}</p>
                        <p><strong>Chapters:</strong> <c:out value="${fn:length(chapters)}"/></p>
                        <p style="margin-top: 1rem; line-height: 1.8;">${comic.description}</p>
                    </c:if>
                </div>
                
                <div class="card">
                    <h3>📖 Chapters</h3>
                    <ul style="list-style: none; padding: 0; margin: 0;">
                        <c:forEach items="${chapters}" var="ch">
                            <li style="padding: 0.8rem; border-bottom: 1px solid #e0e0e0;">
                                <a href="${pageContext.request.contextPath}/chapter?id=${ch.id}">Chapter ${ch.number} - ${ch.title}</a>
                                <span style="float: right; color: #999;">&nbsp;</span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>

                <div class="card">
                    <h3>💬 Comments</h3>
                    <textarea placeholder="Add a comment..." style="margin-bottom: 1rem; width:100%;"></textarea>
                    <button class="btn" style="width: 100%;">Post Comment</button>
                </div>
            </div>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
