<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="sagisoc.FusionApi"%>
<%@ page import="sagisoc.UserInfo"%>
<%@ page import="sagisoc.NewResearcherServlet"%>
<%
	// user signs in with his google account 
	FusionApi tables = new FusionApi();
	FusionApi tables1 = new FusionApi();
	String user = request.getParameter("userid");
	boolean doRequest = false;
	
	try {
		tables.run("SELECT Name, Mail FROM " + FusionApi.RESEARCHERS + " WHERE ROWID='" + user + "'");
		tables1.run("SELECT Mail FROM " + FusionApi.REQUESTS);
		
		// if user is not researcher redirect in Guests page		
		if(!(UserInfo.isResearcher(UserInfo.getMail()))) {
			response.sendRedirect("/welcome");
		}
	} catch(Exception e) {
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
<script src="/code/formnewresearcher.js" type="text/javascript"></script>
</head>

<body>
	<table class="header">

		<tr>
			<td><span>Researchers</span></td>
		</tr>

	</table>


	<br />
	<br />
	<%
		Iterator<String[]> rows = tables.getRowsIterator();
		String[] rowValues = rows.next();

		for (Iterator<String[]> rows1 = tables1.getRowsIterator(); rows1
				.hasNext();) {
			String[] rowValues1 = rows1.next();
			if (rowValues1[0].equals(UserInfo.getMail())) {
				doRequest = true;
			}
		}

		if (doRequest == false) {
	%>

	<p class="pstyle">
		If you want to delete from researcher,<br />please click on "Delete
		me!" button.
	</p>
	<br />
	<div class="form1">
		<form action="/remove_researcher" method="post">
			<table style="margin: auto;">
				<tr>
					<td style="text-align:left;text-shadow:1px 1px 0px #00305c;">Name:</td>
					<td><input type="text" id="name" class="infotext"
						readonly="readonly" name="name" value="<%=rowValues[0]%>"></td>
				</tr>
				<tr>
					<td style="text-align:left;text-shadow:1px 1px 0px #00305c;">E-mail:</td>
					<td><input type="text" id="mail" class="infotext"
						readonly="readonly" name="mail" value="<%=rowValues[1]%>"></td>
				</tr>
				<tr>
					<td><input type="hidden" readonly="readonly" name="userid"
						value="<%=user%>"></td>
				</tr>
			</table>
			<input class="confirm" type="submit" id="submit" value="Delete me!">
		</form>
	</div>
	<%
		} else {
			if (request.getParameter("doreq") != null) {
	%>

			<p class="pstyle">
			Your deletion request has been sent successfully!<br /> <br />The administrator of SocialSkip Service will confirm your deletion request as soon as possible.
			</p>
			<br />


	<%
			} else {
	%>
			<p class="pstyle">You have already requested to delete from researcher!</p>
			<br />
	<%
			}
		}
	%>

	<div id="pstyle">
		<br />
		<p>
			<a class="buttons" href="/welcome">Go back</a> <a class="buttons"
				href="<%=request.getParameter("logout")%>">Sign out</a>
		</p>
		<p></p>
	</div>

</body>
</html>
