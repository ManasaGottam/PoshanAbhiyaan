package mailapi;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Random;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;

//import mailPackage.SendEmail;

public class SendingMail {
	String otp;
	Properties emailProperties;
	Session mailSession;
	MimeMessage emailMessage;
	static {
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException enfe) {
			System.out.println(enfe);
		}
	}

	private Connection getConnection() throws SQLException {
		return DriverManager.getConnection("jdbc:mysql://localhost:3306/poshanabhiyaan", "root", "root");
	}

	private void closeConnection(Connection con) {
		if (con == null) {
			return;
		}
		try {
			con.close();
		} catch (SQLException sqle) {
			sqle.printStackTrace();
		}
	}/*
		 * public static void main(String args[]) throws AddressException,
		 * MessagingException {
		 * 
		 * SendEmail javaEmail = new SendEmail(); javaEmail.setMailServerProperties();
		 * javaEmail.createEmailMessage(); javaEmail.sendEmail();
		 * //javaEmail.createEmailResponse(); }
		 */

	public void setOTP(String OTP) {
		this.otp = OTP;
	}

	public String getOTP() {
		return otp;
	}

	public void setMailServerProperties() {

		String emailPort = "587";// gmail's smtp port

		emailProperties = System.getProperties();
		emailProperties.put("mail.smtp.port", emailPort);
		emailProperties.put("mail.smtp.auth", "true");
		emailProperties.put("mail.smtp.starttls.enable", "true");

	}

	public void createEmailMessage(String toEmail, String otp) throws AddressException, MessagingException {
		// Strin toEmails = { "rishika.blue27@gmail.com" };
		String emailSubject = "Poshan Abhiyaan";
		String emailBody = otp+" Thank you for choosing us. This is an email sent by poshanabhiyaan.";

		mailSession = Session.getDefaultInstance(emailProperties, null);
		emailMessage = new MimeMessage(mailSession);

		// for (int i = 0; i < toEmails.length; i++) {
		emailMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
		// }

		emailMessage.setSubject(emailSubject);
		emailMessage.setContent(emailBody, "text/html");
		// for a html email
		// emailMessage.setText(emailBody);// for a text email

	}

	public void sendEmail() throws AddressException, MessagingException {

		String emailHost = "smtp.gmail.com";
		String fromUser = "minimajorp";// just the id alone without @gmail.com
		String fromUserEmailPassword = "Kmit123$";

		Transport transport = mailSession.getTransport("smtp");

		transport.connect(emailHost, fromUser, fromUserEmailPassword);
		transport.sendMessage(emailMessage, emailMessage.getAllRecipients());
		transport.close();
		System.out.println("Email sent successfully.");
	}

	public void getMail(String mail) {
		System.out.println(mail);
	}

	public String getRandom() {
		Random rnd = new Random();
		int number = rnd.nextInt(999999);
		String otp = String.format("%06d", number);
		setOTP(otp);
		return String.format("%06d", number);
	}

	public void insert(String userName, String userPswd, String userAddress, String userMobile, String userMail, String userPinCode) {
		Connection con = null;

		try {
			
			PreparedStatement pstmt = con.prepareStatement(
					"insert into user(userName,userPswd,userAddress,userMobile,userMail,userPinCode) values(?,?,?,?,?,?);");
			pstmt.setString(1, userName);
			pstmt.setString(2, userPswd);
			pstmt.setString(3, userAddress);
			pstmt.setString(4, userMobile);
			pstmt.setString(5, userMail);
			pstmt.setString(6, userPinCode);

			int rs = pstmt.executeUpdate();
			if (rs > 0) {
				System.out.println("Registered Successfully into DB");
			} else {
				System.out.print("Error");
			}
		}

		catch (Exception e) {
			e.printStackTrace();
			closeConnection(con);
		}

	}

	public void delete(String otp) {
		Connection con = null;
		try {
			con = getConnection();
			PreparedStatement pstmt = con.prepareStatement("delete from coordinator where otp='" + otp + "';");
			int res = pstmt.executeUpdate();
			if (res != 0) {
				System.out.println("Coordinator DELETED...");
			}
		} catch (SQLException sqle) {
			System.out.println(sqle);
		} finally {
			closeConnection(con);
		}
	}

	public boolean login(String cid, String cpassword) {
		Connection con = null;
		try {
			con = getConnection();
			PreparedStatement pstmt = con
					.prepareStatement("select cpassword from coordinator where cid='" + cid + "';");
			ResultSet rs = pstmt.executeQuery();
			String pswd = "";
			while (rs.next()) {
				pswd = rs.getString("cpassword");
			}

			if (pswd.equals(cpassword)) {
				return true;
			}
		} catch (SQLException sqle) {
			System.out.println(sqle);
		} finally {
			closeConnection(con);
		}
		return false;

	}

	public String[] getDetails(String cid) {
		Connection con = null;
		String requests[] = new String[10];

		try {
			con = getConnection();
			PreparedStatement pstmt = con
					.prepareStatement("select sid,reason,duration,gpstatus from gatepass where cid='" + cid + "';");
			ResultSet rs = pstmt.executeQuery();
			String sid = "";
			String reason = "";
			String duration = "";
			String gpstatus = "";
			int index = 0;
			while (rs.next()) {
				sid = rs.getString("sid");
				reason = rs.getString("reason");
				duration = rs.getString("duration");
				gpstatus = rs.getString("gpstatus");
				requests[index++] = sid + " " + reason + " " + duration + " " + gpstatus;
				System.out.println(sid + " " + reason + " " + duration + " " + gpstatus);

			}
			// System.out.println(sid+" "+reason+" "+duration);
		} catch (SQLException sqle) {
			System.out.println(sqle);
		} finally {
			closeConnection(con);
		}
		return requests;
	}

	public void UpdateGpStatus(String sid, String cid, String status) {
		Connection con = null;
		try {
			con = getConnection();
			PreparedStatement pstmt = con.prepareStatement(
					"update gatepass set gpstatus='" + status + "' where cid='" + cid + "'and sid='" + sid + "';");

			int res = pstmt.executeUpdate();
			if (res != 0) {
				System.out.println("table updated...");
			}
		} catch (SQLException sqle) {
			System.out.println(sqle);
		} finally {
			closeConnection(con);
		}
	}

	public String getStudentmail(String sid) {
		Connection con = null;
		String semail = "";
		try {
			con = getConnection();
			PreparedStatement pstmt = con.prepareStatement("select semail from student where sid='" + sid + "';");
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				semail = rs.getString("semail");
			}
		} catch (SQLException sqle) {
			System.out.println(sqle);
		} finally {
			closeConnection(con);
		}
		return semail;
	}

	public void createEmailResponse(String toEmail, String status) throws AddressException, MessagingException {
		String emailSubject = "Response to Your gatepass Request";
		String emailBody = "This is an email sent by Your Coordinator. Your GatePass Request status is: " + status;

		mailSession = Session.getDefaultInstance(emailProperties, null);
		emailMessage = new MimeMessage(mailSession);
		emailMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
		emailMessage.setSubject(emailSubject);
		emailMessage.setContent(emailBody, "text/html");
	}
}
