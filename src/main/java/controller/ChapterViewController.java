package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ChapterDAO;
import dao.ComicDAO;
import dao.CommentDAO;
import model.Chapter;
import model.Comic;
import model.Comment;
import model.Page;

@WebServlet("/chapter")
public class ChapterViewController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String chapterIdStr = request.getParameter("id");

        if (chapterIdStr == null || chapterIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            int chapterId = Integer.parseInt(chapterIdStr);

            ChapterDAO chapterDAO = new ChapterDAO();
            Chapter chapter = chapterDAO.getChapterById(chapterId);

            if (chapter == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Get comic info
            ComicDAO comicDAO = new ComicDAO();
            Comic comic = comicDAO.getComicById(chapter.getComicId());

            // Get pages
            List<Page> pages = chapterDAO.getPagesByChapterId(chapterId);

            // Get all chapters for navigation
            List<Chapter> chapters = chapterDAO.getChaptersByComicId(chapter.getComicId());

            // Get comments for this chapter
            CommentDAO commentDAO = new CommentDAO();
            List<Comment> comments = commentDAO.getCommentsByChapterId(chapterId);

            request.setAttribute("comic", comic);
            request.setAttribute("chapter", chapter);
            request.setAttribute("pages", pages);
            request.setAttribute("chapters", chapters);
            request.setAttribute("comments", comments);

            request.getRequestDispatcher("/chapter.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        model.User user = null;
        if (session != null) {
            user = (model.User) session.getAttribute("user");
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please+login+to+comment");
            return;
        }

        String action = request.getParameter("action");

        if ("addComment".equals(action)) {
            String chapterIdStr = request.getParameter("chapterId");
            String content = request.getParameter("content");

            try {
                int chapterId = Integer.parseInt(chapterIdStr);
                CommentDAO commentDAO = new CommentDAO();
                Comment comment = new Comment();
                comment.setUserId(user.getId());
                comment.setChapterId(chapterId);
                comment.setContent(content);
                commentDAO.addComment(comment);
            } catch (NumberFormatException e) {
                System.err.println("Error parsing comment data: " + e.getMessage());
            }

            response.sendRedirect(request.getContextPath() + "/chapter?id=" + chapterIdStr);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/");
    }
}
