package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Comment;

public class CommentDAO {
    private Connection connection;

    public CommentDAO() {
        this.connection = null;
    }

    private synchronized Connection getConnection() throws SQLException {
        if (this.connection == null || this.connection.isClosed()) {
            this.connection = util.DBUtil.getConnection();
        }
        return this.connection;
    }

    public List<Comment> getCommentsByChapterId(int chapterId) {
        List<Comment> comments = new ArrayList<>();
        try {
            String query = "SELECT c.*, u.username FROM comments c " +
                    "JOIN users u ON c.user_id = u.id " +
                    "WHERE c.chapter_id = ? " +
                    "ORDER BY c.created_at DESC";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, chapterId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getInt("id"));
                comment.setUserId(rs.getInt("user_id"));
                Integer chapterIdVal = rs.getObject("chapter_id", Integer.class);
                comment.setChapterId(chapterIdVal);
                comment.setContent(rs.getString("content"));
                comment.setCreatedAt(rs.getString("created_at"));
                comment.setUsername(rs.getString("username"));
                comments.add(comment);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching comments by chapter ID: " + e.getMessage());
        }
        return comments;
    }

    public void addComment(Comment comment) {
        try {
            String query = "INSERT INTO comments (user_id, chapter_id, comic_id, content, created_at) VALUES (?, ?, ?, ?, NOW())";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, comment.getUserId());
            if (comment.getChapterId() != null) {
                stmt.setInt(2, comment.getChapterId());
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            if (comment.getComicId() != null) {
                stmt.setInt(3, comment.getComicId());
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            stmt.setString(4, comment.getContent());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error adding comment: " + e.getMessage());
        }
    }

    // Fetch comments for a comic (only comments with comic_id set)
    public List<Comment> getCommentsByComicId(int comicId) {
        List<Comment> comments = new ArrayList<>();
        try {
            String query = "SELECT c.*, u.username FROM comments c " +
                    "JOIN users u ON c.user_id = u.id " +
                    "WHERE c.comic_id = ? " +
                    "ORDER BY c.created_at DESC";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, comicId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getInt("id"));
                comment.setUserId(rs.getInt("user_id"));
                Integer comicIdVal = rs.getObject("comic_id", Integer.class);
                comment.setComicId(comicIdVal);
                comment.setContent(rs.getString("content"));
                comment.setCreatedAt(rs.getString("created_at"));
                comment.setUsername(rs.getString("username"));
                comments.add(comment);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching comments by comic ID: " + e.getMessage());
        }
        return comments;
    }
}
