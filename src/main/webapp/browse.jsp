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
        
        <div class="browse-filters">
            <div class="filter-group">
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
                        <div class="card" style="padding: 0; overflow: hidden;">
                            <c:choose>
                                <c:when test="${not empty comic.coverPath}">
                                    <img src="${pageContext.request.contextPath}${comic.coverPath}" style="width: 100%; height: 200px; object-fit: cover; display: block;" alt="${comic.title}">
                                </c:when>
                                <c:otherwise>
                                    <div style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); height: 200px; display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem;">📚</div>
                                </c:otherwise>
                            </c:choose>
                            <h3 style="padding: 0 1.5rem; margin-top: 1rem;"><c:out value="${comic.title}"/></h3>
                            <p style="margin: 0.5rem 0; font-size: 0.9rem; color: #888; padding: 0 1.5rem;">
                                <c:forEach items="${comic.genres}" var="genre">
                                    <span class="badge badge-primary"><c:out value="${genre.name}"/></span>
                                </c:forEach>
                                <span style="float: right;"><c:out value="${comic.averageRating}"/>/5</span>
                            </p>
                            <p style="padding: 0 1.5rem;"><c:out value="${comic.description}"/></p>
                            <p style="font-size: 0.85rem; color: #aaa; margin: 0.5rem 0; padding: 0 1.5rem;"><c:out value="${comic.views}"/> views</p>
                            <div style="padding: 0 1.5rem 1.5rem;">
                                <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}" class="btn" style="display: inline-block; width: auto;">View</a>
                            </div>
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
</body>
</html>
