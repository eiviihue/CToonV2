<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav>
    <ul>
        <li><a href="home.jsp">Home</a></li>
        <li><a href="ProfileController">Profile</a></li>
        <li><a href="BookmarkController">Bookmarks</a></li>
        <li>
            <form action="ComicController" method="get">
                <input type="text" name="query" placeholder="Search comics...">
                <button type="submit">Search</button>
            </form>
        </li>
        <c:choose>
            <c:when test="${not empty user}">
                <li><a href="AuthController?action=logout">Logout</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="login.jsp">Login</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>