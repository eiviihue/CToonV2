package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    public static Connection getConnection() throws SQLException {
        // Use environment variables for credentials (Railway sets these automatically)
        String url = getDbUrl();
        String user = getDbUser();
        String password = getDbPassword();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC driver not found: " + e.getMessage());
            throw new SQLException("Failed to load JDBC driver", e);
        }
        return DriverManager.getConnection(url, user, password);
    }

    private static String getDbUrl() {
        String url = System.getenv("DB_URL");
        if (url == null) {
            throw new RuntimeException("Database URL not configured. Set DB_URL environment variable.");
        }
        return url;
    }

    private static String getDbUser() {
        String user = System.getenv("DB_USER");
        if (user == null) {
            throw new RuntimeException("Database user not configured. Set DB_USER environment variable.");
        }
        return user;
    }

    private static String getDbPassword() {
        String password = System.getenv("DB_PASSWORD");
        if (password == null) {
            throw new RuntimeException("Database password not configured. Set DB_PASSWORD environment variable.");
        }
        return password;
    }
}
