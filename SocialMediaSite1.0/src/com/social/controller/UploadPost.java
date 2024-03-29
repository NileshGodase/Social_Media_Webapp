package com.social.controller;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.mysql.cj.xdevapi.Schema.CreateCollectionOptions;
import com.social.util.JdbcUtil;

@WebServlet("/uploadpost")
@MultipartConfig
public class UploadPost extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();
		String sessionUser = (String)session.getAttribute("username");
		
		String username = sessionUser;
		String caption = request.getParameter("caption");
		Part imagePart = request.getPart("imageUpload");
		
		String uploadPostQuery = "insert into posts(username,image,caption,likes) values(?,?,?,0)";
		
		try {
			Connection connection = JdbcUtil.getJdbcConnection();
			PreparedStatement ps = connection.prepareStatement(uploadPostQuery);
			ps.setString(1, username);
			InputStream imageInputStream = imagePart.getInputStream();
			ps.setBinaryStream(2, imageInputStream);
			ps.setString(3, caption);
			int rowsAffected = ps.executeUpdate();
			
			if(rowsAffected > 0) {
				out.println("<h2 style='color:green; text-align:center;'> Post Uploaded Successfully </h2>");
				RequestDispatcher requestDispatcher = request.getRequestDispatcher("/createPost.jsp");
				requestDispatcher.include(request, response);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			out.println("<h2 style='color:red; text-align:center;'> Unable to upload post </h2>");
			RequestDispatcher requestDispatcher = request.getRequestDispatcher("/createPost.jsp");
			requestDispatcher.include(request, response);	
		}
		
	}

}
