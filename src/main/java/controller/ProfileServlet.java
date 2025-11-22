package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
            return;
        }

        // TODO: load reading history if available
        // For now, just forward to profile page

        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }
}
