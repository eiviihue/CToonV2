<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookmarks - CToon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <h2>❤️ My Bookmarks</h2>
        
        <c:choose>
            <c:when test="${empty sessionScope.user}">
                <div class="card" style="text-align: center; padding: 3rem 2rem;">
                    <div style="font-size: 4rem; margin-bottom: 1rem;">🔒</div>
                    <h3 style="color: #667eea; margin-bottom: 0.5rem;">Login Required</h3>
                    <p style="color: #666;">Please log in to view your bookmarked comics.</p>
                    <div style="margin-top: 2rem;">
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn">Login Now</a>
                    </div>
                </div>
            </c:when>
            <c:when test="${not empty bookmarkedComics}">
                <p style="color: #666; margin-bottom: 2rem;">
                    You have <strong>${bookmarkedComics.size()}</strong> bookmarked comic(s)
                </p>
                <div class="cards-grid">
                    <c:forEach items="${bookmarkedComics}" var="comic" varStatus="status">
                        <div class="card">
                            <div style="background: linear-gradient(135deg, #e94560 0%, #ff6b9d 100%); height: 120px; border-radius: 8px; margin: -1.5rem -1.5rem 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 2rem;">
                                ❤️
                            </div>
                            <h3><c:out value="${comic.title}"/></h3>
                            <p><c:out value="${comic.description}"/></p>
                            <div style="margin-top: 1rem;">
                                <p style="font-size: 0.85rem; color: #888; margin-bottom: 0.5rem;">
                                    <c:out value="${comic.views}" default="0"/> views • 
                                    <c:out value="${comic.averageRating}" default="0"/> ⭐
                                </p>
                                <div class="btn-group" style="display: flex; gap: 0.5rem;">
                                    <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}" class="btn" style="flex: 1; text-align: center;">
                                        Read Now
                                    </a>
                                    <form method="post" action="${pageContext.request.contextPath}/bookmarks" style="flex: 1; margin: 0; padding: 0; background: transparent; box-shadow: none;">
                                        <input type="hidden" name="action" value="remove" />
                                        <input type="hidden" name="comicId" value="${comic.id}" />
                                        <button type="submit" class="btn btn-secondary" style="width: 100%;">
                                            Remove
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card" style="text-align: center; padding: 3rem 2rem;">
                    <div style="font-size: 4rem; margin-bottom: 1rem;">📚</div>
                    <h3 style="color: #667eea; margin-bottom: 0.5rem;">No Bookmarks Yet</h3>
                    <p style="color: #666;">Start bookmarking your favorite comics to keep track of them!</p>
                    <div style="margin-top: 2rem;">
                        <a href="${pageContext.request.contextPath}/browse" class="btn">Browse Comics</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>
