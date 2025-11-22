<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.ComicDAO" %>
<%@ page import="model.Comic" %>
<%@ page import="java.util.List" %>
<%
    // Load comics data if not already loaded
    try {
        if (request.getAttribute("comics") == null) {
            ComicDAO comicDAO = new ComicDAO();
            List<Comic> comics = comicDAO.getAllComics();
            request.setAttribute("comics", comics != null ? comics : new java.util.ArrayList<>());
        }
    } catch (Exception e) {
        // Log but don't fail - display sample data instead
        e.printStackTrace();
        request.setAttribute("comics", new java.util.ArrayList<>());
    }
%>
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
        <h2>📚 Browse Comics</h2>
        
        <div style="margin: 2rem 0; display: flex; gap: 1rem; flex-wrap: wrap; justify-content: space-between; align-items: center;">
            <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                <select style="padding: 0.8rem; border-radius: 8px; border: 2px solid #667eea; background: white; cursor: pointer; font-weight: 500;">
                    <option>✨ All Categories</option>
                    <option>⚡ Action</option>
                    <option>💕 Romance</option>
                    <option>😄 Comedy</option>
                    <option>🎭 Drama</option>
                    <option>🏰 Fantasy</option>
                </select>
                <select style="padding: 0.8rem; border-radius: 8px; border: 2px solid #667eea; background: white; cursor: pointer; font-weight: 500;">
                    <option>📊 Sort By: Recent</option>
                    <option>👀 Most Viewed</option>
                    <option>🆕 Recently Updated</option>
                    <option>⭐ Highest Rated</option>
                    <option>🔥 Trending</option>
                </select>
            </div>
            <div style="font-size: 0.9rem; color: #666;">
                Showing <strong><c:out value="${comics != null ? comics.size() : 6}"/></strong> comics
            </div>
        </div>

        <div class="cards-grid">
            <c:choose>
                <c:when test="${not empty comics}">
                    <c:forEach items="${comics}" var="comic" varStatus="status">
                        <div class="card">
                            <div style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); height: 100px; border-radius: 8px; margin: -1.5rem -1.5rem 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 2.5rem;">
                                <c:choose>
                                    <c:when test="${status.count % 6 == 1}">⚡</c:when>
                                    <c:when test="${status.count % 6 == 2}">💕</c:when>
                                    <c:when test="${status.count % 6 == 3}">🏰</c:when>
                                    <c:when test="${status.count % 6 == 4}">😄</c:when>
                                    <c:when test="${status.count % 6 == 5}">🎭</c:when>
                                    <c:otherwise>⚔️</c:otherwise>
                                </c:choose>
                            </div>
                            <h3><c:out value="${comic.title}"/></h3>
                            <p style="margin: 0.5rem 0; font-size: 0.9rem; color: #888;">
                                <span class="badge badge-primary"><c:out value="${comic.category}"/></span>
                                <span style="float: right;">⭐<c:out value="${comic.averageRating}"/>/5</span>
                            </p>
                            <p><c:out value="${comic.description}"/></p>
                            <p style="font-size: 0.85rem; color: #aaa; margin: 0.5rem 0;">✓ <c:out value="${comic.views}"/> views • 🔖 <c:out value="${comic.bookmarks}"/> bookmarks</p>
                            <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}" class="btn" style="display: inline-block; width: auto;">View →</a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <div style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); height: 100px; border-radius: 8px; margin: -1.5rem -1.5rem 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 2.5rem;">⚡</div>
                        <h3>Comic Title 1</h3>
                        <p style="margin: 0.5rem 0; font-size: 0.9rem; color: #888;">
                            <span class="badge badge-danger">Action</span>
                            <span style="float: right;">⭐⭐⭐⭐⭐</span>
                        </p>
                        <p>An epic adventure filled with action and suspense.</p>
                        <p style="font-size: 0.85rem; color: #aaa; margin: 0.5rem 0;">✓ 1,234 views • 🔖 45 bookmarks</p>
                        <a href="${pageContext.request.contextPath}/comic.jsp" class="btn" style="display: inline-block; width: auto;">View →</a>
                    </div>
                    <div class="card">
                        <div style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); height: 100px; border-radius: 8px; margin: -1.5rem -1.5rem 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 2.5rem;">💕</div>
                        <h3>Comic Title 2</h3>
                        <p style="margin: 0.5rem 0; font-size: 0.9rem; color: #888;">
                            <span class="badge badge-primary">Romance</span>
                            <span style="float: right;">⭐⭐⭐⭐</span>
                        </p>
                        <p>A touching love story between two souls.</p>
                        <p style="font-size: 0.85rem; color: #aaa; margin: 0.5rem 0;">✓ 892 views • 🔖 32 bookmarks</p>
                        <a href="${pageContext.request.contextPath}/comic.jsp" class="btn" style="display: inline-block; width: auto;">View →</a>
                    </div>
                    <div class="card">
                        <div style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); height: 100px; border-radius: 8px; margin: -1.5rem -1.5rem 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 2.5rem; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);">🏰</div>
                        <h3>Comic Title 3</h3>
                        <p style="margin: 0.5rem 0; font-size: 0.9rem; color: #888;">
                            <span class="badge badge-success">Fantasy</span>
                            <span style="float: right;">⭐⭐⭐⭐⭐</span>
                        </p>
                        <p>A magical world awaits your discovery.</p>
                        <p style="font-size: 0.85rem; color: #aaa; margin: 0.5rem 0;">✓ 2,156 views • 🔖 78 bookmarks</p>
                        <a href="${pageContext.request.contextPath}/comic.jsp" class="btn" style="display: inline-block; width: auto;">View →</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
