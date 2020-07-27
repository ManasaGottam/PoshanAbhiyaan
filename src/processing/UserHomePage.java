package processing;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class UserHomePage
 */
@WebServlet("/UserHomePage")
public class UserHomePage extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserHomePage() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();

		String userMail = (String) session.getAttribute("userMail");
		int userId = (int) session.getAttribute("userId");
		int noOfChildren = 0;
		ArrayList<String> childNames = new ArrayList<>();
		ArrayList<Integer> childIds = new ArrayList<>();

		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/poshanabhiyaan", "root", "root");
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
			
			int noOfTimesPreg=0;
			ArrayList<String> startDates=new ArrayList<>();
			ArrayList<String> lastDates=new ArrayList<>();
			
			PreparedStatement pstmt2 = con.prepareStatement("select * from pregnantPerson where userid=?");
			pstmt2.setInt(1, userId);
			ResultSet rs2 = pstmt2.executeQuery();
			while (rs2.next()) {
				session.setAttribute("pregId", rs2.getInt("ppid"));
				session.setAttribute("pregName",session.getAttribute("userName"));
				startDates.add(rs2.getString("startDateOfPreg"));
				lastDates.add(rs2.getString("day261Date"));
				noOfTimesPreg++;
			}
			Collections.sort(startDates);;
			Collections.sort(lastDates);
			if(noOfTimesPreg>0) {
			System.out.println(lastDates+" : "+lastDates.get(lastDates.size()-1));
			session.setAttribute("startDateOfPreg",startDates.get(startDates.size()-1));
			session.setAttribute("lastDateOfPreg", lastDates.get(lastDates.size()-1));
			session.setAttribute("noOfTimesPreg",noOfTimesPreg);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	//	if(childNames.size()>0) {
			RequestDispatcher rd = request.getRequestDispatcher("UserHomePage.jsp");
			rd.include(request, response);
	//	}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
