package util;
import java.sql.*;

public class DBUtil {
    public static Connection getConnection() throws SQLException {
        // Update with your Railway/MySQL connection details
        String url = "jdbc:mysql://localhost:3306/ctoon";
        String user = "root";
        String password = "password";
        return DriverManager.getConnection(url, user, password);
    }
}
