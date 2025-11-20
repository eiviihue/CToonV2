package controller;
import dao.UserDAO;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class ProfileController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    // Handles profile view and edit
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please login to access your profile");
            return;
        }

        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please login to update your profile");
            return;
        }

        User user = (User) session.getAttribute("user");
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        String profilePhoto = request.getParameter("profilePhoto");

        user.setName(name);
        user.setPassword(password);
        user.setProfilePhoto(profilePhoto);

        userDAO.update(user);
        session.setAttribute("user", user);
        response.sendRedirect("profile.jsp?success=Profile updated successfully");
    }
}
