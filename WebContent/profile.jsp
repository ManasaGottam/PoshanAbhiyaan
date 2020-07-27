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
		String userMail = (String) session.getAttribute("userMail");
		int userId = (int) session.getAttribute("userId");
		//String isPreg = (String) session.getAttribute("isPregnant");
		String pregName = (String) session.getAttribute("pregName");
		String isNowPreg="false";
		String lastDatePreg = null;
		int noOfTimesPreg=0;
		int noOfChildren = 0;
		//String isPregnant = "";
		ArrayList<String> childNames = new ArrayList<>();
		ArrayList<Integer> childIds = new ArrayList<>();
		ArrayList<String> startDates = new ArrayList<>();
		ArrayList<String> lastDates = new ArrayList<>();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/poshanabhiyaan", "root",
					"root");
			PreparedStatement pstmt = con.prepareStatement("select * from child where parent=?");
			pstmt.setInt(1, userId);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				noOfChildren++;
				String cName = rs.getString("cName");
				childNames.add(cName);
				// session.setAttribute("cName", cName);

				int cId = rs.getInt("cId");
				childIds.add(cId);
				// session.setAttribute("cId", cId);
			}
			System.out.println("list: " + childIds);
			session.setAttribute("childNames", childNames);
			session.setAttribute("childIds", childIds);
			session.setAttribute("noOfChildren", noOfChildren);
			session.setAttribute("userId", userId);


			PreparedStatement pstmt2 = con.prepareStatement("select * from pregnantPerson where userid=?");
			pstmt2.setInt(1, userId);
			ResultSet rs2 = pstmt2.executeQuery();
			while (rs2.next()) {
				session.setAttribute("pregName", session.getAttribute("userName"));
				pregName=(String)session.getAttribute("userName");
				session.setAttribute("startDateOfPreg", rs2.getString("startDateOfPreg"));
				//isPregnant = "true";
				startDates.add(rs2.getString("startDateOfPreg"));
				lastDates.add(rs2.getString("day261Date"));
				noOfTimesPreg++;
			}
			Collections.sort(startDates);
			Collections.sort(lastDates);
			if(noOfTimesPreg>0){
			System.out.println(lastDates + " : " + lastDates.get(lastDates.size() - 1));
			session.setAttribute("startDateOfPreg", startDates.get(startDates.size() - 1));
			session.setAttribute("lastDateOfPreg", lastDates.get(lastDates.size() - 1));
			lastDatePreg = lastDates.get(lastDates.size() - 1);
			}
			//session.setAttribute("isPregnant", isPregnant);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//String isNowPreg = "false";
		long daysBetween = -1;
		if (lastDatePreg != null) {
			LocalDate SystemDate = java.time.LocalDate.now();
			LocalDate date = LocalDate.parse(lastDatePreg);
			daysBetween = ChronoUnit.DAYS.between(SystemDate, date);
			if (daysBetween >= 0) {
				isNowPreg = "true";
			}
		}
		session.setAttribute("isNowPreg",isNowPreg);
		session.setAttribute("noOfTimesPreg",noOfTimesPreg);
		session.setAttribute("noOfChildren",noOfChildren);
	%>
	<div class="row">
		<div class="column">
		
			<h3>You can add your Child here:</h3>
			<br/>
			<form action="addChild.jsp" method='get'>
				<input type="submit"
					style="margin-left: 100px; color: blanchedalmond; font-size: large; height: 100px; width: 250px; background-color: #99003d; align-content: center"
					name='addChild' value="Add Child">
			</form>
			<br /> <br />
			<%
				if (noOfChildren > 0) {
			%>
			<h3>Know About Your Children Vaccinations here:</h3>
			<%
				}
				for (int i = 0; i < noOfChildren; i++) {
			%>
			<br />
			<form action='ChildDetails.jsp' method='get'
				style='margin-left: 100px;'>
				<%
					out.print(
								"<input type='submit' style=\"color: blanchedalmond; font-size: large; height: 100px; width: 250px; background-color: #3973ac; align-content: center\" name='childName' value='"
										+ childNames.get(i) + "'>");
				%>
			</form>
			<br/>

			<%
				}
			%>
			
		</div>
		<div class="column">

			<%
				if (!isNowPreg.equals("true")) {
			%>
			<br />
			<br />
			<h3>Pregnant? Register here for pregnancy related information:</h3>
			<form action="addPregnancy.jsp" method='get'>
				<input type="submit"
					style="margin-left: 100px; color: blanchedalmond; font-size: large; height: 100px; width: 250px; background-color: #99003d; align-content: center"
					name='Add Pregancy Details' value="Add Pregancy Details">
			</form>
			<%
				} else{
			%>
			<center>
				<h3>Know About Your Pregnancy Details here:</h3>
				<br />
				<form action='PregnantDetails.jsp' method='get'>
					<input type="submit"
						style="margin-left: 100px; color: blanchedalmond; font-size: large; height: 100px; width: 250px; background-color: #3973ac; align-content: center"
						name="pregName" value=" <%out.print(pregName);%> ">
				</form>
				<%
					}
				%>
			
		</div>
	</div>
</body>
</html>