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
import model.Chapter;
import model.Comic;
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

            request.setAttribute("comic", comic);
            request.setAttribute("chapter", chapter);
            request.setAttribute("pages", pages);
            request.setAttribute("chapters", chapters);

            request.getRequestDispatcher("/chapter.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}
