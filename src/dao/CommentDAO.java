package dao;
import model.Comment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {
    private Connection connection;

    public CommentDAO() {
        try {
            connection = util.DBUtil.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Comment> getCommentsByChapterId(int chapterId) {
        List<Comment> comments = new ArrayList<>();
        try {
            String query = "SELECT * FROM comments WHERE chapter_id = ?";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, chapterId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getInt("id"));
                comment.setUserId(rs.getInt("user_id"));
                comment.setChapterId(rs.getInt("chapter_id"));
                comment.setContent(rs.getString("content"));
                comment.setCreatedAt(rs.getString("created_at"));
                comments.add(comment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    public void addComment(Comment comment) {
        try {
            String query = "INSERT INTO comments (user_id, chapter_id, content, created_at) VALUES (?, ?, ?, NOW())";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, comment.getUserId());
            stmt.setInt(2, comment.getChapterId());
            stmt.setString(3, comment.getContent());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Fetch comments for a whole comic by joining chapters -> comments
    public List<Comment> getCommentsByComicId(int comicId) {
        List<Comment> comments = new ArrayList<>();
        try {
            String query = "SELECT c.* FROM comments c JOIN chapters ch ON c.chapter_id = ch.id WHERE ch.comic_id = ? ORDER BY c.created_at DESC";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, comicId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getInt("id"));
                comment.setUserId(rs.getInt("user_id"));
                comment.setChapterId(rs.getInt("chapter_id"));
                comment.setContent(rs.getString("content"));
                comment.setCreatedAt(rs.getString("created_at"));
                comments.add(comment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }
}
