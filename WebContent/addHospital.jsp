<%@page import="java.util.*"%>
<%@ page import="java.sql.Date"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
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
		<li><a href="InfoHomePage.html">Home</a></li>
		<li><a href="UserHomePage.jsp">Track Your Records</a></li>
		<li><a href="women.html">Women</a></li>
		<li><a href="child.html">Child</a></li>
		<li><a href="EmergencySearch.html">Emergency</a></li>
		<li><a href="archive.jsp">Archive</a></li>
		<li><a href="profile.jsp"> My Profile</a></li>
		<li class="last"><a href="UserLogout">Logout</a></li>
	</ul>
	<center>

		<%
			String hpinCode = request.getParameter("hpincode");

			try {
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/poshanabhiyaan?autoReconnect=true&useSSL=false", "root",
						"root");

		if (hpinCode != null) {
						String hName = request.getParameter("hname");
						String hAddress = request.getParameter("haddress");
						String hPhone = request.getParameter("hphone");
						PreparedStatement pstmt1 = con.prepareStatement("select * from hospital where hName=? and hAddress=?;");
						pstmt1.setString(1,hName);
						pstmt1.setString(2,hAddress);
						ResultSet rs1=pstmt1.executeQuery();
						if(!rs1.next()){						
						PreparedStatement pstmt2 = con.prepareStatement(
								"insert into hospital(hName,hAddress,hPhone,hPinCode) values(?,?,?,?);");
						pstmt2.setString(1, hName);
						pstmt2.setString(2, hAddress);
						pstmt2.setString(3, hPhone);
						pstmt2.setString(4, hpinCode);
						int rs2 = pstmt2.executeUpdate();
						if(rs2>0){
							System.out.println("Inserted into hospitals db");
						}
						}
			} 
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		%>
		<jsp:forward page="EmergencySearch.html"></jsp:forward>
	</center>
</body>
</html>