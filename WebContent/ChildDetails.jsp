<%@page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Poshan Abhiyaan</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src='https://kit.fontawesome.com/a076d05399.js'></script>
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

}
.imgcontainer {
	text-align: center;
	margin: 24px 0 12px 0;
}

.container {
	padding: 16px;
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
	<h2>
		Vaccination Information of
		<%
		out.println(request.getParameter("childName"));
	%>:
	</h2>
	<%
		ArrayList<String> childNames = (ArrayList<String>) session.getAttribute("childNames");
		ArrayList<Integer> childIds = (ArrayList<Integer>) session.getAttribute("childIds");
		try {
			java.sql.Connection con;
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/poshanabhiyaan?autoReconnect=true&useSSL=false", "root", "root");
			String childName = request.getParameter("childName");
			System.out.println("childname curr: " + childName);
			System.out.println("childnames ALL curr: " + childNames);
			System.out.println("childids all curr: " + childIds);

			int childId = 0;
			for (int i = 0; i < childNames.size(); i++) {
				String name = childNames.get(i);
				System.out.print(i + " : " + name + " : " + childName);
				if (name.contains(childName) || childName.contains(name)) {
					System.out.println("CORRECT: " + i + " : " + name + " : " + childName);
					childId = childIds.get(i);
				}
			}

			System.out.println("Child Id: " + childId);

			ArrayList<String> dates = new ArrayList<>();
			ArrayList<String> vaccinations = new ArrayList<>();

			PreparedStatement pstmt = con.prepareStatement("select * from child where cId=?");
			pstmt.setInt(1, childId);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				dates.add(rs.getString("day0"));
				dates.add(rs.getString("day42"));
				dates.add(rs.getString("day71"));
				dates.add(rs.getString("day99"));
				dates.add(rs.getString("day472"));
				dates.add(rs.getString("day1780"));
				dates.add(rs.getString("day3560"));
				dates.add(rs.getString("day4300"));
			}
			System.out.println(dates);
			PreparedStatement pstmt2 = con.prepareStatement("select * from childvaccinations;");
			ResultSet rs2 = pstmt2.executeQuery();
			while (rs2.next()) {
				vaccinations.add(rs2.getString("day0"));
				vaccinations.add(rs2.getString("day42"));
				vaccinations.add(rs2.getString("day71"));
				vaccinations.add(rs2.getString("day99"));
				vaccinations.add(rs2.getString("day472"));
				vaccinations.add(rs2.getString("day1780"));
				vaccinations.add(rs2.getString("day3560"));
				vaccinations.add(rs2.getString("day4300"));
			}
			System.out.println(vaccinations);
	%>
	<table border=1 align="center"  bordercolor = "black" bgcolor = "#e6ffe6" width = "900" height = "600">
		<col width="180">
		<col width="500">
		<caption align=top>
			<h3>Dates on which Vaccinations to be taken</h3>
		</caption>
		<th>Date:</th>
		<th>Vaccinations:</th>

		<%
			for (int i = 0; i < dates.size(); i++) {
		%>
		<tr>
			<td align="center">
				<%
					out.println(dates.get(i));
				%>
			</td>
			<td align="center">
				<%
				String vaccines[]=vaccinations.get(i).split(",");
				for(int j=0;j<vaccines.length;j++){
					out.println(vaccines[j]);%><br/><%
				}
					//out.println(vaccinations.get(i));
				%>
			</td>
		</tr>
		<%
			}
			} catch (SQLException e) {
				out.println("SQLException caught: " + e.getMessage());
			}
		%>
	</table>
</body>
</html>