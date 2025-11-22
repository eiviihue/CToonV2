package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ComicDAO;
import model.Comic;

@WebServlet("/search")
public class SearchController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        List<Comic> searchResults = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            ComicDAO comicDAO = new ComicDAO();
            searchResults = comicDAO.searchComics(query.trim());
        }

        request.setAttribute("searchResults", searchResults);
        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }
}
