<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.social.util.JdbcUtil" %>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css">
    <style>
        body {
            padding: 30px;
            margin: 30px;
        }
        .signup-form {
            max-width: 400px;
            margin: auto;
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .signup-form h1 {
            color: blue;
            text-align: center;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>

<div class="signup-form">

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

    <h1>Sign Up</h1>
    <form action="./signup" method="post">
        <div class="form-group">
            <label for="username">Enter username</label>
            <input name="username" type="text" class="form-control" id="username" placeholder="Enter username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input name="password" type="password" class="form-control" id="password" placeholder="Password" required>
        </div>
        <button type="submit" class="btn btn-primary btn-block">Sign Up</button>
    	<br></br>
    	
    	<h5 style="text-align:center;">already sign up?</h5>
		<a href="login.jsp" class="btn btn-primary btn-block">Login</a>
    </form>
</div>

</body>
</html>
