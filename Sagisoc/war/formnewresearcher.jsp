<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="sagisoc.FusionApi"%>
<%@ page import="sagisoc.UserInfo"%>
<%@ page import="sagisoc.NewResearcherServlet"%>

<%
	// user signs in with his google account 
	FusionApi tables = new FusionApi();
	FusionApi tables1 = new FusionApi();
	boolean doRequest = false;

	try {
		
		tables.run("SELECT Mail FROM " + FusionApi.REQUESTS); // newresearchers
		
		// if user is researcher redirect in Researchers page		
		if(UserInfo.isResearcher(UserInfo.getMail())) {
			response.sendRedirect("/welcome");
		}
		
	}
	catch ( Exception e ) {
		response.sendRedirect("/wrong.jsp");
	}	
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="/css/formnewresearcher.css" />
<link rel="stylesheet" type="text/css" href="/css/allpages.css" />
<title>SocialSkip Service</title>
<link href="/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
<script src="https://www.google.com/jsapi" type="text/javascript"></script>
<script src="/code/jquery-1.9.1.min.js" type="text/javascript"></script>

<script type="text/javascript">

var testresults = false;
function checkemail(){
	$('p#incormail').attr("class", "hidden");
	var str=document.validation.mail.value;
	var filter=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;

	String.prototype.endsWith = function(str) {
		return (this.match(str+"$")==str);
	};

	if (filter.test(str)) {
		if(str.endsWith("@gmail.com")) {
			testresults=true;
		}
		else 
			$('p#incormail').removeAttr('class');
	}
	else {
		$('p#incormail').removeAttr('class');
		testresults=false;
	}
	
	return (testresults);
}

function checkname() {
	$('p#incorname').attr("class", "hidden");
	var str=document.validation.name.value;
	if (str.length < 4 ) {
		$('p#incorname').removeAttr('class');
		return false;
	}
	return true;
}

</script>

<script>
function checkbae() {
	$('p#incorname').attr("class", "hidden");
	$('p#incormail').attr("class", "hidden");
	if (document.layers||document.getElementById||document.all) {
		return (checkemail() && checkname());
	}
	else {
		return true;
	}
	
}
</script>
</head>

<body>
	<table class="header" >
 	
 	<tr><td>Guests page</td></tr>
 	
 	</table>
 	
 	
	<br /><br />
	<%
		for (Iterator<String[]> rows = tables.getRowsIterator(); rows
				.hasNext();) {
			String[] rowValues = rows.next();

			if (rowValues[0].equals(UserInfo.getMail())) {
				doRequest = true;
			}
		}

		if (doRequest == false && request.getParameter("doreq") == null && request.getParameter("alreadyRequested") == null) {
	%>

	<p class="pstyle" id="textshadow">If you want to become a researcher, please fill
		out the form.</p>
	<br />
	<div class="form1">
	<form name="validation" action="add_researcher" method="post" onSubmit="return checkbae()">
		<table style="margin: auto;">
			<tr>
				<td style=" text-align:left;"><span style="text-shadow:1px 1px 0px #00305c;">E-mail:</span></td>
				<td><input type="text" id="mail" class="infotext" name="mail"></td>
			</tr>
			<tr>
				<td style=" text-align:left;"><span style="text-shadow:1px 1px 0px #00305c; ">Full name:</span></td>
				<td><input type="text" id="name" class="infotext" name="name"></td>
			</tr>
		</table>
		<center><input class="confirm" type="submit" id="submit" value="Confirm" ></center>
	</form>
	</div>
	

	<p id="incorname" class="hidden">
		<img src="/images/warning.gif" /> Incorrectly name. Please give your full name.
	</p>
	
	<p id="incormail" class="hidden">
		<img src="/images/warning.gif" /> Incorrectly e-mail. Please give your g-mail.
	</p>


	<%
		}
		else {
	%>

	<p class="pstyle">
		Your request has been sent successfully!<br />
		<br />The administrator of SocialSkip Service will confirm your
		request as soon as possible.
	</p>
	<br />


	<%
		}
	%>

	<div id="pstyle">
	<br/>
		<p>
			<a class="buttons" href="/welcome">Go back</a>
			<a class="buttons" href="<%=request.getParameter("logout")%>">Sign out</a>
		</p>
		<p></p>
	</div>

</body>
</html>
