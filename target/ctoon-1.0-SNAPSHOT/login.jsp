<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CToon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/theme.js"></script>
    <style>
        main form {
            max-width: 420px;
            margin: 2rem auto;
        }
        .form-group input {
            width: 100% !important;
        }
        .form-action {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }
        .form-action button {
            flex: 1;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <h2>🔐 Login to CToon</h2>
        <p style="text-align: center; color: #666; margin-bottom: 2rem;">Welcome back! Please login to your account</p>
        
        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <input type="hidden" name="action" value="login" />
            <div class="form-group">
                <label for="username">👤 Username or Email</label>
                <input type="text" id="username" name="username" placeholder="Enter your username or email" required autocomplete="username">
            </div>
            <div class="form-group">
                <label for="password">🔑 Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required autocomplete="current-password">
            </div>
            
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <label style="display: flex; align-items: center; font-weight: normal;">
                    <input type="checkbox" name="remember" style="width: auto; margin-right: 0.5rem;" />
                    Remember me
                </label>
                <a href="#" style="font-size: 0.9rem;">Forgot password?</a>
            </div>
            
            <button type="submit" style="width: 100%; padding: 1rem; font-size: 1.1rem; margin: 0;">Login Now</button>
        </form>
        
        <div style="text-align: center; margin: 2rem 0;">
            <p style="margin: 0; color: #666;">Unauthenticated users can browse as guests</p>
        </div>

        <div style="text-align: center; margin-top: 2.5rem; padding-top: 2rem; border-top: 1px solid #ddd;">
            <p style="margin: 0;">Don't have an account? <a href="${pageContext.request.contextPath}/signup.jsp" style="font-weight: 600;">Sign up now →</a></p>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
