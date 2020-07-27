package registration;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mailapi.SendingMail;

/**
 * Servlet implementation class UserRegistration
 */
@WebServlet("/UserRegistration")
public class UserRegistration extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public UserRegistration() {
		// TODO Auto-generated constructor stub
	}
    // Get data from the form
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());
		String userName = request.getParameter("userName");
		String userMail = request.getParameter("userMail");
		String userPhone = request.getParameter("userPhone");
		String userAddress = request.getParameter("userAddress");
		String userPinCode = request.getParameter("userPinCode");
		String userPswd = request.getParameter("userPswd");

		SendingMail sm = new SendingMail();
		String generatedotp = sm.getRandom();
		System.out.println("Generated otp: " + generatedotp);

		System.out.println("Before including otp: ");
		HttpSession session = request.getSession();
		session.setAttribute("generatedotp", generatedotp);
		session.setAttribute("userMail", userMail);
		session.setAttribute("userMobile", userPhone);
		session.setAttribute("userName", userName);
		session.setAttribute("userPinCode", userPinCode);
		session.setAttribute("userPswd", userPswd);
		session.setAttribute("userAddress", userAddress);
		session.setAttribute("generatedotp", generatedotp);

		String children = request.getParameter("children");
		session.setAttribute("children", children);

		if (children.equals("yes")) {
			String noOfChildren = request.getParameter("noofchildren");
			session.setAttribute("noofchildren", noOfChildren);

			String cNames[] = request.getParameterValues("cName");
			String cDobs[] = request.getParameterValues("cDob");
			String cGenders[] = request.getParameterValues("cGender");

			for (int i = 1; i <= Integer.parseInt(noOfChildren); i++) {
				String name = "cName" + i;
				String gender = "cGender" + i;
				String dob = "cDob" + i;

				// System.out.println("cDob in get "+i+" :Value: "+cDobs[i-1]+" session: "+dob);
				session.setAttribute(name, cNames[i - 1]);
				session.setAttribute(gender, cGenders[i - 1]);
				session.setAttribute(dob, cDobs[i - 1]);
			}
		}
		String pregnant = request.getParameter("pregnant");
		if (pregnant.equals("yes")) {
			String pregnancyDate = request.getParameter("pregnancyDate");
			System.out.println("start of preg: " + pregnancyDate);
			session.setAttribute("pregnancyDate", pregnancyDate);
		}

		try {
			sm.setMailServerProperties();
			sm.createEmailMessage(userMail, "Your OTP is:" + generatedotp);
			sm.sendEmail();
		} catch (AddressException e) {
			// TODO Auto-generated catch block
			System.out.println("Enter valid address mail id");
			e.printStackTrace();
			RequestDispatcher rd = request.getRequestDispatcher("UserRegistration.html");
			rd.forward(request, response);
			return;
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		RequestDispatcher rd = request.getRequestDispatcher("EnterOTP.html");
		rd.forward(request, response);

	}

	// Post the form data into the database
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
		SendingMail sm = new SendingMail();

		String enteredotp = request.getParameter("otp");
		System.out.println("entered otp by user is: " + enteredotp);

		HttpSession session = request.getSession();

		String userPinCode = (String) session.getAttribute("userPinCode");
		String userName = (String) session.getAttribute("userName");
		String userMobile = (String) session.getAttribute("userMobile");
		String userMail = (String) session.getAttribute("userMail");
		String userPswd = (String) session.getAttribute("userPswd");
		String userAddress = (String) session.getAttribute("userAddress");
		String generatedotp = (String) session.getAttribute("generatedotp");
		String children = (String) session.getAttribute("children");
		String pregnancyDate = (String) session.getAttribute("pregnancyDate");

//		System.out.println(
//				userName + " " + userMobile + " " + userMail + " " + userPswd + " " + userAddress + " " + userPinCode);

		if (enteredotp.equals(generatedotp)) {

			try {
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection(
						"jdbc:mysql://localhost:3306/poshanabhiyaan?autoReconnect=true&useSSL=false", "root", "root");
				PreparedStatement stmt = con.prepareStatement("select * from user where userMail=?");
				stmt.setString(1, userMail);
				if (stmt.executeQuery().next()) {
					System.out.println("Already Registered User. Login");
					out.print("<html><body><h3>Already Registered with Provided Mail ID</h3></body></html>");
					RequestDispatcher rd = request.getRequestDispatcher("UserLogin.html");
					rd.forward(request, response);
					return;

				}
				PreparedStatement pstmt = con.prepareStatement(
						"insert into user(userName,userMail,userPswd,userMobile,userAddress,userPinCode) values(?,?,?,?,?,?);");

				pstmt.setString(1, userName);
				pstmt.setString(2, userMail);
				pstmt.setString(3, userPswd);
				pstmt.setString(4, userMobile);
				pstmt.setString(5, userAddress);
				pstmt.setString(6, userPinCode);

				int rs = pstmt.executeUpdate();
				if (rs > 0) {
					PreparedStatement pstmt2 = con.prepareStatement("select userId from user where userMail=?;");

					pstmt2.setString(1, userMail);
					ResultSet rs2 = pstmt2.executeQuery();
					int parent = 0;
					while (rs2.next()) {
						parent = rs2.getInt("userId");
					}

					if (children != null && children.equalsIgnoreCase("yes")) {

						String noOfChildren = (String) session.getAttribute("noofchildren");
						for (int i = 1; i <= Integer.parseInt(noOfChildren); i++) {
							String name = "cName" + i;
							String gender = "cGender" + i;
							String dob = "cDob" + i;
							String cName = (String) session.getAttribute(name);
							String cGender = (String) session.getAttribute(gender);
							String cDob = (String) session.getAttribute(dob);
							System.out.println("cDob " + i + " session: " + dob + ": " + cDob);

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

							PreparedStatement pstmt3 = con
									.prepareStatement("insert into child(cName,cGender,cDob,parent,day0,day42,day71,day99,day472,day1780,day3560,day4300) values(?,?,?,?,?,?,?,?,?,?,?,?);");

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
							
							
							} catch (ParseException e) {
								System.out.println("Date parsing exception");
								e.printStackTrace();
							}
						}

					}
					// Inserting the details of a pregnant if she is one
					if(pregnancyDate!=null && pregnancyDate != "") {

						int userId = parent;
//						Date pregDate = Date.valueOf(pregnancyDate);
						int[] days = {31, 61, 91, 121, 151, 181, 196, 211, 226, 241, 248, 255, 261};
						String[] alertDates = new String[days.length];
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						Calendar c = Calendar.getInstance();
						try {
						for(int i = 0 ; i< days.length ; i++) {
							c.setTime(sdf.parse(pregnancyDate));
							c.add(Calendar.DAY_OF_MONTH, days[i]);
							alertDates[i] = sdf.format(c.getTime());
						}
						LocalDate SystemDate = java.time.LocalDate.now();
						LocalDate lastDate = LocalDate.parse(alertDates[alertDates.length-1]);
						long lastDateToToday = ChronoUnit.DAYS.between(SystemDate, lastDate);
						String status="false";
						if(lastDateToToday<0) {
							status="true";
						}
						
						PreparedStatement pstmtPreg = con
								.prepareStatement("insert into pregnantPerson(userid, startDateOfPreg,day31Date, day61Date, day91Date, day121Date, day151Date, day181Date, day196Date, day211Date, day226Date, day241Date, day248Date, day255Date, day261Date, day261Status ) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
						pstmtPreg.setInt(1, userId);
						pstmtPreg.setString(2, pregnancyDate);
						int i=0;
						for(i = 0;i< alertDates.length ; i++) {
							pstmtPreg.setString(i+3, alertDates[i]);
							System.out.println(i+3 +" "+alertDates[i]);
						}
						pstmtPreg.setString(16, status);
						int rs3 = pstmtPreg.executeUpdate();
						if (rs3 > 0) {
							System.out.println("Pregnant entry entered into db");
						}						
						} 
						catch (ParseException e) {
							System.out.println("Date parsing exception");
							e.printStackTrace();
						}
						//------- end of data insertion in pregnant table --------------
					
					}
					

					System.out.println("Registered Successfully");
					RequestDispatcher rd = request.getRequestDispatcher("UserLogin.html");
					rd.forward(request, response);
					return;
				} else {
					System.out.print("Error");
				}
			}
			
			catch (Exception e) {
				System.out.println("in catch block for connecting sql driver");
				e.printStackTrace();
			}

			System.out.println("OTP verified - Registered Successfully");

		} else {
			System.out.println("Invalid OTP");
			RequestDispatcher rd = request.getRequestDispatcher("UserRegistration.html");
			rd.forward(request, response);
			return;

		}

	}

}
