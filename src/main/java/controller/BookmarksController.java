package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.BookmarkDAO;
import dao.ComicDAO;
import model.Bookmark;
import model.Comic;
import model.User;

@WebServlet("/bookmarks")
public class BookmarksController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session != null) {
            User user = (User) session.getAttribute("user");

            if (user != null) {
                // Load bookmarks for user
                BookmarkDAO bookmarkDAO = new BookmarkDAO();
                List<Bookmark> bookmarks = bookmarkDAO.getBookmarksForUser(user.getId());

                // Load full comic details for each bookmark
                List<Comic> bookmarkedComics = new ArrayList<>();
                ComicDAO comicDAO = new ComicDAO();

                for (Bookmark bookmark : bookmarks) {
                    Comic comic = comicDAO.getComicById(bookmark.getComicId());
                    if (comic != null) {
                        bookmarkedComics.add(comic);
                    }
                }

                req.setAttribute("bookmarkedComics", bookmarkedComics);
            }
        }

        req.getRequestDispatcher("/bookmarks.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");
        String comicIdStr = req.getParameter("comicId");

        if (comicIdStr != null && !comicIdStr.isEmpty()) {
            try {
                int comicId = Integer.parseInt(comicIdStr);
                BookmarkDAO bookmarkDAO = new BookmarkDAO();

                if ("remove".equals(action)) {
                    // Remove bookmark
                    bookmarkDAO.removeBookmark(user.getId(), comicId);
                }

                // Redirect back to bookmarks page
                resp.sendRedirect(req.getContextPath() + "/bookmarks");
                return;

            } catch (NumberFormatException e) {
                System.err.println("Invalid comic ID: " + comicIdStr);
            }
        }

        // If something went wrong, redirect to bookmarks
        resp.sendRedirect(req.getContextPath() + "/bookmarks");
    }
}
