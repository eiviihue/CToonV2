package util;

import java.io.File;
import java.lang.reflect.Method;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class StartupListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            String webRoot = sce.getServletContext().getRealPath("/");
            if (webRoot == null) {
                System.out.println("[StartupListener] webRoot is null (running from archive)");
            } else {
                File index = new File(webRoot, "index.jsp");
                System.out.println("[StartupListener] webRoot: " + webRoot);
                System.out.println("[StartupListener] index.jsp exists: " + index.exists() + " (path="
                        + index.getAbsolutePath() + ")");
            }
        } catch (Exception e) {
            System.err.println("[StartupListener] Error during startup: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[StartupListener] context destroyed");

        // Deregister JDBC drivers that were registered by this webapp's classloader
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            if (driver.getClass().getClassLoader() == cl) {
                try {
                    DriverManager.deregisterDriver(driver);
                    System.out.println("[StartupListener] Deregistered JDBC driver: " + driver);
                } catch (SQLException ex) {
                    System.err.println("[StartupListener] Error deregistering driver: " + ex.getMessage());
                }
            } else {
                System.out
                        .println("[StartupListener] Not deregistering JDBC driver (owned by a different ClassLoader): "
                                + driver);
            }
        }

        // Try to shutdown MySQL AbandonedConnectionCleanupThread (if present)
        try {
            Class<?> cleanupClass = Class.forName("com.mysql.cj.jdbc.AbandonedConnectionCleanupThread");
            Method shutdownMethod = cleanupClass.getMethod("checkedShutdown");
            shutdownMethod.invoke(null);
            System.out.println("[StartupListener] AbandonedConnectionCleanupThread checkedShutdown invoked.");
        } catch (ClassNotFoundException cnfe) {
            // MySQL driver not present or different version; ignore
            System.out.println(
                    "[StartupListener] MySQL AbandonedConnectionCleanupThread class not found: " + cnfe.getMessage());
        } catch (NoSuchMethodException | IllegalAccessException | IllegalArgumentException ex) {
            System.err.println(
                    "[StartupListener] Error shutting down AbandonedConnectionCleanupThread: " + ex.getMessage());
        } catch (Exception ex) {
            System.err.println(
                    "[StartupListener] Error shutting down AbandonedConnectionCleanupThread: " + ex.getMessage());
        }
    }
}
