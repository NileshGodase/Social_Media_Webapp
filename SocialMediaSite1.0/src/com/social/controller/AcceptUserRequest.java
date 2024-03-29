package com.social.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.social.util.JdbcUtil;

@WebServlet("/accept")
public class AcceptUserRequest extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String acceptUser = request.getParameter("acceptUser");
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		
		try {
			// query to add the connection data to the user who accept the request
			String addUserRecordForAccepter = "insert into myconnections(main_user,connections) values(?,?)";
			Connection connection = JdbcUtil.getJdbcConnection();
			PreparedStatement preparedStatement = connection.prepareStatement(addUserRecordForAccepter);
			preparedStatement.setString(1,(String)session.getAttribute("username"));
			preparedStatement.setString(2, acceptUser);
			int rowsAffected = preparedStatement.executeUpdate();
		
			if(rowsAffected>0) {
				// query to delete user from request table
				String deleteUserFromRequest = "delete from pendingrequest where from_user=? and for_user=?";
				PreparedStatement ps = connection.prepareStatement(deleteUserFromRequest);
				ps.setString(1,acceptUser);
				ps.setString(2, (String)session.getAttribute("username"));
				ps.executeUpdate();
				
				out.println("<div style='color:green; width:100%; background-color:black;'>Request Accepted</div>");
				RequestDispatcher requestDispatcher = request.getRequestDispatcher("/loginHome.jsp");
				requestDispatcher.include(request, response);
						
			}
		
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
