package com.social.controller;

import java.io.IOException;
import java.io.PrintWriter;
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

@WebServlet("/connect")
public class ConnectUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		String connectUser = request.getParameter("connectUser");
		String connectUserQuery = "insert into pendingRequest(for_user,from_user) values(?,?)";
		try {
			PreparedStatement ps = JdbcUtil.getJdbcConnection().prepareStatement(connectUserQuery);
			ps.setString(1, connectUser);
			ps.setString(2, (String)session.getAttribute("username"));
			int rowsAffected = ps.executeUpdate();
			if(rowsAffected > 0) {
				out.println("<div style='color:green; width:100%; background-color:black;'><b>Request sent</b></div>");
				RequestDispatcher resDispatcher = request.getRequestDispatcher("SearchUser.jsp");
				resDispatcher.include(request, response);
			}
		} catch (SQLException e) {
			out.println("<div style='color:red; width:100%; background-color:black;'><b>Request already sent</b></div>");
			RequestDispatcher resDispatcher = request.getRequestDispatcher("SearchUser.jsp");
			resDispatcher.include(request, response);
			e.printStackTrace();
		}
		
	}

}
