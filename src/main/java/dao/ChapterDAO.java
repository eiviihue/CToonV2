package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Chapter;
import model.Page;

public class ChapterDAO {
    private Connection connection;

    public ChapterDAO() {
        this.connection = null;
    }

    private synchronized Connection getConnection() throws SQLException {
        if (this.connection == null || this.connection.isClosed()) {
            this.connection = util.DBUtil.getConnection();
        }
        return this.connection;
    }

    public Chapter getChapterById(int chapterId) {
        try {
            String query = "SELECT * FROM chapters WHERE id = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
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
            System.err.println("Error fetching chapter by ID: " + e.getMessage());
        }
        return null;
    }

    public List<Chapter> getChaptersByComicId(int comicId) {
        List<Chapter> chapters = new ArrayList<>();
        try {
            String query = "SELECT * FROM chapters WHERE comic_id = ? ORDER BY number ASC";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, comicId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Chapter chapter = new Chapter();
                chapter.setId(rs.getInt("id"));
                chapter.setComicId(rs.getInt("comic_id"));
                chapter.setTitle(rs.getString("title"));
                chapter.setNumber(rs.getInt("number"));
                chapters.add(chapter);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching chapters by comic ID: " + e.getMessage());
        }
        return chapters;
    }

    public List<Page> getPagesByChapterId(int chapterId) {
        List<Page> pages = new ArrayList<>();
        try {
            String query = "SELECT * FROM pages WHERE chapter_id = ? ORDER BY page_number ASC";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, chapterId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Page page = new Page();
                page.setId(rs.getInt("id"));
                page.setChapterId(rs.getInt("chapter_id"));
                page.setPageNumber(rs.getInt("page_number"));
                page.setImagePath(rs.getString("image_path"));
                pages.add(page);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching pages by chapter ID: " + e.getMessage());
        }
        return pages;
    }
}
