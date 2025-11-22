<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav>
    <a href="${pageContext.request.contextPath}/" class="logo">CToon</a>
    <button class="mobile-menu-toggle" onclick="toggleMobileMenu()" aria-label="Toggle menu">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="3" y1="12" x2="21" y2="12"></line>
            <line x1="3" y1="6" x2="21" y2="6"></line>
            <line x1="3" y1="18" x2="21" y2="18"></line>
        </svg>
    </button>
    <ul class="nav-links" id="navLinks">
        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/browse">Browse</a></li>
        <li><a href="${pageContext.request.contextPath}/profile">Profile</a></li>
        <li class="search-wrapper">
            <form action="${pageContext.request.contextPath}/search" method="get" style="width: 100%; margin: 0; padding: 0; background: transparent; box-shadow: none;">
                <div style="position: relative; display: flex; align-items: center; width: 100%;">
                    <input type="text" name="q" placeholder="Search comics..." style="padding: 0.6rem 1rem; border-radius: 20px; border: 2px solid rgba(255,255,255,0.3); background: rgba(255,255,255,0.1); color: white; width: 100%; transition: all 0.3s ease; backdrop-filter: blur(10px);" />
                    <button type="submit" style="position: absolute; right: 8px; background: transparent; border: none; color: rgba(255,255,255,0.8); cursor: pointer; padding: 0.3rem 0.6rem; font-size: 0.9rem;"></button>
                </div>
            </form>
        </li>
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <li><a href="${pageContext.request.contextPath}/bookmarks">Bookmarks</a></li>
                <li><a href="${pageContext.request.contextPath}/profile">${sessionScope.user.username}</a></li>
                <li>
                    <form method="get" action="${pageContext.request.contextPath}/logout" style="margin: 0; padding: 0; background: transparent; box-shadow: none;">
                        <button type="submit" class="btn" style="cursor: pointer;">Sign Out</button>
                    </form>
                </li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/login.jsp" class="btn">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/signup.jsp" class="btn">Sign Up</a></li>
            </c:otherwise>
        </c:choose>
        <li>
            <button id="theme-toggle" title="Toggle theme" class="btn" style="cursor: pointer;">
                <span id="theme-icon">🌙</span>&nbsp;<span id="theme-text">Dark</span>
            </button>
        </li>
    </ul>
</nav>

<script>
function toggleMobileMenu() {
    const navLinks = document.getElementById('navLinks');
    navLinks.classList.toggle('active');
}

// Close mobile menu when clicking outside
document.addEventListener('click', function(event) {
    const nav = document.querySelector('nav');
    const navLinks = document.getElementById('navLinks');
    const menuToggle = document.querySelector('.mobile-menu-toggle');
    
    if (!nav.contains(event.target)) {
        navLinks.classList.remove('active');
    }
});

// Close mobile menu on link click
document.querySelectorAll('.nav-links a, .nav-links button[type="submit"]').forEach(link => {
    link.addEventListener('click', function() {
        document.getElementById('navLinks').classList.remove('active');
    });
});
</script>
