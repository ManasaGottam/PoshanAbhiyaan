<%@page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@page import="java.time.*"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src='https://kit.fontawesome.com/a076d05399.js'></script>

<title>Poshan Abhiyaan</title>
<script>
	function logout() {
		location.href = "home.html";
	};
</script>
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

	<br />
	<br />
	<h1>
		<%
			int userId = (int) session.getAttribute("userId");
			String lastDatePreg = null;
			int noOfTimesPreg=0;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/poshanabhiyaan", "root",
						"root");
				
				
				ArrayList<String> startDates = new ArrayList<>();
				ArrayList<String> lastDates = new ArrayList<>();

				PreparedStatement pstmt2 = con.prepareStatement("select * from pregnantPerson where userid=?");
				pstmt2.setInt(1, userId);
				ResultSet rs2 = pstmt2.executeQuery();
				while (rs2.next()) {
					session.setAttribute("pregId", rs2.getInt("ppid"));
					session.setAttribute("pregName", session.getAttribute("userName"));
					startDates.add(rs2.getString("startDateOfPreg"));
					lastDates.add(rs2.getString("day261Date"));
					noOfTimesPreg++;
					//isPregnant="true";
				}
				Collections.sort(startDates);
				Collections.sort(lastDates);
				if(noOfTimesPreg>0){
				System.out.println(lastDates + " : " + lastDates.get(lastDates.size() - 1));
				session.setAttribute("startDateOfPreg", startDates.get(startDates.size() - 1));
				session.setAttribute("lastDateOfPreg", lastDates.get(lastDates.size() - 1));
				lastDatePreg = lastDates.get(lastDates.size() - 1);
				}
				//session.setAttribute("isPregnant",isPregnant);

			} catch (Exception e) {
				e.printStackTrace();
			}
			String isNowPreg = "false";
			long daysBetween = -1;
			if (lastDatePreg != null) {
				LocalDate SystemDate = java.time.LocalDate.now();
				LocalDate date = LocalDate.parse(lastDatePreg);
				daysBetween = ChronoUnit.DAYS.between(SystemDate, date);
				if (daysBetween >= 0) {
					isNowPreg = "true";
				}
			}
			int noOfChildren = (Integer) session.getAttribute("noOfChildren");
			//int noOfTimesPreg = (int) session.getAttribute("noOfTimesPreg");
			System.out.println("noOfTimesPreg: " + noOfTimesPreg + " daysBetween: " + daysBetween + " noOfChildren: "
					+ noOfChildren);
			session.setAttribute("isNowPreg", isNowPreg);
			session.setAttribute("noOfTimesPreg", noOfTimesPreg);

			if (noOfChildren == 0 && !isNowPreg.equals("true") && daysBetween < 0) {
				System.out.println("Inside isNowPreg: " + isNowPreg + " daysBetween: " + daysBetween + " noOfChildren: "
						+ noOfChildren);
		%>
		<center>
		<h2>
			Add your pregnancy detials or Add Children in <a href="profile.jsp">Profile
				Section</a>
		</h2>
		<br />
		<h2>To Know about Pregnancy and child care navigate</h2>
		<form action="women.html" method='get'>
			<input type="submit"
				style="margin-left: 100px; color: blanchedalmond; font-size: large; height: 100px; width: 250px; background-color: #0088cc; align-content: center"
				name='PregnancyDetails' value="Know About Pregnancy">
		</form>
		<br /> <br />
		<form action="child.html" method='get'>
			<input type="submit"
				style="margin-left: 100px; color: blanchedalmond; font-size: large; height: 100px; width: 250px; background-color: #99003d; align-content: center"
				name='ChildDetails' value="Know About Child care">
		</form>
		</center>
		<%
		
			}
			if (noOfTimesPreg > 0 && daysBetween >= 0) {
		%>
<center>
		<h3>
			<b> Pregnancy: Vaccination & Nutritions </b>
		</h3>
		</center>
		<%
			String pregName = (String) session.getAttribute("pregName");
				String startDateOfPreg = (String) session.getAttribute("startDateOfPreg");
		%>
		<center>
			
			<form action='PregnantDetails.jsp' method='get'>

				<input type="submit"
					style="color: blanchedalmond; font-size: 30px; height: 120px; width: 300px; background-color: #009999; align-content: center"
					name="pregName" value=" <%out.print(pregName);%> ">
			</form>
			 <br />
			<%
				}
				if (session.getAttribute("noOfChildren") != null && noOfChildren > 0) {
			%>
			<br />
			<h3>
				<b>Children: Vaccination & Nutritions</b>
			</h3>
		</center>
		<%
			ArrayList<String> childNames = (ArrayList<String>) session.getAttribute("childNames");
				ArrayList<Integer> childIds = (ArrayList<Integer>) session.getAttribute("childIds");
				if (childNames != null && childIds != null)
					for (int i = 0; i < childNames.size(); i++) {
		%>
		<center>
			<br /> <br />
			<form action='ChildDetails.jsp' method='get'>

				<input type="submit"
					style="color: blanchedalmond; font-size: 30px; height: 120px; width: 300px; background-color: #cc0066; align-content: center"
					name="childName" value=" <%out.print(childNames.get(i));%> ">
			</form>
			<%
				}
				}
			%>
		</center>
</body>
</html>