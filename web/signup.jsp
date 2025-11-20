<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up - CToon</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h2>Sign Up</h2>
    <form action="auth" method="post">
        <input type="text" name="username" placeholder="Username" required><br>
        <input type="email" name="email" placeholder="Email" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <button type="submit">Sign Up</button>
    </form>
    <a href="login.jsp">Login</a>
</body>
</html>
