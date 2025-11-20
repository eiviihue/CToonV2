<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - CToon</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h2>Login</h2>
    <form action="auth" method="post">
        <input type="text" name="username" placeholder="Username or Email" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <button type="submit">Login</button>
    </form>
    <form action="auth" method="post">
        <input type="hidden" name="guest" value="true">
        <button type="submit">Login as Guest</button>
    </form>
    <a href="signup.jsp">Sign Up</a>
</body>
</html>
