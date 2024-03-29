<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    

<%@page import="com.social.util.JdbcUtil" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css">
    <style>
        body {
            padding: 30px;
            margin: 30px;
        }
        .login-form {
            max-width: 400px;
            margin: auto;
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .login-form h1 {
            color: blue;
            text-align: center;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>

<% 
	if(session!=null){
		String sessionUser = (String)session.getAttribute("username");
		String sessionPass = (String)session.getAttribute("password");
	
		boolean isUserValid = JdbcUtil.loginNow(sessionUser,sessionPass);
	
		if( isUserValid==true){
			RequestDispatcher requestDispatcher = request.getRequestDispatcher("/loginHome.jsp");	
			requestDispatcher.forward(request, response);
		}
		
	}

%>

<div class="login-form">
    <h1>Login Now</h1>
    <form action="./login" method="post">
        <div class="form-group">
            <label for="username">Enter username</label>
            <input name="username" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Enter email">
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input name="password" type="password" class="form-control" id="exampleInputPassword1" placeholder="Password" required>
        </div>
        <button type="submit" class="btn btn-primary btn-block">Login</button>
		<br></br>
		<h5 style="text-align:center;">Or</h5>
		<a href="signUp.jsp" class="btn btn-primary btn-block">Sign up</a>
    </form>
</div>

<%! String sql = "select * from users"; 
    Connection connection;
    PreparedStatement ps;
    ResultSet resultSet;
%>

<%
    try{
    connection = JdbcUtil.getJdbcConnection();
    ps = connection.prepareStatement(sql);
    resultSet = ps.executeQuery();
    }catch(Exception e){
        out.println(e.getMessage());
        RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
        rd.include(request, response);
    }
%>


<%
    while(resultSet.next()){
        out.println("<div style='border: solid 3px green; padding:10px; margin:10px;'>");
        out.println(resultSet.getString(1));
        out.println(resultSet.getString(2));
        out.println("</div>");
    }
%>

</body>
</html>
