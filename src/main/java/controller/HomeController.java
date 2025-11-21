package controller;

import dao.ComicDAO;
import model.Comic;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class HomeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ComicDAO comicDAO = new ComicDAO();
        
        List<Comic> recentComics = comicDAO.getRecentComics();
        List<Comic> trendingComics = comicDAO.getTrendingComics();
        
        request.setAttribute("recentComics", recentComics);
        request.setAttribute("trendingComics", trendingComics);
        
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
