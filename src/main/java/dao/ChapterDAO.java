package dao;
import model.Chapter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChapterDAO {
    private Connection connection;

    public ChapterDAO() {
        try {
            connection = util.DBUtil.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Chapter getChapterById(int chapterId) {
        try {
            String query = "SELECT * FROM chapters WHERE id = ?";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, chapterId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Chapter chapter = new Chapter();
                chapter.setId(rs.getInt("id"));
                chapter.setComicId(rs.getInt("comic_id"));
                chapter.setTitle(rs.getString("title"));
                chapter.setNumber(rs.getInt("number"));
                return chapter;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
