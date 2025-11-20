package controller;
import dao.ComicDAO;
import dao.ChapterDAO;
import dao.CommentDAO;
import dao.RatingDAO;
import dao.BookmarkDAO;
import model.Comic;
import model.Chapter;
import model.Comment;
import model.Rating;
import model.Bookmark;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ComicController extends HttpServlet {
    private ChapterDAO chapterDAO = new ChapterDAO();
    private CommentDAO commentDAO = new CommentDAO();
    private ComicDAO comicDAO = new ComicDAO();
    private RatingDAO ratingDAO = new RatingDAO();
    private BookmarkDAO bookmarkDAO = new BookmarkDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("viewChapter".equals(action)) {
            viewChapter(request, response);
        } else if ("viewComic".equals(action)) {
            viewComic(request, response);
        }
    }

    private void viewChapter(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int chapterId = Integer.parseInt(request.getParameter("chapterId"));
        Chapter chapter = chapterDAO.getChapterById(chapterId);
        List<Comment> comments = commentDAO.getCommentsByChapterId(chapterId);

        request.setAttribute("chapter", chapter);
        request.setAttribute("comments", comments);
        request.getRequestDispatcher("chapter.jsp").forward(request, response);
    }

    private void viewComic(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int comicId = Integer.parseInt(request.getParameter("comicId"));
        Comic comic = comicDAO.getComicById(comicId);
        List<Rating> ratings = ratingDAO.getRatingsByComicId(comicId);
        boolean isBookmarked = false;

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            int userId = ((User) session.getAttribute("user")).getId();
            isBookmarked = bookmarkDAO.isBookmarked(userId, comicId);
        }

        request.setAttribute("comic", comic);
        request.setAttribute("ratings", ratings);
        request.setAttribute("isBookmarked", isBookmarked);
        request.getRequestDispatcher("comic.jsp").forward(request, response);
    }

    private void addComment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please login to comment");
            return;
        }

        int chapterId = Integer.parseInt(request.getParameter("chapterId"));
        String content = request.getParameter("content");
        User user = (User) session.getAttribute("user");

        Comment comment = new Comment();
        comment.setUserId(user.getId());
        comment.setChapterId(chapterId);
        comment.setContent(content);

        commentDAO.addComment(comment);
        response.sendRedirect("chapter.jsp?chapterId=" + chapterId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("addRating".equals(action)) {
            addRating(request, response);
        } else if ("toggleBookmark".equals(action)) {
            toggleBookmark(request, response);
        } else if ("searchComics".equals(action)) {
            searchComics(request, response);
        }
    }

    private void addRating(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please login to rate");
            return;
        }

        int comicId = Integer.parseInt(request.getParameter("comicId"));
        int score = Integer.parseInt(request.getParameter("score"));
        User user = (User) session.getAttribute("user");

        Rating rating = new Rating();
        rating.setUserId(user.getId());
        rating.setComicId(comicId);
        rating.setScore(score);

        ratingDAO.addRating(rating);
        response.sendRedirect("comic.jsp?comicId=" + comicId);
    }

    private void toggleBookmark(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Please login to bookmark");
            return;
        }

        int comicId = Integer.parseInt(request.getParameter("comicId"));
        User user = (User) session.getAttribute("user");

        if (bookmarkDAO.isBookmarked(user.getId(), comicId)) {
            bookmarkDAO.removeBookmark(user.getId(), comicId);
        } else {
            Bookmark bookmark = new Bookmark();
            bookmark.setUserId(user.getId());
            bookmark.setComicId(comicId);
            bookmarkDAO.addBookmark(bookmark);
        }

        response.sendRedirect("comic.jsp?comicId=" + comicId);
    }

    private void searchComics(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        List<Comic> searchResults = comicDAO.searchComics(query);

        request.setAttribute("searchResults", searchResults);
        request.getRequestDispatcher("search.jsp").forward(request, response);
    }
}
