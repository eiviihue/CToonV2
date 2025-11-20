package controller;
import dao.UserDAO;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("/login");
            return;
        }
        // Default: show login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("signup".equals(action)) {
            handleSignup(request, response);
        } else if ("guest".equals(action)) {
            handleGuestLogin(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.authenticate(username, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect("/");
        } else {
            response.sendRedirect("/login?error=Invalid credentials");
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);

        userDAO.create(user);
        response.sendRedirect("/login?success=Account created");
    }

    private void handleGuestLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User guest = new User();
        guest.setGuest(true);

        HttpSession session = request.getSession();
        session.setAttribute("user", guest);
        response.sendRedirect("/");
    }

    // Removed stray @Override and comment
}
