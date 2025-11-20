<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav>
    <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/profile">Profile</a></li>
        <li><a href="/bookmarks">Bookmarks</a></li>
        <li>
            <form action="/" method="get">
                <input type="text" name="query" placeholder="Search comics...">
                <button type="submit">Search</button>
            </form>
        </li>
        <c:choose>
            <c:when test="${not empty user}">
                <li><a href="/LoginServlet?action=logout">Logout</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="/LoginServlet">Login</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>