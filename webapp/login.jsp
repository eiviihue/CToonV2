<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CToon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <h2>Login to CToon</h2>
        <form action="${pageContext.request.contextPath}/auth" method="post">
            <div>
                <label for="username">Username or Email</label>
                <input type="text" id="username" name="username" placeholder="Enter your username or email" required>
            </div>
            <div>
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>
            <button type="submit">Login</button>
        </form>
        
        <div style="text-align: center; margin: 2rem 0;">
            <p>or continue as</p>
            <form action="${pageContext.request.contextPath}/auth" method="post" style="max-width: 300px;">
                <input type="hidden" name="guest" value="true">
                <button type="submit" class="btn-secondary">Login as Guest</button>
            </form>
        </div>

        <div style="text-align: center; margin-top: 2rem;">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/signup.jsp">Sign Up</a></p>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
