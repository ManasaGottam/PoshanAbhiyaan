package scheduler;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.servlet.RequestDispatcher;

import mailapi.SendingMail;

import java.time.temporal.*;

public class SomeDailyJob implements Runnable {

	@Override
	public void run() {
		// TODO Auto-generated method stub
		SendingMail sm = new SendingMail();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/poshanabhiyaan?autoReconnect=true&useSSL=false", "root", "root");
			// Send alerts to child
			PreparedStatement pstmt = con.prepareStatement("select * from child;");
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				ArrayList<String> dates = new ArrayList<>();
				int cId = rs.getInt("cId");
				dates.add(rs.getString("day0"));
				dates.add(rs.getString("day42"));
				dates.add(rs.getString("day71"));
				dates.add(rs.getString("day99"));
				dates.add(rs.getString("day472"));
				dates.add(rs.getString("day1780"));
				dates.add(rs.getString("day3560"));
				dates.add(rs.getString("day4300"));

				LocalDate SystemDate = java.time.LocalDate.now();

				for (int i = 0; i < dates.size(); i++) {
					LocalDate date = LocalDate.parse(dates.get(i));
					long daysBetween = ChronoUnit.DAYS.between(SystemDate, date);
					System.out.println("Child DayBetween: " + daysBetween);

					if (daysBetween == 0 || daysBetween == 1 || daysBetween == 2) {
						PreparedStatement pstmt2 = con.prepareStatement("select * from child where cId=?;");
						pstmt2.setInt(1, cId);
						ResultSet rs2 = pstmt2.executeQuery();
						int parent = 0;
						String childName = "";
						while (rs2.next()) {
							parent = rs2.getInt("parent");
							childName = rs2.getString("cName");
						}
						PreparedStatement pstmt3 = con.prepareStatement("select * from user where userId=?;");
						pstmt3.setInt(1, parent);
						ResultSet rs3 = pstmt3.executeQuery();
						String userMail = "";
						while (rs3.next()) {
							userMail = rs3.getString("userMail");
						}
						String daysInMail = "";
						if (daysBetween == 0) {
							daysInMail = "today i.e on " + date;
						} else if (daysBetween == 1) {
							daysInMail = "tomorrow i.e on " + date;
						} else if (daysBetween == 2) {
							daysInMail = "on " + date;
						}
						try {
							System.out.println("user: " + userMail);
							sm.setMailServerProperties();
							sm.createEmailMessage(userMail, "Your child " + childName + " needs to take vaccination "
									+ daysInMail + ". Please visit our website to know the details.");
							sm.sendEmail();
						} catch (AddressException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (MessagingException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}

					}
				}
			}

			// Sending alerts to pregnant
			PreparedStatement pstmtPreg = con.prepareStatement("select * from pregnantPerson;");
			ResultSet pregRs = pstmtPreg.executeQuery();
			while (pregRs.next()) {
				ArrayList<String> dates = new ArrayList<>();
				int pregId = pregRs.getInt("ppid");
				int userId = pregRs.getInt("userid");
				dates.add(pregRs.getString("day31Date"));
				dates.add(pregRs.getString("day61Date"));
				dates.add(pregRs.getString("day91Date"));
				dates.add(pregRs.getString("day121Date"));
				dates.add(pregRs.getString("day151Date"));
				dates.add(pregRs.getString("day181Date"));
				dates.add(pregRs.getString("day196Date"));
				dates.add(pregRs.getString("day211Date"));
				dates.add(pregRs.getString("day226Date"));
				dates.add(pregRs.getString("day241Date"));
				dates.add(pregRs.getString("day248Date"));
				dates.add(pregRs.getString("day255Date"));
				dates.add(pregRs.getString("day261Date"));

				LocalDate SystemDate = java.time.LocalDate.now();
				LocalDate lastDate = LocalDate.parse(dates.get(dates.size()-1));
				long lastDateToToday = ChronoUnit.DAYS.between(SystemDate, lastDate);
				if(lastDateToToday<0) {
					PreparedStatement pstmt4 = con.prepareStatement("UPDATE pregnantPerson SET day261Status = 'true' WHERE ppid=?;");
					pstmt4.setInt(1,pregId);
					int rs4 = pstmt4.executeUpdate();
					if(rs4>0) {
						System.out.println("preg finished : userId: "+userId);
					}
				}
				for (int i = 0; i < dates.size(); i++) {
					LocalDate date = LocalDate.parse(dates.get(i));
					long daysBetween = ChronoUnit.DAYS.between(SystemDate, date);
					System.out.println("Preg DayBetween: " + daysBetween);

					if (daysBetween == 0 || daysBetween == 1 || daysBetween == 2) {
						
						PreparedStatement pstmt3 = con.prepareStatement("select * from user where userId=?;");
						pstmt3.setInt(1, userId);
						ResultSet rs3 = pstmt3.executeQuery();
						String userMail = "";
						String userName = "";
						while (rs3.next()) {
							userMail = rs3.getString("userMail");
							userName = rs3.getString("userName");
						}
						String daysInMail = "";
						if (daysBetween == 0) {
							daysInMail = "today i.e on " + date;
						} else if (daysBetween == 1) {
							daysInMail = "tomorrow i.e on " + date;
						} else if (daysBetween == 2) {
							daysInMail = "on " + date;
						}
						try {
							System.out.println("user: " + userMail);
							sm.setMailServerProperties();
							sm.createEmailMessage(userMail, "Dear "+userName+", you need to visit the hospital for certain tests and vaccinations "
									+ daysInMail + ". Please visit our website to know the details.");
							sm.sendEmail();
						} catch (AddressException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (MessagingException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}

					}
				}
				
				
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}