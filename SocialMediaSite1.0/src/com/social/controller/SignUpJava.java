package com.social.controller;


import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.social.util.JdbcUtil;


@WebServlet("/signup")
public class SignUpJava extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		boolean isUserExits = false;
		PrintWriter out = response.getWriter();
		
		try {
			isUserExits = JdbcUtil.checkUserExits(username);
			if(isUserExits==false) {
				boolean isUserCreated = createNewUser(username,password);
				if(isUserCreated) {
					out.println("<h2 style='color:green; text-align:center;'>Successfully Sign Up...</h2>");
					RequestDispatcher requestDispatcher = request.getRequestDispatcher("/login.jsp");
					requestDispatcher.include(request, response);
				}
			}else {
				out.println("<h2 style='color:red; text-align:center;'>already username exits...</h2>");
				RequestDispatcher requestDispatcher = request.getRequestDispatcher("/signUp.jsp");
				requestDispatcher.include(request, response);
			}
		}catch (Exception  e) {
			e.printStackTrace();
			out.println(e.getMessage());
			try {
				RequestDispatcher requestDispatcher = request.getRequestDispatcher("/signUp.jsp");
				requestDispatcher.include(request, response);
			}catch (Exception ea) {
				ea.printStackTrace();
			}
		}

	
	}

	private boolean createNewUser(String username, String password) {
		return JdbcUtil.createUser(username,password);
	}



}
