package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Comic;
import model.Genre;

public class ComicDAO {
    private Connection connection;

    public ComicDAO() {
        // lazy connection
        this.connection = null;
    }

    private synchronized Connection getConnection() throws SQLException {
        if (this.connection == null || this.connection.isClosed()) {
            this.connection = util.DBUtil.getConnection();
        }
        return this.connection;
    }

    private void loadGenresForComic(Comic comic) {
        try {
            GenreDAO genreDAO = new GenreDAO();
            List<Genre> genres = genreDAO.getGenresByComicId(comic.getId());
            comic.setGenres(genres);
        } catch (Exception e) {
            System.err.println("Error loading genres for comic: " + e.getMessage());
        }
    }

    public Comic getComicById(int comicId) {
        try {
            String query = "SELECT c.*, COALESCE((SELECT ROUND(AVG(stars),2) FROM ratings r WHERE r.comic_id = c.id),0) AS average_rating FROM comics c WHERE c.id = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, comicId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Comic comic = new Comic();
                comic.setId(rs.getInt("id"));
                comic.setTitle(rs.getString("title"));
                comic.setDescription(rs.getString("description"));
                comic.setCoverPath(rs.getString("cover_path"));
                comic.setAverageRating(rs.getDouble("average_rating"));
                comic.setViews(rs.getInt("views"));
                // load genres from comics_genres junction table
                loadGenresForComic(comic);
                return comic;
            }
        } catch (SQLException e) {
            System.err.println("Error fetching comic by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Comic> getAllComics() {
        List<Comic> comics = new ArrayList<>();
        try {
            String query = "SELECT c.*, COALESCE((SELECT ROUND(AVG(stars),2) FROM ratings r WHERE r.comic_id = c.id),0) AS average_rating FROM comics c LIMIT 50";
            Statement stmt = getConnection().createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Comic comic = new Comic();
                comic.setId(rs.getInt("id"));
                comic.setTitle(rs.getString("title"));
                comic.setDescription(rs.getString("description"));
                comic.setCoverPath(rs.getString("cover_path"));
                comic.setAverageRating(rs.getDouble("average_rating"));
                comic.setViews(rs.getInt("views"));
                loadGenresForComic(comic);
                comics.add(comic);
            }
            System.out.println("Successfully fetched " + comics.size() + " comics from database");
        } catch (SQLException e) {
            System.err.println("Error fetching all comics: " + e.getMessage());
            e.printStackTrace();
        }
        return comics;
    }

    public List<Comic> getRecentComics() {
        List<Comic> comics = new ArrayList<>();
        try {
            String query = "SELECT c.*, COALESCE((SELECT ROUND(AVG(stars),2) FROM ratings r WHERE r.comic_id = c.id),0) AS average_rating FROM comics c ORDER BY c.id DESC LIMIT 6";
            Statement stmt = getConnection().createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Comic comic = new Comic();
                comic.setId(rs.getInt("id"));
                comic.setTitle(rs.getString("title"));
                comic.setDescription(rs.getString("description"));
                comic.setCoverPath(rs.getString("cover_path"));
                comic.setAverageRating(rs.getDouble("average_rating"));
                comic.setViews(rs.getInt("views"));
                loadGenresForComic(comic);
                comics.add(comic);
            }
            System.out.println("Successfully fetched " + comics.size() + " recent comics");
        } catch (SQLException e) {
            System.err.println("Error fetching recent comics: " + e.getMessage());
            e.printStackTrace();
        }
        return comics;
    }

    public List<Comic> getTrendingComics() {
        List<Comic> comics = new ArrayList<>();
        try {
            String query = "SELECT c.*, COALESCE((SELECT ROUND(AVG(stars),2) FROM ratings r WHERE r.comic_id = c.id),0) AS average_rating FROM comics c ORDER BY c.views DESC LIMIT 6";
            Statement stmt = getConnection().createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Comic comic = new Comic();
                comic.setId(rs.getInt("id"));
                comic.setTitle(rs.getString("title"));
                comic.setDescription(rs.getString("description"));
                comic.setCoverPath(rs.getString("cover_path"));
                comic.setAverageRating(rs.getDouble("average_rating"));
                comic.setViews(rs.getInt("views"));
                loadGenresForComic(comic);
                comics.add(comic);
            }
            System.out.println("Successfully fetched " + comics.size() + " trending comics");
        } catch (SQLException e) {
            System.err.println("Error fetching trending comics: " + e.getMessage());
            e.printStackTrace();
        }
        return comics;
    }

    public Comic getComicBySlug(String slug) {
        try {
            // slug is expected to be lowercase with dashes replacing spaces
            String query = "SELECT c.*, COALESCE((SELECT ROUND(AVG(stars),2) FROM ratings r WHERE r.comic_id = c.id),0) AS average_rating FROM comics c WHERE REPLACE(LOWER(c.title),' ', '-') = ? LIMIT 1";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, slug.toLowerCase());
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Comic comic = new Comic();
                comic.setId(rs.getInt("id"));
                comic.setTitle(rs.getString("title"));
                comic.setDescription(rs.getString("description"));
                comic.setCoverPath(rs.getString("cover_path"));
                comic.setAverageRating(rs.getDouble("average_rating"));
                comic.setViews(rs.getInt("views"));
                loadGenresForComic(comic);
                return comic;
            }
        } catch (SQLException e) {
            System.err.println("Error fetching comic by slug: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Comic> searchComics(String q) {
        List<Comic> comics = new ArrayList<>();
        try {
            String like = "%" + q + "%";
            String query = "SELECT c.*, COALESCE((SELECT ROUND(AVG(stars),2) FROM ratings r WHERE r.comic_id = c.id),0) AS average_rating FROM comics c WHERE c.title LIKE ? OR c.description LIKE ? LIMIT 50";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, like);
            stmt.setString(2, like);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Comic comic = new Comic();
                comic.setId(rs.getInt("id"));
                comic.setTitle(rs.getString("title"));
                comic.setDescription(rs.getString("description"));
                comic.setCoverPath(rs.getString("cover_path"));
                comic.setAverageRating(rs.getDouble("average_rating"));
                comic.setViews(rs.getInt("views"));
                loadGenresForComic(comic);
                comics.add(comic);
            }
            System.out.println("Successfully found " + comics.size() + " comics matching '" + q + "'");
        } catch (SQLException e) {
            System.err.println("Error searching comics: " + e.getMessage());
            e.printStackTrace();
        }
        return comics;
    }

    public void incrementViews(int comicId) {
        try {
            String query = "UPDATE comics SET views = views + 1 WHERE id = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, comicId);
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Incremented views for comic ID: " + comicId);
            }
        } catch (SQLException e) {
            System.err.println("Error incrementing views: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
