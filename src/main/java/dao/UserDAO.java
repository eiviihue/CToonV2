package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.User;

public class UserDAO {
    private Connection connection;

    public UserDAO() {
        // lazy connection: do not attempt to open DB connection during construction
        this.connection = null;
    }

    private synchronized Connection getConnection() throws SQLException {
        if (this.connection == null || this.connection.isClosed()) {
            this.connection = util.DBUtil.getConnection();
        }
        return this.connection;
    }

    public User authenticate(String username, String password) {
        try {
            String query = "SELECT * FROM users WHERE (username = ? OR email = ?) AND password = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, username);
            stmt.setString(2, username);
            stmt.setString(3, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                return user;
            }
        } catch (SQLException e) {
            System.err.println("Error authenticating user: " + e.getMessage());
        }
        return null;
    }

    public User getUserById(int userId) {
        try {
            String query = "SELECT * FROM users WHERE id = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                return user;
            }
        } catch (SQLException e) {
            System.err.println("Error fetching user by ID: " + e.getMessage());
        }
        return null;
    }

    public void create(User user) {
        try {
            String query = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error creating user: " + e.getMessage());
        }
    }

    public void update(User user) {
        try {
            String query = "UPDATE users SET username = ?, email = ?, password = ? WHERE id = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setInt(4, user.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
        }
    }

    public User getUserByUsername(String username) {
        try {
            String query = "SELECT * FROM users WHERE username = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                return user;
            }
        } catch (SQLException e) {
            System.err.println("Error fetching user by username: " + e.getMessage());
        }
        return null;
    }

    public void delete(int userId) {
        try {
            String query = "DELETE FROM users WHERE id = ?";
            PreparedStatement stmt = getConnection().prepareStatement(query);
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
        }
    }
}
