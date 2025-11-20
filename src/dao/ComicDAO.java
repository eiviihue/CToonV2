package dao;
import model.Comic;
import java.sql.*;
import java.util.*;

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
}
