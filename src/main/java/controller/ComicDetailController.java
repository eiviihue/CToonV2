package controller;

import dao.ComicDAO;
import model.Comic;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/comic-detail")
public class ComicDetailController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String comicIdStr = request.getParameter("id");
        if (comicIdStr != null && !comicIdStr.isEmpty()) {
            try {
                int comicId = Integer.parseInt(comicIdStr);
                ComicDAO comicDAO = new ComicDAO();
                Comic comic = comicDAO.getComicById(comicId);
                
                if (comic != null) {
                    request.setAttribute("comic", comic);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("/comic.jsp").forward(request, response);
    }
}
