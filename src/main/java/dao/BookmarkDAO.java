package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Bookmark;

public class BookmarkDAO {
    private Connection connection;

    public BookmarkDAO() {
        this.connection = null;
    }

    private synchronized Connection getConnection() throws SQLException {
        if (this.connection == null || this.connection.isClosed()) {
            this.connection = util.DBUtil.getConnection();
        }
        return this.connection;
    }

    public boolean isBookmarked(int userId, int comicId) {
        try {
            String query = "SELECT COUNT(*) FROM bookmarks WHERE user_id = ? AND comic_id = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, userId);
            stmt.setInt(2, comicId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking bookmark: " + e.getMessage());
        }
        return false;
    }

    public void addBookmark(Bookmark bookmark) {
        try {
            String query = "INSERT INTO bookmarks (user_id, comic_id) VALUES (?, ?)";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, bookmark.getUserId());
            stmt.setInt(2, bookmark.getComicId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error adding bookmark: " + e.getMessage());
        }
    }

    public void removeBookmark(int userId, int comicId) {
        try {
            String query = "DELETE FROM bookmarks WHERE user_id = ? AND comic_id = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, userId);
            stmt.setInt(2, comicId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error removing bookmark: " + e.getMessage());
        }
    }
}
