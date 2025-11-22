<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - CToon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <h2>My Profile</h2>

        <div class="profile-grid">
            <div class="card" style="text-align: center;">
                <div style="font-size: 4rem; margin-bottom: 1rem;">👤</div>
                <h3>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">${sessionScope.user.username}</c:when>
                        <c:otherwise>Guest</c:otherwise>
                    </c:choose>
                </h3>
                <p style="color: #667eea; font-weight: 600;">@<c:out value="${sessionScope.user.username}" default="guest"/></p>
                <p style="color: #666;">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <c:out value="${sessionScope.user.email}" default="No email provided"/>
                        </c:when>
                        <c:otherwise>Guest User</c:otherwise>
                    </c:choose>
                </p>
                <c:if test="${not empty sessionScope.user}">
                    <button class="btn" style="width: 100%; margin-top: 1rem;">Edit Profile</button>
                </c:if>
            </div>

            <div>
                <div class="card">
                    <h3>About</h3>
                    <p>A comic enthusiast who loves exploring new stories and supporting talented creators.</p>
                </div>

                <div class="card">
                    <h3>📖 Reading History</h3>
                    <c:choose>
                        <c:when test="${not empty requestScope.history}">
                            <ul style="list-style: none;">
                                <c:forEach var="entry" items="${requestScope.history}">
                                    <li style="padding: 0.5rem 0;"><a href="${pageContext.request.contextPath}/comic?id=${entry.comicId}">${entry.title}</a> - Last read ${entry.lastRead}</li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <p>No reading history yet.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="card">
                    <h3>❤️ Bookmarks</h3>
                    <c:choose>
                        <c:when test="${not empty requestScope.bookmarks}">
                            <ul style="list-style: none;">
                                <c:forEach var="bm" items="${requestScope.bookmarks}">
                                    <li style="padding: 0.5rem 0;"><a href="${pageContext.request.contextPath}/comic?id=${bm.comicId}">${bm.title}</a></li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${not empty sessionScope.user}">
                                <p>You have no bookmarks yet.</p>
                            </c:if>
                            <c:if test="${empty sessionScope.user}">
                                <p><a href="${pageContext.request.contextPath}/login.jsp">Log in</a> to see your bookmarks.</p>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
    
    <!-- theme toggle moved to navbar -->
</body>
</html>
