<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results - CToon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <main>
        <h2>Search Results</h2>
        <c:if test="${not empty param.q}">
            <p style="color: #666; margin-bottom: 2rem;">
                Showing results for: <strong>"<c:out value="${param.q}"/>"</strong>
            </p>
        </c:if>
        
        <c:choose>
            <c:when test="${not empty searchResults}">
                <div class="cards-grid">
                    <c:forEach items="${searchResults}" var="comic">
                        <div class="card">
                            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); height: 120px; border-radius: 8px; margin: -1.5rem -1.5rem 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.2rem; font-weight: bold;">
                                📚
                            </div>
                            <h3><c:out value="${comic.title}" /></h3>
                            <p><c:out value="${comic.description}" default="No description available." /></p>
                            <div style="margin-top: 1rem; display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 0.85rem; color: #888;">
                                    <c:out value="${comic.views}" default="0"/> views
                                </span>
                                <a href="${pageContext.request.contextPath}/comic-detail?id=${comic.id}" class="btn" style="display: inline-block; width: auto;">View</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card" style="text-align: center; padding: 3rem 2rem;">
                    <div style="font-size: 4rem; margin-bottom: 1rem;">🔍</div>
                    <h3 style="color: #667eea; margin-bottom: 0.5rem;">No Results Found</h3>
                    <p style="color: #666;">We couldn't find any comics matching your search. Try different keywords or browse our collection.</p>
                    <div style="margin-top: 2rem;">
                        <a href="${pageContext.request.contextPath}/browse" class="btn">Browse All Comics</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>
