<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - CToon</title>
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
        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        .alert-error {
            background-color: #fee;
            border-left: 4px solid #f33;
            color: #933;
        }
        .alert-success {
            background-color: #efe;
            border-left: 4px solid #3f3;
            color: #393;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    
    <main>
        <h2>✨ Create Your CToon Account</h2>
        <p style="text-align: center; color: #666; margin-bottom: 2rem;">Join our community and start reading!</p>
        
        <% 
            String error = (String) request.getAttribute("error");
            String message = (String) request.getAttribute("message");
            if (error != null) {
        %>
            <div class="alert alert-error"><%= error %></div>
        <% 
            }
            if (message != null) {
        %>
            <div class="alert alert-success"><%= message %></div>
        <% 
            }
        %>
        
        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <input type="hidden" name="action" value="signup" />
            <div class="form-group">
                <label for="username">👤 Username</label>
                <input type="text" id="username" name="username" placeholder="Choose your username" required autocomplete="username">
            </div>
            <div class="form-group">
                <label for="email">📧 Email</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required autocomplete="email">
            </div>
            <div class="form-group">
                <label for="password">🔑 Password</label>
                <input type="password" id="password" name="password" placeholder="Create a strong password" required autocomplete="new-password">
                <small style="color: #666; display: block; margin-top: 0.3rem;">Minimum 6 characters</small>
            </div>
            <div class="form-group">
                <label for="confirm-password">✓ Confirm Password</label>
                <input type="password" id="confirm-password" name="confirm_password" placeholder="Confirm your password" required autocomplete="new-password">
            </div>
            <button type="submit" style="width: 100%; padding: 1rem; font-size: 1.1rem; margin: 1.5rem 0 0 0;">Create Account</button>
        </form>

        <div style="text-align: center; margin-top: 2rem; padding-top: 2rem; border-top: 1px solid #ddd;">
            <p style="margin: 0;">Already have an account? <a href="${pageContext.request.contextPath}/login.jsp" style="font-weight: 600;">Login here →</a></p>
        </div>
    </main>
    
    <footer>
        <button id="theme-toggle">🌙 Dark Mode</button>
    </footer>
</body>
</html>
