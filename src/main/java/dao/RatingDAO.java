package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Rating;

public class RatingDAO {
    private Connection connection;

    public RatingDAO() {
        this.connection = null;
    }

    private synchronized Connection getConnection() throws SQLException {
        if (this.connection == null || this.connection.isClosed()) {
            this.connection = util.DBUtil.getConnection();
        }
        return this.connection;
    }

    public List<Rating> getRatingsByComicId(int comicId) {
        List<Rating> ratings = new ArrayList<>();
        try {
            String query = "SELECT * FROM ratings WHERE comic_id = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, comicId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Rating rating = new Rating();
                rating.setId(rs.getInt("id"));
                rating.setUserId(rs.getInt("user_id"));
                rating.setComicId(rs.getInt("comic_id"));
                rating.setStars(rs.getInt("stars"));
                ratings.add(rating);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching ratings by comic ID: " + e.getMessage());
        }
        return ratings;
    }

    public void addRating(Rating rating) {
        // Delegate to addOrUpdateRating to ensure one rating per user per comic
        addOrUpdateRating(rating);
    }

    // Add or update a user's rating for a comic (one rating per user per comic)
    public void addOrUpdateRating(Rating rating) {
        try {
            String update = "UPDATE ratings SET stars = ? WHERE user_id = ? AND comic_id = ?";
            PreparedStatement up = getConnection().prepareStatement(update);
            up.setInt(1, rating.getStars());
            up.setInt(2, rating.getUserId());
            up.setInt(3, rating.getComicId());
            int affected = up.executeUpdate();
            if (affected == 0) {
                String insert = "INSERT INTO ratings (user_id, comic_id, stars) VALUES (?, ?, ?)";
                PreparedStatement in = getConnection().prepareStatement(insert);
                in.setInt(1, rating.getUserId());
                in.setInt(2, rating.getComicId());
                in.setInt(3, rating.getStars());
                in.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("Error adding or updating rating: " + e.getMessage());
        }
    }

    // Return average stars for a given comic (0 if none)
    public double getAverageForComic(int comicId) {
        try {
            String query = "SELECT COALESCE(AVG(stars),0) AS avg_stars FROM ratings WHERE comic_id = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, comicId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                double avg = rs.getDouble("avg_stars");
                return Math.round(avg * 100.0) / 100.0;
            }
        } catch (SQLException e) {
            System.err.println("Error calculating average rating: " + e.getMessage());
        }
        return 0.0;
    }
}
