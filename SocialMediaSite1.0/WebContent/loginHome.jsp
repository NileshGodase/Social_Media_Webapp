<%@page import="java.io.InputStream"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@page import="com.social.util.JdbcUtil" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Home</title>
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
        background-color: #3897f0;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
</style>

<style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
        .container-fluid {
            padding-top: 56px; /* Adjust according to your header height */
        }
        .card {
        	height: auto;
        	width: 100%;
            margin-bottom: 20px;
            border: none;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border: 1px dotted #ddd;
        }
        .card-header {
            background-color: #f8f9fa;
            height: 25px;
            width: 100%;
            border-left: 6px solid red;
            margin-left : 2px;
        }
        .card-header span{
            font-size: 24px;
            font-weight: bold;
        }
        .card-img-container {
        	padding-top: 10px;
            width: 100%;
            height: auto; /* Specify the desired height */
            display: block;
            justify-content: center;
            align-items: center;
			max-height: 600px; /* Set maximum height for the scrollable container */
  		    overflow-y: auto; /* Enable vertical scrolling */
  		    scrollbar-width: none;
  		    -ms-overflow-style: none;
        }
        .card-img-container img {
            max-width: 100%;
            height: 500px;
            padding-left: auto;
            object-fit: contains;
            display: block; /* Makes the image a block-level element */
  			margin: 0 auto;
            
         /**   object-fit: cover; /* Maintain aspect ratio and cover the container */
        }   

        .card-caption {
            font-size: 16px;
        }
    </style>
    
    <style>
    	.searchform{
    		display: flex;
	        justify-content: center;
	        align-items: center;
	        margin-top: 20px;
    	}
    	
	    .searchform Input[type="text"] {
	        padding: 10px;
	        border: 1px solid #ccc;
	        border-radius: 5px;
	        margin-right: 10px;
	        font-size: 16px;
	    }
	
	    .searchform Input[type="submit"] , .button{
	        padding: 10px 20px;
	        background-color: #007bff;
	        color: #fff;
	        border: none;
	        border-radius: 5px;
	        cursor: pointer;
	        font-size: 16px;
	    }
	
	    .searchform Input[type="submit"]:hover {
	        background-color: #0056b3;
	    }
    	
    </style>

<body>


<% 
	String sessionUser = (String)session.getAttribute("username");
	String sessionPass = (String)session.getAttribute("password");

	if(request.getParameter("username")==null){
		boolean isUserValid = JdbcUtil.loginNow(sessionUser,sessionPass);
	
		if( isUserValid==false){
			RequestDispatcher requestDispatcher = request.getRequestDispatcher("/login.jsp");	
			requestDispatcher.forward(request, response);
		}
	}

%>

		<div align="right" style='font-weight:bold; width:100%; display:flex; '>
			<div style="font-size:50px; font-family: Brush Script MT;">Instagram</div>
			<div style="margin-left: auto; padding-top:7px;">Active Profile</div>
			<img height="30px" width="30px" alt="green" src="blinkDot.gif">
			<div style="padding-top:7px;padding-right:20px;"><%=" : "+sessionUser%></div>
			
		</div>
		<div style=' margin: 0 auto; width:auto;'>
			<form action='SearchUser.jsp' method="post" class="searchform">
				<input type="text" name="searchedKeyword" placeholder="search user"/>
				<input type="submit" value="search"/>
			</form>
				
			<div align="right">
				<form action="./logout" method="get" >
					<input style="background-color:red;" type="submit" value="logout" class="button"/>
				</form>
			</div>
			
		</div>
		
	    <div class="container">
	    	<div align="left">
	    		<form action="createPost.jsp" method="post" >
	    			<input type="submit" value="Create Post" class="button"/>
	    		</form>
	    	</div>
	        <div class="row">
	            <div class="left">
	            	<h2 style = 'font-family:cursive,Times,serif; font-style:italic; text-align:center;'>My connections</h2>
    		       <div class="user-card-container">
	            	<% 
	            	try{
		            	String getUsersQuery = "select main_user,connections from myconnections where main_user=? or connections=?";
		            	Connection connection = JdbcUtil.getJdbcConnection(); 
		            	PreparedStatement ps = connection.prepareStatement(getUsersQuery);
		            	ps.setString(1,sessionUser);
		            	ps.setString(2,sessionUser);
		            	ResultSet resultSet = ps.executeQuery();
		            	while(resultSet.next()){
		            		String username = resultSet.getString(1);
		            		String username1 = resultSet.getString(2);
		            		if(username.equals(username1))
		            			continue;
		            %>
						<div class="user-card">
						    <h1><%out.println((username.equals(sessionUser) ? username1 : username).toUpperCase().charAt(0));%></h1>

						    <div class="user-info">
						    	
						        <div class="username"><%out.println(username.equals(sessionUser) ? username1 : username);%></div>
						        <%System.out.println(username+" "+username1); %>
						    </div>
						</div>	
		            <%
		            	}
	            	}catch(Exception e){
	            		out.println("<h2 style='color:red;'>"+e.getMessage()+"</h2>");
	            		RequestDispatcher reqDis = request.getRequestDispatcher("/loginHome.jsp");
	            		reqDis.include(request, response);
	            	}
	            	%>
     				</div>
     				
	            </div>
	            <div class="middle">
					   <div class="card-img-container">
					<%
					try{
						// String getPostQuery = "select username, image, caption from posts where username IN (select main_user from myconnections where connections=?) and username IN (select connections from myconnections where main_user=?)";                            
						String getPostQuery = "select username, image, caption from posts "+
						"where username IN (select connections from myconnections where main_user=? "+" union "+
						" select main_user from myconnections where connections=?)";
						Connection connection = JdbcUtil.getJdbcConnection();
						PreparedStatement ps = connection.prepareStatement(getPostQuery);
						ps.setString(1,sessionUser);
						ps.setString(2,sessionUser);
						ResultSet resultSet = ps.executeQuery();
						while(resultSet.next()){
							String username = resultSet.getString(1);
							String caption = resultSet.getString(3);
							InputStream stream = resultSet.getBinaryStream(2);
							if (stream != null) {
					            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
					            byte[] buffer = new byte[4096];
					            int bytesRead = -1;
					            while ((bytesRead = stream.read(buffer)) != -1) {
					                outputStream.write(buffer, 0, bytesRead);
					            }
					            byte[] imageBytes = outputStream.toByteArray();
					            String base64Image = Base64.getEncoder().encodeToString(imageBytes);
					            String imageSrc = "data:image/jpeg;base64," + base64Image; // Change the MIME type accordingly
				%>	
					            
						<div class="card">
                   			<div class="card-header">
                     		    Post by <span class="font-weight-bold"><%=username %></span>
                   			</div>
                   			 <img src="<%= imageSrc %>" alt="Image" class="card-img-top">
		                    <div class="card-body">
		                        <p class="card-caption"><%= caption %></p>
		                    </div>
						</div>
				<%
					        } else {
					             out.println("No image found");
				
				 	        }
							
						}
					}catch(Exception e){
						e.printStackTrace();
					}
					%>
					   </div>

	            </div>
	            <div class="right">
	            	<h2 style = 'font-family:cursive,Times,serif; font-style:italic; text-align:center;'>Pending requests</h2>
				    <div class="user-card-container">
	            	<% 
	            	try{
		            	String getUsersQuery = "select from_user from pendingrequest where for_user=?";
		            	Connection connection = JdbcUtil.getJdbcConnection(); 
		            	PreparedStatement ps = connection.prepareStatement(getUsersQuery);
		            	ps.setString(1,sessionUser);
		            	ResultSet resultSet = ps.executeQuery();
		            	while(resultSet.next()){ 
		            		String username = resultSet.getString(1);
		            %>
						<div class="user-card">
						    <h1><%out.println(username.toUpperCase().charAt(0));%></h1>
						    <div class="user-info">
						        <div class="username"><%=username%></div>
						        <form action="./accept" method="post">
						        <input type="text" value="<%=username%>" name="acceptUser" hidden/>
								<input type="submit" class="button" value="Accept"/>
						        </form>
						    </div>
						</div>	
		            <%
		            	}
	            	}catch(Exception e){
	            		out.println("<h2 style='color:red;'>"+e.getMessage()+"</h2>");
	            		RequestDispatcher reqDis = request.getRequestDispatcher("/loginHome.jsp");
	            		reqDis.include(request, response);
	            	}
	            	%>
     				</div>
	            
	            </div>
	        </div>
	    </div>

</body>
</html>