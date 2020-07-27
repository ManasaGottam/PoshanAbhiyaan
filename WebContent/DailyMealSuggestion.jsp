<%@page import="java.util.TimeZone"%>
<%@page import="dailyMeal.Meal" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.time.temporal.WeekFields"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Poshan Abhiyaan</title>
</head>
<body>
	<%
		Meal[] weeklyMeals = new Meal[8];
		// 1 - Sunday
		weeklyMeals[1] = new Meal("Low-Gi muesli,Natural yoghurt,Few slices of your favourite fruit",
				"Soya and potato (aloo) curry,\n Ladies Finger,\n Curd,\n Chapati/ Rice",
				"Lemonade, Mixed nuts and raisins", "Mung bean dal, Mixed Veg Curry, Chapati/ Rice");
		weeklyMeals[2] = new Meal("Sprouts paratha , Buttermilk", "Spinach and Corn Curry, Chapati/ Rice", "Banana",
				"Peas and mint soup, Pasta with tomato sauce");
		weeklyMeals[3] = new Meal("Sautéed mushrooms, Wholewheat toast, Banana milkshake",
				"Mixed dal, Carrot and peas sabzi, Curd (dahi), Pearl millet (bajra) roti", "Roasted Peanuts",
				"Cumin and potato curry, Chapati/ Rice");
		weeklyMeals[4] = new Meal("Tomato and cucumber sandwich with mint chutney, Pineapple juice",
				"Black gram dal, Brinjal bharta, Curd, Chapati/rice", "Coconut water, Roasted chickpeas",
				"Paalak Paneer, Jowar Roti");
		weeklyMeals[5] = new Meal("Low-Gi muesli,Natural yoghurt,Few slices of your favourite fruit",
				"Soya and potato (aloo) curry,\n Ladies Finger,\n Curd,\n Chapati/ Rice",
				"Lemonade, Mixed nuts and raisins", "Mung bean dal, Mixed Veg Curry, Chapati/ Rice");
		weeklyMeals[6] = new Meal("Sprouts paratha , Buttermilk", "Spinach and Corn Curry, Chapati/ Rice", "Banana",
				"Peas and mint soup, Pasta with tomato sauce");
		weeklyMeals[7] = new Meal("Sautéed mushrooms, Wholewheat toast, Banana milkshake",
				"Mixed dal, Carrot and peas sabzi, Curd (dahi), Pearl millet (bajra) roti", "Roasted Peanuts",
				"Cumin and potato curry, Chapati/ Rice");
		Calendar calendar = Calendar.getInstance(TimeZone.getDefault());
		int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
		Meal todaysMeal = weeklyMeals[dayOfWeek];
	%>
	<table border=1 align="center"  bordercolor = "black" bgcolor = "#f2e6ff" width = "1000" height = "300">
		<col width="180">
		<col width="500">
		<caption align=top>
			<h3>Today's Meal</h3>
		</caption>
		<tr>
			<td align="center">BreakFast</td>
			<td align="center">
				<%
					String[] food = todaysMeal.getBreakfast().split(",");
					for (int i = 0; i < food.length; i++) {
						out.println(food[i]);
				%> <br> <%
 	}
 %>
			</td>
		</tr>
		<tr>
			<td align="center">Lunch</td>
			<td align="center">
				<%
					food = todaysMeal.getLunch().split(",");
					for (int i = 0; i < food.length; i++) {
						out.println(food[i]);
				%> <br> <%
 	}
 %>
			</td>
		</tr>
		<tr>
			<td align="center">Snack</td>
			<td align="center">
				<%
					food = todaysMeal.getSnack_option().split(",");
					for (int i = 0; i < food.length; i++) {
						out.println(food[i]);
				%> <br> <%
 	}
 %>
			</td>
		</tr>
		<tr>
			<td align="center">Dinner</td>
			<td align="center">
				<%
					food = todaysMeal.getDinner().split(",");
					for (int i = 0; i < food.length; i++) {
						out.println(food[i]);
				%> <br> <%
 	}
 %>
			</td>
		</tr>

	</table>
	<br/><br/>
</body>
</html>