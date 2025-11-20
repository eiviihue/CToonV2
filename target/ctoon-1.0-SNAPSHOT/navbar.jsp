<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav>
    <a href="${pageContext.request.contextPath}/" class="logo">🎨 CToon</a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/browse.jsp">Browse</a></li>
        <li><a href="${pageContext.request.contextPath}/profile.jsp">Profile</a></li>
        <li><input type="text" placeholder="Search comics..." style="padding: 0.5rem; border-radius: 20px; border: none; width: 200px;" /></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp" class="btn">Login</a></li>
    </ul>
</nav>
