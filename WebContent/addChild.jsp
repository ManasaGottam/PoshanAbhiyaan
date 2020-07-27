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
	function giveChildren() {
		var n = document.getElementById("noofchildren").value;
		console.log("no.of children: " + n);
		var res = "<br/>";
		for (var i = 0; i < n; i++) {
			res = res
					+ "Name:<input type='text' id='cName' name='cName' required > &nbsp Gender :<select id='cGender' name='cGender' required><option value='male'>Male</option><option value='female'>Female</option><option value='other'>Other</option></select>&nbspDate of Birth :<input type='Date' id='cDob' name='cDob' required><br/><br/>"
		}
		console.log("res: " + res);
		document.getElementById('childInfo').innerHTML = res;
		var button = "<input class=\"button\" type=\"submit\"  name=\'AddChildDetails\' value=\"Add Child Details\">"
		document.getElementById('button').innerHTML = button;
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
		<h3>Want to add CHILD? Fill in the details.</h3>
		<form action="addChild.jsp">
			<div id="ifYes" style="display: block">
				No.of Children: <input type="text" name="noofchildren"
					id="noofchildren" placeholder="maximum 3 children are only allowed"
					onkeyup="javascript:giveChildren();">
				<div id="childInfo"></div>
			</div>
			<div id="button"></div>
			</div>
		</form>
	</center>

<%
System.out.println("No.of children: "+request.getParameter("noofchildren"));
if(request.getParameter("noofchildren")!=null){
int noOfChildren=Integer.parseInt(request.getParameter("noofchildren"));
    int parent=(Integer)session.getAttribute("userId");
	if(noOfChildren>0){	
		try {
			java.sql.Connection con;
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/poshanabhiyaan?autoReconnect=true&useSSL=false", "root", "root");
			
			String cNames[] = request.getParameterValues("cName");
			String cDobs[] = request.getParameterValues("cDob");
			String cGenders[] = request.getParameterValues("cGender");

		for(int i=1;i<=noOfChildren;i++){
			String cName =cNames[i-1];
			String cGender =cGenders[i-1]; 
			String cDob =cDobs[i-1];
			System.out.println("cDob " + i + ": " + cDob);

			Date date = Date.valueOf(cDob);
			System.out.println("Date of birth: " + date);

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar c = Calendar.getInstance();
			try {
				// Setting the date to the given date
				c.setTime(sdf.parse(cDob));

				// Number of Days to add
				c.add(Calendar.DAY_OF_MONTH, 42);
				// Date after adding the days to the given date
				String day42 = sdf.format(c.getTime());

				c.setTime(sdf.parse(cDob));
				c.add(Calendar.DAY_OF_MONTH, 71);
				String day71 = sdf.format(c.getTime());

				c.setTime(sdf.parse(cDob));
				c.add(Calendar.DAY_OF_MONTH, 99);
				String day99 = sdf.format(c.getTime());

				c.setTime(sdf.parse(cDob));
				c.add(Calendar.DAY_OF_MONTH, 472);
				String day472 = sdf.format(c.getTime());

				c.setTime(sdf.parse(cDob));
				c.add(Calendar.DAY_OF_MONTH, 1780);
				String day1780 = sdf.format(c.getTime());

				c.setTime(sdf.parse(cDob));
				c.add(Calendar.DAY_OF_MONTH, 3560);
				String day3560 = sdf.format(c.getTime());

				c.setTime(sdf.parse(cDob));
				c.add(Calendar.DAY_OF_MONTH, 4300);
				String day4300 = sdf.format(c.getTime());

				// Displaying the new Date after addition of Days
				System.out.println("day42: " + day42);
				System.out.println("day71: " + day71);
				System.out.println("day99: " + day99);
				System.out.println("day472: " + day472);

				PreparedStatement pstmt3 = con.prepareStatement(
						"insert into child(cName,cGender,cDob,parent,day0,day42,day71,day99,day472,day1780,day3560,day4300) values(?,?,?,?,?,?,?,?,?,?,?,?);");

				pstmt3.setString(1, cName);
				pstmt3.setString(2, cGender);
				pstmt3.setString(3, cDob);
				pstmt3.setInt(4, parent);
				pstmt3.setString(5, cDob);
				pstmt3.setString(6, day42);
				pstmt3.setString(7, day71);
				pstmt3.setString(8, day99);
				pstmt3.setString(9, day472);
				pstmt3.setString(10, day1780);
				pstmt3.setString(11, day3560);
				pstmt3.setString(12, day4300);

				int rs3 = pstmt3.executeUpdate();
				if (rs3 > 0) {
					System.out.println("Child entry entered into db");
				}
		}
		catch (Exception e) {
				System.out.println("Date parsing exception");
				e.printStackTrace();
		}
		}
		%>
		<jsp:forward page="profile.jsp" ></jsp:forward>
		<%
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
}
	%>
</body>
</html>