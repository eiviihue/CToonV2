<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CToon - Explore Comics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <h1>Welcome to CToon</h1>
        <p>Discover amazing comics and manga from creators around the world</p>
        
        <section id="recent-comics">
            <h2>📚 Recently Updated</h2>
            <div class="cards-grid">
                <c:choose>
                    <c:when test="${not empty recentComics}">
                        <c:forEach items="${recentComics}" var="comic">
                            <div class="card">
                                <h3>${comic.title}</h3>
                                <p>${comic.description}</p>
                                <p><small>Author: ${comic.author}</small></p>
                                <p><small>⭐ ${comic.averageRating}/5 | Views: ${comic.views}</small></p>
                                <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}" class="btn">Read Now</a>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="card">
                            <h3>Sample Comic 1</h3>
                            <p>An exciting adventure awaits...</p>
                            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">Read Now</a>
                        </div>
                        <div class="card">
                            <h3>Sample Comic 2</h3>
                            <p>A mysterious tale unfolds...</p>
                            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">Read Now</a>
                        </div>
                        <div class="card">
                            <h3>Sample Comic 3</h3>
                            <p>Epic battles and dramatic twists...</p>
                            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">Read Now</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <section id="trending">
            <h2>🔥 Trending Now</h2>
            <div class="cards-grid">
                <c:choose>
                    <c:when test="${not empty trendingComics}">
                        <c:forEach items="${trendingComics}" var="comic">
                            <div class="card">
                                <h3>${comic.title}</h3>
                                <p>${comic.description}</p>
                                <p><small>Author: ${comic.author}</small></p>
                                <p><small>⭐ ${comic.averageRating}/5 | Views: ${comic.views}</small></p>
                                <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}" class="btn">Check Out</a>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="card">
                            <h3>Trending Comic 1</h3>
                            <p>Millions of views this week!</p>
                            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">Check Out</a>
                        </div>
                        <div class="card">
                            <h3>Trending Comic 2</h3>
                            <p>Everyone's talking about this...</p>
                            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">Check Out</a>
                        </div>
                        <div class="card">
                            <h3>Trending Comic 3</h3>
                            <p>Don't miss out on the hype!</p>
                            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn">Check Out</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
