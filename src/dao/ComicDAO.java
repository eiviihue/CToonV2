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
                comic.setCoverPath(rs.getString("cover_path"));
                comic.setCategory(rs.getString("category"));
                comic.setAverageRating(rs.getDouble("average_rating"));
                comic.setViews(rs.getInt("views"));
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
                comic.setCoverPath(rs.getString("cover_path"));
                comic.setCategory(rs.getString("category"));
                comic.setAverageRating(rs.getDouble("average_rating"));
                comic.setViews(rs.getInt("views"));
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
                comic.setCoverPath(rs.getString("cover_path"));
                comic.setCategory(rs.getString("category"));
                comic.setAverageRating(rs.getDouble("average_rating"));
                comic.setViews(rs.getInt("views"));
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
                comic.setCoverPath(rs.getString("cover_path"));
                comic.setCategory(rs.getString("category"));
                comic.setAverageRating(rs.getDouble("average_rating"));
                comic.setViews(rs.getInt("views"));
                comics.add(comic);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comics;
    }
}
