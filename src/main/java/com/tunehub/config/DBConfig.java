package com.tunehub.config;


import java.sql.Connection;
import java.sql.DriverManager;


public class DBConfig {
	private static final String DB_NAME = "tunehub";
    private static final String URL      = "jdbc:mysql://localhost:3307/tunehub";
    private static final String USER     = "root";
    private static final String PASSWORD = "";          // change if your root has a password

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
