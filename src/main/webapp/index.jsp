<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="dao.ComicDAO" %>
<%@ page import="model.Comic" %>
<%@ page import="java.util.List" %>
<%
    // Load comics data if not already loaded
    try {
        if (request.getAttribute("recentComics") == null) {
            ComicDAO comicDAO = new ComicDAO();
            List<Comic> recentComics = comicDAO.getRecentComics();
            List<Comic> trendingComics = comicDAO.getTrendingComics();
            request.setAttribute("recentComics", recentComics != null ? recentComics : new java.util.ArrayList<>());
            request.setAttribute("trendingComics", trendingComics != null ? trendingComics : new java.util.ArrayList<>());
        }
    } catch (Exception e) {
        // Log but don't fail - display sample data instead
        e.printStackTrace();
        request.setAttribute("recentComics", new java.util.ArrayList<>());
        request.setAttribute("trendingComics", new java.util.ArrayList<>());
    }
%>
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
            <h2>Recently Updated</h2>
            <div class="cards-grid">
                <c:choose>
                    <c:when test="${not empty recentComics}">
                        <c:forEach items="${recentComics}" var="comic" varStatus="status">
                            <div class="card" style="padding: 0; overflow: hidden;">
                                <c:choose>
                                    <c:when test="${not empty comic.coverPath}">
                                        <img src="${pageContext.request.contextPath}${comic.coverPath}" style="width: 100%; height: 200px; object-fit: cover; display: block;" alt="${comic.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); height: 200px; display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem;">📚</div>
                                    </c:otherwise>
                                </c:choose>
                                <h3 style="padding: 0 1.5rem; margin-top: 1rem;"><c:out value="${comic.title}"/></h3>
                                <p style="padding: 0 1.5rem;"><c:out value="${comic.description}"/></p>
                                <p style="font-size: 0.85rem; color: #aaa; margin: 0.5rem 0; padding: 0 1.5rem;"><c:out value="${comic.views}"/> views</p>
                                <span class="badge badge-primary" style="margin-left: 1.5rem;">Featured</span>
                                <div style="margin-top: 0.8rem; padding: 0 1.5rem 1.5rem;">
                                    <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}" class="btn" style="display: inline-block; width: auto;">Read Now →</a>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="card">
                            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); height: 100px; border-radius: 8px; margin: -1.5rem -1.5rem 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.2rem; font-weight: bold;">BOOK</div>
                            <h3>Sample Comic 1</h3>
                            <p>An exciting adventure awaits...</p>
                            <span class="badge badge-primary">Action</span>
                            <div style="margin-top: 1rem;">
                                <a href="${pageContext.request.contextPath}/comic.jsp" class="btn" style="display: inline-block; width: auto;">Read Now →</a>
                            </div>
                        </div>
                        <div class="card">
                            <div style="background: linear-gradient(135deg, #764ba2 0%, #667eea 100%); height: 100px; border-radius: 8px; margin: -1.5rem -1.5rem 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.2rem; font-weight: bold;">NIGHT</div>
                            <h3>Sample Comic 2</h3>
                            <p>A mysterious tale unfolds...</p>
                            <span class="badge badge-primary">Mystery</span>
                            <div style="margin-top: 1rem;">
                                <a href="${pageContext.request.contextPath}/comic.jsp" class="btn" style="display: inline-block; width: auto;">Read Now →</a>
                            </div>
                        </div>
                        <div class="card">
                            <div style="background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); height: 100px; border-radius: 8px; margin: -1.5rem -1.5rem 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.2rem; font-weight: bold;">ACTION</div>
                            <h3>Sample Comic 3</h3>
                            <p>Epic battles and dramatic twists...</p>
                            <span class="badge badge-success">Fantasy</span>
                            <div style="margin-top: 1rem;">
                                <a href="${pageContext.request.contextPath}/comic.jsp" class="btn" style="display: inline-block; width: auto;">Read Now →</a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <section id="trending">
            <h2>Trending Now</h2>
            <div class="cards-grid">
                <c:choose>
                    <c:when test="${not empty trendingComics}">
                        <c:forEach items="${trendingComics}" var="comic" varStatus="status">
                            <div class="card">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                    <div>
                                        <h3 style="margin: 0;"><c:out value="${comic.title}"/></h3>
                                        <span class="badge badge-danger">#${status.count}</span>
                                    </div>
                                </div>
                                <p><c:out value="${comic.description}"/></p>
                                <p style="font-size: 0.9rem; color: #888;"><c:out value="${comic.averageRating}"/>/5</p>
                                <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}" class="btn" style="display: inline-block; width: auto;">Check Out →</a>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="card">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                <div>
                                    <h3 style="margin: 0;">Trending Comic 1</h3>
                                    <span class="badge badge-danger">#1</span>
                                </div>
                            </div>
                            <p>Millions of views this week!</p>
                            <p style="font-size: 0.9rem; color: #888;">4.8/5 (2,340 reviews)</p>
                            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn" style="display: inline-block; width: auto;">Check Out →</a>
                        </div>
                        <div class="card">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                <div>
                                    <h3 style="margin: 0;">Trending Comic 2</h3>
                                    <span class="badge badge-primary">#2</span>
                                </div>
                            </div>
                            <p>Everyone's talking about this...</p>
                            <p style="font-size: 0.9rem; color: #888;">4.7/5 (1,890 reviews)</p>
                            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn" style="display: inline-block; width: auto;">Check Out →</a>
                        </div>
                        <div class="card">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                <div>
                                    <h3 style="margin: 0;">Trending Comic 3</h3>
                                    <span class="badge badge-success">#3</span>
                                </div>
                            </div>
                            <p>Don't miss out on the hype!</p>
                            <p style="font-size: 0.9rem; color: #888;">4.6/5 (1,560 reviews)</p>
                            <a href="${pageContext.request.contextPath}/comic.jsp" class="btn" style="display: inline-block; width: auto;">Check Out →</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>
    
    <!-- theme toggle moved to navbar -->
</body>
</html>
