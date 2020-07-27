<%@page import="java.util.*"%>
<%@ page import="java.sql.Date"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Poshan Abhiyaan</title>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src='https://kit.fontawesome.com/a076d05399.js'></script>
<title>Poshan Abhiyaan</title>
<style>
ul {
	list-style-type: none;
	overflow: hidden;
	background-color: rgb(80, 4, 80);
}
li {
	float: left;
}
li a {
	display: block;
	color: white;
	text-align: center;
	padding: 30px 30px;
	text-decoration: none;
}
* {
	box-sizing: border-box;
}
body {
	font-family: Arial, Helvetica, sans-serif;
}
/* Remove extra left and right margins, due to padding */
.row {
	margin: 0 -5px;
}
/* Responsive columns */
@media screen and (max-width: 600px) {
	.column {
		width: 100%;
		display: block;
		margin-bottom: 20px;
	}
}
/* Style the counter cards */
.center {
	display: block;
	margin-left: auto;
	margin-right: auto;
	width: 50%;
}
.button {
	background-color: rgb(5, 80, 8);
	border: none;
	color: white;
	padding: 15px 32px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 16px;
	margin: 4px 2px;
	cursor: pointer;
}
* {
	box-sizing: border-box;
}
li.last {
	float: right !important;
}
</style>
</head>
<body>
	<ul>
	        <li><a href="home.html">Home</a></li>
	
		<li><a href="HomePregnancy.html">Women</a></li>
		<li><a href="HomeChild.html">Child</a></li>
		<li><a href="HomeEmergency.html">Emergency</a></li>
		<li class="last"><a href="UserLogin.html">Login</a></li>
	</ul>
	<center>

<%
String pinCode = request.getParameter("pincode");
if(pinCode!=null) {
	int noOfRecords=0;
	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/poshanabhiyaan", "root", "root");
		PreparedStatement pstmt = con.prepareStatement("select * from hospital where hPinCode=?");
		pstmt.setString(1, pinCode);
		ResultSet rs = pstmt.executeQuery();
		
		while (rs.next()) {
			noOfRecords++;
			String hName= rs.getString("hName");
			String hAddress=rs.getString("hAddress");
			String hPhone=rs.getString("hPhone");
		%>
		<h2><%out.print(hName);%></h2>
		<h3><%out.print(hAddress);%></h3>
		<h3><%out.print(hPhone);%></h3>
		<br/><br/>
		<%
		}
	}catch(Exception ex) {
		ex.printStackTrace();
	}
	if(noOfRecords==0){
		%>
		<h3>Sorry.. No Hospitals available</h3>
		<%
	}
}
else{
	%>
	<jsp:forward page="HomeEmergency.html"></jsp:forward>
	<%
}
%>
</center>
</body>
</html>