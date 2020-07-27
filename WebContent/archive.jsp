<%@page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@page import="java.time.*"%>
<%@page import="java.time.temporal.ChronoUnit"%>
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

.margin {
	border: 1px solid white;
	margin-top: 25px;
	margin-bottom: 100px;
	margin-right: 50px;
	margin-left: 100px;
}

.row {
	margin-left: 100px;
	display: flex;
}

.column {
	flex: 50%;
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
	<%
	    int userId=(int) session.getAttribute("userId");
		String pregName = (String) session.getAttribute("pregName");
		String isNowPreg = (String) session.getAttribute("isNowPreg");
		int noOfTimesPreg = (int) session.getAttribute("noOfTimesPreg");
		//isNowPreg.equals("false") || isNowPreg.equals("true") || 
		if((isNowPreg.equals("true") && noOfTimesPreg>1) || (noOfTimesPreg>0 && isNowPreg.equals("false")) ){
			%>
	<center>
		<br />
		<h3>Know About Your Archived Pregnancy Details here:</h3>
		<br />

		<%
			String startDate="";
			String endDate="";
			try {
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/poshanabhiyaan", "root",
						"root");
				PreparedStatement pstmt = con.prepareStatement("select * from pregnantPerson where userid=?");
				pstmt.setInt(1, userId);
				ResultSet rs = pstmt.executeQuery();
				while (rs.next()) {
					startDate=rs.getString("startDateOfPreg");
					endDate=rs.getString("day261Date");
					LocalDate SystemDate = java.time.LocalDate.now();
					LocalDate date = LocalDate.parse(endDate);
					long daysBetween = ChronoUnit.DAYS.between(SystemDate, date);
					if(daysBetween<0){
					%>
		<center>
			<h3>
				<%out.print(startDate);%>
				to
				<%out.print(endDate); %>
			</h3>
		</center>
		<center>
			<form action='archivePregnantDetails.jsp' method='get'>
			 <input type="hidden" name="lastDate" value="<%out.print(endDate); %>">
				<input type="submit"
					style="color: blanchedalmond; font-size: large; height: 100px; width: 250px; background-color: #3973ac; align-content: center"
					name="pregName" value=" <%out.print(pregName);%> ">
			</form>
		</center>
		<%
		}
				}
		}catch(Exception e){
				e.printStackTrace();
			}
		}
			else{
				%>
			<h2>No Archives Available</h2>
			<%
			}
			%>
	
</body>
</html>