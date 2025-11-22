package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDAO;
import model.User;

/**
 * Servlet for handling login and signup form submissions
 * Manages user authentication and session creation
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("signup".equals(action)) {
            handleSignup(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    /**
     * Handle login form submission
     * Validates credentials and creates session if valid
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Authenticate user
            User user = userDAO.authenticate(username, password);

            if (user != null) {
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("email", user.getEmail());

                // Redirect to home page
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                // Authentication failed
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during login. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    /**
     * Handle signup form submission
     * Creates a new user account if validation passes
     */
    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Validate input
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username is required");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password is required");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        try {
            // Check if username already exists
            User existingUser = userDAO.getUserByUsername(username);
            if (existingUser != null) {
                request.setAttribute("error", "Username already taken");
                request.getRequestDispatcher("/signup.jsp").forward(request, response);
                return;
            }

            // Create new user
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPassword(password);

            userDAO.create(newUser);

            // Auto-login after signup
            User createdUser = userDAO.authenticate(username, password);
            if (createdUser != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", createdUser.getId());
                session.setAttribute("username", createdUser.getUsername());
                session.setAttribute("email", createdUser.getEmail());

                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                // Redirect to login if auto-login fails
                request.setAttribute("message", "Account created successfully! Please log in.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("Error during signup: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during signup. Please try again.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }
}
