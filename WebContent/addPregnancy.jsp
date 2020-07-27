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
<title>Document</title>
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
<script language="Javascript">
	function pregnantCheck() {
		if (document.getElementById('yesPregCheck').checked) {
			document.getElementById('ifYesPreg').style.display = 'block';
			document.getElementById('ifNoPreg').style.display = 'none';
		} else if (document.getElementById('noPregCheck').checked) {
			document.getElementById('ifNoPreg').style.display = 'block';
			document.getElementById('ifYesPreg').style.display = 'none';
		}
	}
</script>

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
	<br/><br/>
		<h2>Want to add Pregnancy Details? Fill in the details.</h2>
		<br/>
		<form action="addPregnancy.jsp" method = "get">
				<h3>Start Date of Pregnancy:</h3> <input style="font-size: 16pt; height: 40px; width:280px; "  type="date" name="pregnancyDate" id="pregnancyDate"	>
			<br/><br/><input class ="button" type = "submit" name = "Add Pregnancy Details" value="AddPregnancyDetails">
					
			</div>
		</form>
	</center>
	<%
		System.out.println("preg date: " + request.getParameter("pregnancyDate"));
		if (request.getParameter("pregnancyDate") != null) {
			String pregnancyDate = (String) request.getParameter("pregnancyDate");
			session.setAttribute("pregnancyDate", pregnancyDate);
			try {
				java.sql.Connection con;
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(
						"jdbc:mysql://localhost:3306/poshanabhiyaan?autoReconnect=true&useSSL=false", "root",
						"root");
				int userId = (Integer) session.getAttribute("userId");
				//				Date pregDate = Date.valueOf(pregnancyDate);
				int[] days = { 31, 61, 91, 121, 151, 181, 196, 211, 226, 241, 248, 255, 261 };
				String[] alertDates = new String[days.length];
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar c = Calendar.getInstance();
				try {
					for (int i = 0; i < days.length; i++) {
						c.setTime(sdf.parse(pregnancyDate));
						c.add(Calendar.DAY_OF_MONTH, days[i]);
						alertDates[i] = sdf.format(c.getTime());
					}
					PreparedStatement pstmtPreg = con.prepareStatement(
							"insert into pregnantPerson(userid, startDateOfPreg,day31Date, day61Date, day91Date, day121Date, day151Date, day181Date, day196Date, day211Date, day226Date, day241Date, day248Date, day255Date, day261Date, day261Status ) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'false')");
					pstmtPreg.setInt(1, userId);
					pstmtPreg.setString(2, pregnancyDate);
					for (int i = 0; i < alertDates.length; i++) {
						pstmtPreg.setString(i + 3, alertDates[i]);
						System.out.println(i + 3 + " " + alertDates[i]);
					}
					int rs3 = pstmtPreg.executeUpdate();
					if (rs3 > 0) {
						System.out.println("Pregnant entry entered into db");
	%>
	<jsp:forward page="profile.jsp"></jsp:forward>
	<%
		}
				} catch (Exception e) {
					e.printStackTrace();
				}
			} catch (Exception e) {
			}
		}
	%>


</body>
</html>