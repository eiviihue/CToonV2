<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Search Results</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
</head>
<body>
<%@ include file="navbar.jsp" %>
<main>
    <h2>Search Results</h2>
    <c:choose>
        <c:when test="${not empty searchResults}">
            <ul>
                <c:forEach items="${searchResults}" var="comic">
                    <li>
                        <a href="${pageContext.request.contextPath}/${fn:replace(fn:toLowerCase(comic.title),' ','-')}">
                            <c:out value="${comic.title}" />
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </c:when>
        <c:otherwise>
            <p>No results found.</p>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
