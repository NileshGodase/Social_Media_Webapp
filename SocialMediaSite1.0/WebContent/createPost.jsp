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
<title>Create new post</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css">
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f7f7f7;
        margin: 0;
        padding: 0;
    }
    .container {
        max-width: 600px;
        margin: 50px auto;
        background-color: #fff;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    }
    h1 {
        text-align: center;
    }
    form {
        text-align: center;
    }
    label {
        display: block;
        margin-bottom: 10px;
        font-weight: bold;
    }
    input[type="file"] {
        display: none;
    }
    .custom-file-upload {
        display: inline-block;
        border: 1px solid #ccc;
        padding: 6px 12px;
        cursor: pointer;
        background-color: #f9f9f9;
        border-radius: 5px;
    }
    input[type="text"] {
        width: 100%;
        padding: 10px;
        margin-top: 5px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }
    input[type="submit"] {
        padding: 10px 20px;
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }
    input[type="submit"]:hover {
        background-color: black;
        color: white;
    }
</style>

<script>
    function showFileName() {
        var fileInput = document.getElementById('imageUpload');
        var fileNameDisplay = document.getElementById('fileNameDisplay');
        fileNameDisplay.textContent = fileInput.files[0].name;
    }
</script>
</head>
<body>

<div class="container">
	
	<a href="loginHome.jsp" class="btn btn-primary">Go back</a>

    <h1>Create new post</h1>
    
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

    <form action="./uploadpost" method="post" enctype="multipart/form-data">
         <label for="imageUpload" class="custom-file-upload">
            <i class="fa fa-cloud-upload"></i> Upload Image
        </label>
        <input type="file" id="imageUpload" name="imageUpload" accept="image/*" onchange="showFileName()" required /><br><br>
        
        <label>Selected File: <span id="fileNameDisplay"></span></label><br><br>
        
        <label for="caption">Caption:</label>
		<input type="text" name="caption"  /><br><br> 
        
        <input  type="submit" value="Post" />
    </form>
</div>

</body>
</html>














