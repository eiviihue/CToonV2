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
        <h2>Browse Comics</h2>
        
        <div style="margin: 2rem 0; display: flex; gap: 1rem; flex-wrap: wrap; justify-content: space-between; align-items: center;">
            <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                <select style="padding: 0.8rem; border-radius: 8px; border: 2px solid #667eea; background: white; cursor: pointer; font-weight: 500;">
                    <option>All Categories</option>
                    <option>Action</option>
                    <option>Romance</option>
                    <option>Comedy</option>
                    <option>Drama</option>
                    <option>Fantasy</option>
                </select>
                <select style="padding: 0.8rem; border-radius: 8px; border: 2px solid #667eea; background: white; cursor: pointer; font-weight: 500;">
                    <option>Sort By: Recent</option>
                    <option>Most Viewed</option>
                    <option>Recently Updated</option>
                    <option>Highest Rated</option>
                    <option>Trending</option>
                </select>
            </div>
            <div style="font-size: 0.9rem; color: #666;">
                Showing <strong><c:out value="${comics != null ? comics.size() : 0}"/></strong> comics
            </div>
        </div>

        <div class="cards-grid">
            <c:choose>
                <c:when test="${not empty comics}">
                    <c:forEach items="${comics}" var="comic" varStatus="status">
                        <div class="card">
                            <div style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); height: 100px; border-radius: 8px; margin: -1.5rem -1.5rem 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.2rem; font-weight: bold;">
                                <c:choose>
                                    <c:when test="${status.count % 6 == 1}">ACTION</c:when>
                                    <c:when test="${status.count % 6 == 2}">ROMANCE</c:when>
                                    <c:when test="${status.count % 6 == 3}">FANTASY</c:when>
                                    <c:when test="${status.count % 6 == 4}">COMEDY</c:when>
                                    <c:when test="${status.count % 6 == 5}">DRAMA</c:when>
                                    <c:otherwise>ADVENTURE</c:otherwise>
                                </c:choose>
                            </div>
                            <h3><c:out value="${comic.title}"/></h3>
                            <p style="margin: 0.5rem 0; font-size: 0.9rem; color: #888;">
                                <span class="badge badge-primary"><c:out value="${comic.category}"/></span>
                                <span style="float: right;"><c:out value="${comic.averageRating}"/>/5</span>
                            </p>
                            <p><c:out value="${comic.description}"/></p>
                            <p style="font-size: 0.85rem; color: #aaa; margin: 0.5rem 0;"><c:out value="${comic.views}"/> views • <c:out value="${comic.bookmarks}"/> bookmarks</p>
                            <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}" class="btn" style="display: inline-block; width: auto;">View</a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="grid-column: 1 / -1; text-align: center; padding: 3rem 1rem;">
                        <p style="font-size: 1.1rem; color: #999;">No comics available yet. Check back soon!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">Dark Mode</button>
    </footer>
</body>
</html>
