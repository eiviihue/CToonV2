<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Profile</title>
</head>
<body>
<h1>Edit Profile</h1>
<form action="ProfileController" method="post">
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" value="${user.name}" required><br>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required><br>

    <label for="profilePhoto">Profile Photo URL:</label>
    <input type="text" id="profilePhoto" name="profilePhoto" value="${user.profilePhoto}"><br>

    <button type="submit">Update Profile</button>
</form>

<c:if test="${not empty param.success}">
    <p style="color:green;">${param.success}</p>
</c:if>

<c:if test="${not empty param.error}">
    <p style="color:red;">${param.error}</p>
</c:if>

<a href="home.jsp">Back to Home</a>
</body>
</html>