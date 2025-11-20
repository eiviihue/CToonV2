package controller;

import dao.ComicDAO;
import model.Comic;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/browse")
public class BrowseController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ComicDAO comicDAO = new ComicDAO();
        List<Comic> comics = comicDAO.getAllComics();
        
        request.setAttribute("comics", comics);
        request.getRequestDispatcher("/browse.jsp").forward(request, response);
    }
}
