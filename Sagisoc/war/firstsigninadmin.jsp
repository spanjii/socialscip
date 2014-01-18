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
		// if user is researcher redirect in Researchers page		
		if(UserInfo.isResearcher(UserInfo.getMail())) {
			response.sendRedirect("/welcome");
		}
	} catch(Exception e) {
		response.sendRedirect("/wrong.jsp");
	}
	
	// if user is not administrator redirect in home page		
	if(!(UserInfo.isAdministrator())) {
		response.sendRedirect("/welcome");
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
</head>

<body>
	<table class="header" >
 	
 	<tr><td><span>Administrator</span></td></tr>
 	
 	</table>
 	
 	
	<br /><br />

	<p class="pstyle">Hello, administrator! <br/>
	Please fill the "Full name" field to continue.</p>
	<br />
	<div class="form1">
	<form action="first_signin_admin" method="post">
		<table>
			<tr>
				<td>E-mail:</td>
				<td><input type="text" id="mail" class="infotext"
					readonly="readonly" name="mail"
					value="<%=UserInfo.getMail()%>"></td>
			</tr>
			<tr>
				<td>Full name:</td>
				<td><input type="text" id="name" class="infotext" name="name"></td>
			</tr>
		</table>
		<input class="confirm" type="submit" id="submit" value="Continue">
	</form>
	</div>
	<%
		if (request.getParameter("hasname") != null) {
	%>

	<p class="incorname">
		<img src="/images/warning.gif" /> Incorrectly name. Please give a
		full name.
	</p>


	<%
		}
	%>

	<div id="pstyle">
	<br/>
		<p>
			<a class="buttons" href="<%=request.getParameter("logout")%>">Sign out</a>
		</p>
		<p></p>
	</div>

</body>
</html>
