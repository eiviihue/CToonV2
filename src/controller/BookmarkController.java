package controller;
import dao.BookmarkDAO;
import dao.ComicDAO;
import model.Bookmark;
import model.Comic;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class BookmarkController extends HttpServlet {
    // Handles bookmark page and actions
    private BookmarkDAO bookmarkDAO = new BookmarkDAO();
    private ComicDAO comicDAO = new ComicDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please login to view bookmarks");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<Bookmark> bookmarks = bookmarkDAO.getBookmarksByUserId(user.getId());
        List<Comic> bookmarkedComics = comicDAO.getComicsByBookmarks(bookmarks);

        request.setAttribute("bookmarkedComics", bookmarkedComics);
        request.getRequestDispatcher("bookmarks.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please login to manage bookmarks");
            return;
        }

        String action = request.getParameter("action");
        User user = (User) session.getAttribute("user");

        if ("removeBookmark".equals(action)) {
            int comicId = Integer.parseInt(request.getParameter("comicId"));
            bookmarkDAO.removeBookmark(user.getId(), comicId);
        }

        response.sendRedirect("bookmarks.jsp");
    }
}
