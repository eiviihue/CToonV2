<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="navbar.jsp" %>
<html>
<head>
    <title>Home</title>
</head>
<body>
<h1>Welcome to CToon</h1>
<h2>Recent Updates</h2>
<ul>
    <c:forEach var="comic" items="${recentComics}">
        <li>
            <a href="ComicController?action=viewComic&comicId=${comic.id}">${comic.title}</a>
            <span> - Average Rating: ${comic.averageRating}</span>
        </li>
    </c:forEach>
</ul>

<!-- Dark/Light Mode Toggle -->
<button onclick="toggleMode()">Toggle Dark/Light Mode</button>
</body>
</html>