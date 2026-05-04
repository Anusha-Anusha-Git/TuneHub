package com.tunehub.config;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBConfig {
    private static final String URL      = "jdbc:mysql://localhost:3307/tunehub";
    private static final String USER     = "root";
    private static final String PASSWORD = "";          // change if your root has a password

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("❌ MySQL JDBC Driver not found! Add mysql-connector-j to your project.", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        // Optional: Debug print (remove in production)
        // System.out.println("✅ Database connected!");
        return conn;
    }
}
