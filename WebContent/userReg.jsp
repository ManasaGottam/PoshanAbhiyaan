<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Poshan Abhiyaan</title>
<script language="Javascript">
	function validateEmail(x) {
		var ret = false;
		var error = "Please enter a valid e-mail address ";
		if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(x)) {
			error = " ";
			ret = true;
		}
		document.getElementById("mailValidation").innerHTML = error;
		console.log(error);
		return ret;
	}

	function validatePinCode(pincode) {

		var len = parseInt(pincode.length);
		var ret = false;
		var error = "Please enter a valid PinCode ";
		if (len == 6 && isNaN(pincode) == false) {
			error = " ";
			ret = true;
		}
		document.getElementById("pinCodeValidation").innerHTML = error;
		return ret;
	}

	function validatePassword(str) {
		var ret = false;
		var res = "Password Not valid( Should have 1 lowercase, 1 Uppercase, 1 special character,1 number, Min 8 characters";
		if (str.match(/[a-z]/g) && str.match(/[A-Z]/g) && str.match(/[0-9]/g)
				&& str.match(/[^a-zA-Z\d]/g) && str.length >= 8) {
			res = " ";
			ret = true;
		}
		document.getElementById("pswdValidation").innerHTML = res;
		return ret;
	}

	function validatePasswords(pswd1, pswd2) {
		if (pswd1 != pswd2) {
			alert("Passwords are not matching");
		}
	}
	function validateForm() {
		if (!validatePassword(document.getElementById("userPswd").value)
				|| !validateEmail(document.getElementById('userMail').value)
				|| !validatePinCode(document.getElementById('userPinCode').value)) {
			alert("Please Enter Valid Details");
		}
	}

	function yesnoCheck() {
		if (document.getElementById('yesCheck').checked) {
			document.getElementById('ifYes').style.display = 'block';
			document.getElementById('ifNo').style.display = 'none';
		} else if (document.getElementById('noCheck').checked) {
			document.getElementById('ifNo').style.display = 'block';
			document.getElementById('ifYes').style.display = 'none';
		}
	}
	function giveChildren() {
		var n = document.getElementById("noofchildren").value;
	/* /<select>
  <option value="volvo">Volvo</option>
  <option value="saab">Saab</option>
  <option value="mercedes">Mercedes</option>
  <option value="audi">Audi</option>
</select> */
		console.log("n: " + n);
		var res = "<br/>";
		for (var i = 0; i < n; i++) {
			res = res + "Name:<input type='text' id='cName"+(i+1)+"' name='cName" + (i + 1)
					+ "' required>&nbspGender :<select id='cGender"+ (i+1) +"' name='cGender"+ (i + 1) + "' required><option value='male'>Male</option><option value='female'>Female</option><option value='other'>Other</option></select>&nbspDate of Birth :<input type='Date' id='cDob"+ (i+1) +"' name='cDob"
					+ (i + 1) + "' required><br/><br/>"
		}
		console.log("res: " + res);
		document.getElementById('childInfo').innerHTML = res;
	}
	function pregnantCheck() {
		var name=document.getElementById("cName1").value;
		
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
<h2>Registration Page</h2>
	<form action="UserRegistration" method="get">
		<table>
			<tr>
				<td>Name:</td>
				<td><input type="text" name="userName" required></td>
			</tr>
			<tr>
				<td>Mail ID:</td>
				<td><input type="text" name="userMail" id="userMail"
					onkeyup="validateEmail(document.getElementById('userMail').value)"
					required> &nbsp;<span
					style="color: red; font-size: smaller" id="mailValidation"></span>
				</td>
			</tr>
			<tr>
				<td>Phone Number:</td>
				<td><input type="text" name="userPhone" required></td>
			</tr>
			<tr>
				<td>Address:</td>
				<td><textarea type="text" name="userAddress" placeholder="Enter Address" style="height:60px;width:200px" required></textarea></td>
			</tr>
			<tr>
				<td>PinCode:</td>
				<td><input type="text" name="userPinCode" placeholder="Enter Pin Code" id="userPinCode" onkeyup="validatePinCode(document.getElementById('userPinCode').value)" required></label>
                &nbsp;<span style="color:red;font-size:smaller" id="pinCodeValidation"></span> <br></td>
			</tr>
			<tr>
				<td>Set Password:</td>
				<td><input type="password" name="userPswd"
					placeholder="Enter Password" id="userPswd"
					onkeyup="validatePassword(document.getElementById('userPswd').value)"
					required> &nbsp;<span
					style="color: red; font-size: smaller" id="pswdValidation"></span>
					<br></td>
			</tr>
			<tr>
				<td>Confirm Password:</td>
				<td><input type="password" name="userPswd"
					placeholder="Re-Enter Password" id="userPswd2" required><br>
				</td>
			</tr>
			<tr>
				<td><br /><br />Do you have children?:</td>
				<td>Yes:<input type="radio" name="children" value="yes"
					id="yesCheck" onclick="javascript:yesnoCheck();" required>
					<div id="ifYes" style="display: none">
						No.of Children: <input type="text" name="noofchildren"
							id="noofchildren"
							placeholder="maximum 3 children are only allowed"
							onkeyup="javascript:giveChildren();">
						<div id="childInfo">
						
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>No:<input type="radio" name="children" value="no"
					id="noCheck" onclick="javascript:yesnoCheck();" required>
					<div id="ifNo" style="display: none"></div>
				</td>
			</tr>
			<tr>
				<td><br /><br />Are you Pregnant?:</td>
				<td>Yes:<input type="radio" name="pregnant" value="yes"
					id="yesPregCheck" onclick="javascript:pregnantCheck();" required>
					<div id="ifYesPreg" style="display: none">
						Start Date of Pregnancy: <input type="date" name="pregnancyDate"
							id="pregnancyDate">
					</div>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>No:<input type="radio" name="pregnant" value="no"
					id="noPregCheck" onclick="javascript:pregnantCheck(); required">
					<div id="ifNoPreg" style="display: none"></div>
				</td>
			</tr>
			<tr>
				<td></td>
				<td><br /> <input
					style="color: blanchedalmond; font-size: large; height: 40px; background-color: #0099cc; align-content: center"
					type="submit" name="submit" value="Register"
					onmouseover="validatePasswords(document.getElementById('userPswd').value, document.getElementById('userPswd2').value),validateForm()"><br>
					<br></td>
			</tr>
		</table>
	</form>

</body>
</html>