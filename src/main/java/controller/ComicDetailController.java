package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ChapterDAO;
import dao.ComicDAO;
import dao.RatingDAO;
import dao.CommentDAO;
import dao.UserDAO;
import model.Chapter;
import model.Comic;

@WebServlet("/comic-detail")
public class ComicDetailController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String comicIdStr = request.getParameter("id");
        if (comicIdStr != null && !comicIdStr.isEmpty()) {
            try {
                int comicId = Integer.parseInt(comicIdStr);
                ComicDAO comicDAO = new ComicDAO();
                Comic comic = comicDAO.getComicById(comicId);

                if (comic != null) {
                    request.setAttribute("comic", comic);

                    // Get chapters for this comic
                    ChapterDAO chapterDAO = new ChapterDAO();
                    List<Chapter> chapters = chapterDAO.getChaptersByComicId(comicId);
                    request.setAttribute("chapters", chapters);
                    // Get ratings and comments for this comic
                    RatingDAO ratingDAO = new RatingDAO();
                    List<model.Rating> ratings = ratingDAO.getRatingsByComicId(comicId);
                    request.setAttribute("ratings", ratings);
                    // compute average rating from ratings list if available
                    double avg = 0.0;
                    if (ratings != null && !ratings.isEmpty()) {
                        int sum = 0;
                        for (model.Rating r : ratings) sum += r.getStars();
                        avg = (double) sum / ratings.size();
                    }
                    request.setAttribute("avgRating", String.format("%.2f", avg));

                    CommentDAO commentDAO = new CommentDAO();
                    List<model.Comment> comments = commentDAO.getCommentsByComicId(comicId);
                    request.setAttribute("comments", comments);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("/comic.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // Require login for posting
        HttpSession session = request.getSession(false);
        model.User user = null;
        if (session != null) {
            user = (model.User) session.getAttribute("user");
        }

        if ("addRating".equals(action)) {
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please+login+to+rate");
                return;
            }
            String comicIdStr = request.getParameter("comicId");
            String starsStr = request.getParameter("stars");
            try {
                int comicId = Integer.parseInt(comicIdStr);
                int stars = Integer.parseInt(starsStr);
                dao.RatingDAO ratingDAO = new dao.RatingDAO();
                model.Rating rating = new model.Rating();
                rating.setUserId(user.getId());
                rating.setComicId(comicId);
                rating.setStars(stars);
                ratingDAO.addRating(rating);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/comic-detail?id=" + request.getParameter("comicId"));
            return;
        } else if ("addComment".equals(action)) {
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please+login+to+comment");
                return;
            }
            String chapterIdStr = request.getParameter("chapterId");
            String content = request.getParameter("content");
            try {
                int chapterId = Integer.parseInt(chapterIdStr);
                dao.CommentDAO commentDAO = new dao.CommentDAO();
                model.Comment comment = new model.Comment();
                comment.setUserId(user.getId());
                comment.setChapterId(chapterId);
                comment.setContent(content);
                commentDAO.addComment(comment);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/comic-detail?id=" + request.getParameter("comicId"));
            return;
        }
        // fallback: redirect back to comic
        response.sendRedirect(request.getContextPath() + "/comic-detail?id=" + request.getParameter("comicId"));
    }
}
