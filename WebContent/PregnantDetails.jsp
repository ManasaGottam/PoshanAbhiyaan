<%@page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Poshan ABhiyaan</title>
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
		Pregnancy Information of
		<%
		out.println(request.getParameter("pregName"));
	%>:
	</h2>
	<%
		String isNowPreg = (String) session.getAttribute("isNowPreg");
		int userId = (int) session.getAttribute("userId");
		if ((Integer) session.getAttribute("userId") != null) {
			int pregId = (Integer) session.getAttribute("userId");
			try {
				java.sql.Connection con;
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(
						"jdbc:mysql://localhost:3306/poshanabhiyaan?autoReconnect=true&useSSL=false", "root",
						"root");

				ArrayList<String> dates = new ArrayList<>();
				ArrayList<String> tests = new ArrayList<>();
				PreparedStatement pstmt = con.prepareStatement("select * from pregnantPerson where userid=? and day261Status!='true'");
				pstmt.setInt(1, userId);
				ResultSet rs = pstmt.executeQuery();
				while (rs.next()) {
					dates.add(rs.getString("day31Date"));
					dates.add(rs.getString("day61Date"));
					dates.add(rs.getString("day91Date"));
					dates.add(rs.getString("day121Date"));
					dates.add(rs.getString("day151Date"));
					dates.add(rs.getString("day181Date"));
					dates.add(rs.getString("day196Date"));
					dates.add(rs.getString("day211Date"));
					dates.add(rs.getString("day226Date"));
					dates.add(rs.getString("day241Date"));
					dates.add(rs.getString("day248Date"));
					dates.add(rs.getString("day255Date"));
					dates.add(rs.getString("day261Date"));
				}
				System.out.println(dates);
				PreparedStatement pstmt2 = con.prepareStatement("select * from pregnantTests;");
				ResultSet rs2 = pstmt2.executeQuery();
				while (rs2.next()) {
					tests.add(rs2.getString("tests"));

				}
				System.out.println(tests);
	%>
	<table border=1 align="center" bordercolor="black" bgcolor="#e6f2ff"
		width="1000" height="500">
		<col width="180">
		<col width="500">
		<caption align=top>
			<h3>Dates on which Tests to be taken</h3>
		</caption>
		<th>Date:</th>
		<th>Tests:</th>

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
					String vaccines[] = tests.get(i).split(",");
								for (int j = 0; j < vaccines.length; j++) {
									out.println(vaccines[j]);
				%><br />
				<%
					}
				%>
			</td>
		</tr>

		<%
			}
		%>
	</table>
	<br />
	<br />
	<%
		} catch (SQLException e) {
				out.println("SQLException caught: " + e.getMessage());
			}
		}
		if (isNowPreg.equals("true")) {
	%>
	<jsp:include page="DailyMealSuggestion.jsp"></jsp:include>
	<%
		}
	%>
</body>
</html>