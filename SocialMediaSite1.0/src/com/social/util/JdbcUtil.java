package com.social.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class JdbcUtil {
	
	static Connection connection = null;
	static PreparedStatement preparedStatement = null;

	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	public static Connection getJdbcConnection() {
		
		try {
			FileInputStream fis = new FileInputStream("F:\\workspace for eclips\\SocialMediaSite1.0\\src\\com\\social\\properties\\database.properties");
			Properties properties = new Properties();
			properties.load(fis);
			String url = properties.getProperty("url");
			String user = properties.getProperty("username");
			String password = properties.getProperty("password");
			return  DriverManager.getConnection(url, user, password);
		}catch (IOException | SQLException e) {
			e.printStackTrace();
		}
		
		return connection;
		
	}
	
	public static boolean checkUserExits(String username) throws SQLException {
		

		ResultSet resultSet = null;
		String userExitQuery = "select * from users where username=?";
		
		try {
			connection = JdbcUtil.getJdbcConnection();			
			preparedStatement = connection.prepareStatement(userExitQuery);
			preparedStatement.setString(1, username);
			resultSet = preparedStatement.executeQuery();
		
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		if(resultSet.next()==true) {
			System.out.println("user exits");
			return true;
		}else {
			System.out.println("user not exits");
			return false;
		}
		
	}

	public static boolean createUser(String username, String password) {
		String createUserQuery = "insert into users values(?,?)";
		boolean isUserCreated = false;
		
		try {
			preparedStatement = getJdbcConnection().prepareStatement(createUserQuery);
			preparedStatement.setString(1, username);
			preparedStatement.setString(2, password);
			int rowsAffected = preparedStatement.executeUpdate();
			if(rowsAffected==1) {
				isUserCreated = true;
				return isUserCreated;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			// TODO: handle exception
		}
		
		return isUserCreated;
	}
	
	public static boolean loginNow(String username, String password) throws SQLException {
		

		ResultSet resultSet = null;
		String validateLoginQuery = "select * from users where username=? and password=?";
		
		try {
			connection = JdbcUtil.getJdbcConnection();			
			preparedStatement = connection.prepareStatement(validateLoginQuery);
			preparedStatement.setString(1, username);
			preparedStatement.setString(2, password);
			resultSet = preparedStatement.executeQuery();
		
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		if(resultSet.next()==true) {
			System.out.println("user exits");
			return true;
		}else {
			System.out.println("user not exits");
			return false;
		}
		
	}
	
}
