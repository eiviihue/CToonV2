<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav>
    <a href="${pageContext.request.contextPath}/" class="logo">🎨 CToon</a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/browse">Browse</a></li>
        <li><a href="${pageContext.request.contextPath}/profile.jsp">Profile</a></li>
        <li>
            <div style="position: relative; display: flex; align-items: center;">
                <input type="text" placeholder="Search comics..." style="padding: 0.6rem 1rem; border-radius: 20px; border: 2px solid rgba(255,255,255,0.3); background: rgba(255,255,255,0.1); color: white; width: 200px; transition: all 0.3s ease; backdrop-filter: blur(10px);" />
                <span style="position: absolute; right: 12px; color: rgba(255,255,255,0.6); cursor: pointer;">🔍</span>
            </div>
        </li>
        <li><a href="${pageContext.request.contextPath}/login.jsp" class="btn">Login</a></li>
    </ul>
</nav>
