package controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDAO;
import model.User;

/**
 * Servlet for User CRUD operations
 * Handles Create, Read, Update, Delete operations for users
 */
@WebServlet("/api/users/*")
public class UserController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json; charset=UTF-8");

        if (pathInfo == null || pathInfo.equals("/")) {
            createUser(request, response);
        } else if (pathInfo.equals("/login")) {
            loginUser(request, response);
        } else if (pathInfo.equals("/logout")) {
            logoutUser(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            sendJsonError(response, "Endpoint not found");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json; charset=UTF-8");

        if (pathInfo != null && pathInfo.equals("/profile")) {
            getUserProfile(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            sendJsonError(response, "Endpoint not found");
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json; charset=UTF-8");

        if (pathInfo != null && !pathInfo.equals("/")) {
            updateUser(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJsonError(response, "User ID required");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json; charset=UTF-8");

        if (pathInfo != null && !pathInfo.equals("/")) {
            deleteUser(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJsonError(response, "User ID required");
        }
    }

    /**
     * Create a new user
     * POST /api/users?username=...&email=...&password=...
     */
    private void createUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();

        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (username == null || email == null || password == null ||
                    username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                sendJsonError(response, "Missing required fields: username, email, password");
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password);

            userDAO.create(user);

            response.setStatus(HttpServletResponse.SC_CREATED);
            out.println("{\"message\":\"User created successfully\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            sendJsonError(response, "Error creating user: " + e.getMessage());
        }
    }

    /**
     * Login user
     * POST /api/users/login?username=...&password=...
     */
    private void loginUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (username == null || password == null ||
                    username.trim().isEmpty() || password.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                sendJsonError(response, "Username and password required");
                return;
            }

            User user = userDAO.authenticate(username, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("email", user.getEmail());

                response.setStatus(HttpServletResponse.SC_OK);
                out.println("{\"message\":\"Login successful\",\"userId\":" + user.getId() +
                        ",\"username\":\"" + user.getUsername() + "\",\"email\":\"" + user.getEmail() + "\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                sendJsonError(response, "Invalid username or password");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            sendJsonError(response, "Error during login: " + e.getMessage());
        }
    }

    /**
     * Logout user
     * POST /api/users/logout
     */
    private void logoutUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            response.setStatus(HttpServletResponse.SC_OK);
            out.println("{\"message\":\"Logout successful\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            sendJsonError(response, "Error during logout: " + e.getMessage());
        }
    }

    /**
     * Get current user profile from session
     * GET /api/users/profile
     */
    private void getUserProfile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                sendJsonError(response, "Not logged in");
                return;
            }

            int userId = (int) session.getAttribute("userId");
            String username = (String) session.getAttribute("username");
            String email = (String) session.getAttribute("email");

            response.setStatus(HttpServletResponse.SC_OK);
            out.println("{\"message\":\"Profile retrieved\",\"userId\":" + userId +
                    ",\"username\":\"" + username + "\",\"email\":\"" + email + "\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            sendJsonError(response, "Error retrieving profile: " + e.getMessage());
        }
    }

    /**
     * Update user information
     * PUT /api/users/profile?email=...&password=...
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                sendJsonError(response, "Not logged in");
                return;
            }

            int userId = (int) session.getAttribute("userId");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if ((email == null || email.trim().isEmpty()) &&
                    (password == null || password.trim().isEmpty())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                sendJsonError(response, "No fields to update");
                return;
            }

            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                sendJsonError(response, "User not found");
                return;
            }

            if (email != null && !email.trim().isEmpty()) {
                user.setEmail(email);
            }
            if (password != null && !password.trim().isEmpty()) {
                user.setPassword(password);
            }

            userDAO.update(user);

            response.setStatus(HttpServletResponse.SC_OK);
            out.println("{\"message\":\"User updated successfully\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            sendJsonError(response, "Error updating user: " + e.getMessage());
        }
    }

    /**
     * Delete user
     * DELETE /api/users/profile
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                sendJsonError(response, "Not logged in");
                return;
            }

            int userId = (int) session.getAttribute("userId");

            userDAO.delete(userId);

            session.invalidate();
            response.setStatus(HttpServletResponse.SC_OK);
            out.println("{\"message\":\"User deleted successfully\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            sendJsonError(response, "Error deleting user: " + e.getMessage());
        }
    }

    /**
     * Helper method to send JSON error responses
     */
    private void sendJsonError(HttpServletResponse response, String errorMessage) throws IOException {
        PrintWriter out = response.getWriter();
        out.println("{\"error\":\"" + errorMessage.replace("\"", "\\\"") + "\"}");
    }
}
