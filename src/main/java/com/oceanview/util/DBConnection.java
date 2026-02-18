package com.oceanview.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static final HikariDataSource dataSource;

    static {
        // Load credentials from db.properties
        Properties props = new Properties();
        try (InputStream in = DBConnection.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (in == null) {
                throw new RuntimeException("db.properties not found in classpath!");
            }
            props.load(in);

        } catch (IOException e) {
            throw new RuntimeException("Failed to load db.properties", e);
        }

        // Configure HikariCP pool
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(props.getProperty("db.url"));
        config.setUsername(props.getProperty("db.username"));
        config.setPassword(props.getProperty("db.password"));
        config.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        // Pool sizing
        config.setMinimumIdle(2);          // keep 2 connections ready at all times
        config.setMaximumPoolSize(10);     // never exceed 10 simultaneous connections
        config.setIdleTimeout(300000);     // remove idle connections after 5 minutes
        config.setMaxLifetime(600000);     // recycle connections after 10 minutes
        config.setConnectionTimeout(30000);// wait max 30 seconds for a connection

        // Verify connection is alive before handing it out
        config.setConnectionTestQuery("SELECT 1");
        config.setPoolName("OceanViewPool");

        dataSource = new HikariDataSource(config);
        System.out.println("✅ HikariCP connection pool initialized.");
    }

    // All DAOs call this — gets a connection from the pool instead of creating a new one
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("DB Connection failed: " + e.getMessage());
            return false;
        }
    }

    // Call this when the app shuts down (optional but clean)
    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            System.out.println("HikariCP pool shut down.");
        }
    }
}
