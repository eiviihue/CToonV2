package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    public static Connection getConnection() throws SQLException {
        String url = getDbUrl();
        String user = getDbUser();
        String password = getDbPassword();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC driver not found: " + e.getMessage());
            throw new SQLException("Failed to load JDBC driver", e);
        }
        System.out.println("Connecting to database: " + url);
        return DriverManager.getConnection(url, user, password);
    }

    private static String getDbUrl() {
        // Try to get pre-built URL first
        String url = System.getenv("DB_URL");
        if (url != null && !url.isEmpty()) {
            return url;
        }

        // Build URL from individual components
        String host = System.getenv("DB_HOST");
        String port = System.getenv("DB_PORT");
        String database = System.getenv("DB_NAME");

        if (host == null || port == null || database == null) {
            throw new RuntimeException(
                    "Database configuration incomplete. Set DB_URL or (DB_HOST, DB_PORT, DB_NAME) environment variables.");
        }

        return "jdbc:mysql://" + host + ":" + port + "/" + database
                + "?useSSL=true&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    }

    private static String getDbUser() {
        String user = System.getenv("DB_USER");
        if (user == null || user.isEmpty()) {
            throw new RuntimeException("Database user not configured. Set DB_USER environment variable.");
        }
        return user;
    }

    private static String getDbPassword() {
        String password = System.getenv("DB_PASSWORD");
        if (password == null || password.isEmpty()) {
            throw new RuntimeException("Database password not configured. Set DB_PASSWORD environment variable.");
        }
        return password;
    }
}
