package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Comic;

public class ComicDAO {
    private Connection connection;

    public ComicDAO() {
        try {
            connection = util.DBUtil.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Comic getComicById(int comicId) {
        try {
            String query = "SELECT * FROM comics WHERE id = ?";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, comicId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Comic comic = new Comic();
                comic.setId(rs.getInt("id"));
                comic.setTitle(rs.getString("title"));
                comic.setDescription(rs.getString("description"));
                comic.setAuthor(rs.getString("author"));
                comic.setStatus(rs.getString("status"));
                comic.setAverageRating(rs.getInt("average_rating"));
                comic.setViews(rs.getInt("views"));

                // Get cover path from covers table
                String coverPath = getCoverPath(comicId);
                comic.setCoverPath(coverPath);

                return comic;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Comic> getAllComics() {
        List<Comic> comics = new ArrayList<>();
        try {
            String query = "SELECT * FROM comics LIMIT 50";
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Comic comic = new Comic();
                comic.setId(rs.getInt("id"));
                comic.setTitle(rs.getString("title"));
                comic.setDescription(rs.getString("description"));
                comic.setAuthor(rs.getString("author"));
                comic.setStatus(rs.getString("status"));
                comic.setAverageRating(rs.getInt("average_rating"));
                comic.setViews(rs.getInt("views"));

                String coverPath = getCoverPath(rs.getInt("id"));
                comic.setCoverPath(coverPath);

                comics.add(comic);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comics;
    }

    public List<Comic> getRecentComics() {
        List<Comic> comics = new ArrayList<>();
        try {
            String query = "SELECT * FROM comics ORDER BY id DESC LIMIT 6";
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Comic comic = new Comic();
                comic.setId(rs.getInt("id"));
                comic.setTitle(rs.getString("title"));
                comic.setDescription(rs.getString("description"));
                comic.setAuthor(rs.getString("author"));
                comic.setStatus(rs.getString("status"));
                comic.setAverageRating(rs.getInt("average_rating"));
                comic.setViews(rs.getInt("views"));

                String coverPath = getCoverPath(rs.getInt("id"));
                comic.setCoverPath(coverPath);

                comics.add(comic);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comics;
    }

    public List<Comic> getTrendingComics() {
        List<Comic> comics = new ArrayList<>();
        try {
            String query = "SELECT * FROM comics ORDER BY views DESC LIMIT 6";
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Comic comic = new Comic();
                comic.setId(rs.getInt("id"));
                comic.setTitle(rs.getString("title"));
                comic.setDescription(rs.getString("description"));
                comic.setAuthor(rs.getString("author"));
                comic.setStatus(rs.getString("status"));
                comic.setAverageRating(rs.getInt("average_rating"));
                comic.setViews(rs.getInt("views"));

                String coverPath = getCoverPath(rs.getInt("id"));
                comic.setCoverPath(coverPath);

                comics.add(comic);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comics;
    }

    private String getCoverPath(int comicId) {
        try {
            String query = "SELECT path, filename FROM covers WHERE comic_id = ? AND is_primary = 1 LIMIT 1";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, comicId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String path = rs.getString("path");
                String filename = rs.getString("filename");
                return path + "/" + filename;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "/assets/covers/default.png";
    }
}
