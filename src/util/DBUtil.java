package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    public static Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://shinkansen.proxy.rlwy.net:54128/railway?useSSL=false&serverTimezone=UTC";
        String user = "root";
        String password = "oRsqyOGrDWrBUBLYeGBxajubkknNXcuu";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(url, user, password);
    }
}
