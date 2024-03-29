<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@page import="com.social.util.JdbcUtil" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Searching..</title>
</head>

<style>
    body, html {
        margin: 0;
        padding: 0;
        height: 100%;
    }
    .container {
        display: flex;
        wrap-content: flext-wrap;
        flex-direction: column;
        height: 100%;
    }
    .row {
        flex: 1;
        display: flex;
    }

    .left, .right {
    	flex:1;
        background-color: white;
    }
    .middle {
    	flex:2;
    }
</style>


<style>



    .user-card-container {
        max-height: 500px; /* Set maximum height for the scrollable container */
        overflow-y: auto; /* Enable vertical scrolling */
    }
    .user-card {
        display: flex;
        align-items: center;
        padding-left: 20px;
        border: 1px dotted #ddd;
        border-radius : 20px;
        max-width: 100%;
        margin: 0 auto;
    }

    .user-card h1 {
        width: 30px;
        height: 30px;
        text-align: center;
    }

    .user-info {
        display: flex;
    }

    .username {
        font-weight: bold;
        margin-bottom: 5px;
        width: 100px;
    }

    .button {
	        padding: 10px 20px;
	        background-color: #007bff;
	        color: #fff;
	        border: none;
	        border-radius: 5px;
	        cursor: pointer;
	        font-size: 16px;
    }
</style>

<body>

	

    <div class="container">
   	 <a style="width:80px; text-decoration:none ; " href="loginHome.jsp" class="button">Go back</a>
        <div class="row">
            <div class="left"></div>
	            <div class="middle">
	            <h2 style = 'font-family:cursive,Times,serif; font-style:italic; text-align:center;'>Find connections</h2>
   		        <div class="user-card-container">

	<%
	String searchedKeyword = request.getParameter("searchedKeyword");
	String searchQuery = "select username from users where username NOT IN (select connections from myconnections) AND username like ? AND username<> ?"; 
	
	String getPostQuery = "select username from users where username like ? AND "+
			" username NOT IN (select connections from myconnections where main_user=? "+
			" union "+
			" select main_user from myconnections where connections=? "+
			" union "+
			" select for_user from pendingrequest where from_user=? "+
			" union "+
			" select from_user from pendingrequest where for_user=?)  AND username<> ? ";
	
	try {
		Connection connection = JdbcUtil.getJdbcConnection();
		PreparedStatement ps = connection.prepareStatement(getPostQuery);
		ps.setString(1, "%"+searchedKeyword+"%");
		ps.setString(2, (String)session.getAttribute("username"));
		ps.setString(3, (String)session.getAttribute("username"));
		ps.setString(4, (String)session.getAttribute("username"));
		ps.setString(5, (String)session.getAttribute("username"));
		ps.setString(6, (String)session.getAttribute("username"));
    	ResultSet resultSet = ps.executeQuery();
    	while(resultSet.next()){ 
    		String username = resultSet.getString(1);
	%>
	
				<div class="user-card">
				    <h1><%out.println(username.toUpperCase().charAt(0));%></h1>
				    <div class="user-info">
				        <div class="username"><%=username%></div>
				        <form action="./connect" method="post">
				        <input type="text" value="<%=username%>" name="connectUser" hidden/>
						<input type="submit" class="button" value="Connect" />
						</form>
				    </div>
				</div>	
		
	<%
    	}
	}catch (Exception e) {
		out.println(e.getMessage());
	}
	%>
	
     				</div>
	            </div>
	            <div class="right"></div>

</body>
</html>