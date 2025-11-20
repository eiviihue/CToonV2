<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <form action="/login" method="post">
        <input type="hidden" name="action" value="login" />
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required />
        <br />
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required />
        <br />
        <button type="submit">Login</button>
    </form>
    <a href="/signup">Sign up</a>
    <c:if test="${not empty param.error}">
        <p style="color:red;">${param.error}</p>
    </c:if>
    <c:if test="${not empty param.success}">
        <p style="color:green;">${param.success}</p>
    </c:if>
</body>
</html>
