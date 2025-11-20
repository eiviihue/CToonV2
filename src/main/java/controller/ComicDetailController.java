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
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("/comic.jsp").forward(request, response);
    }
}
