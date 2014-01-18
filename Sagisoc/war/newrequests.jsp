<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="sagisoc.FusionApi" %>
<%@ page import="sagisoc.UserInfo" %>

<%
	// user signs in with his google account 
	FusionApi tables = new FusionApi();
	FusionApi tables2 = new FusionApi();
	String user = request.getParameter("userid");
	
	try {
		// Look for researcher videos
		tables.run("SELECT Mail, Name, ROWID FROM " + FusionApi.REQUESTS);
	
		// if user is not admin redirect in your home page		
		if(!(UserInfo.isAdministrator())) {
			response.sendRedirect("/welcome"); 
		}
	} catch(Exception e) {
		response.sendRedirect("/wrong.jsp");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="/css/allpages.css" />
	<link rel="stylesheet" type="text/css" href="/css/newrequest.css" />
	<title>SocialSkip Service - Requests</title>
	<link href="/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
</head>

<body>
		<table class="header"><tr><td>Researchers</td></tr></table>

			<br/>
			Number of requests: <span id="noexp"><%=tables.rowCount()%></span>
			<br/><br/>

<% if(tables.rowCount() == 0) { %>
	There are no requests available at this time
<%} else {
%>


	<form action="/newrequest" method="post">
	<p><b>Add Researcher</b></p>
		<table>
		<%
		for (Iterator<String[]> rows = tables.getRowsIterator(); rows.hasNext();) {
						String[] rowValues = rows.next();
						
						if(!(UserInfo.isResearcher(rowValues[0]))) {
		%>
			<tr>
				<td>E-mail:</td>
				<td><input type="text" id="mail" class="infotext" readonly="readonly" name="mail" value="<%=rowValues[0]%>"></td>
				<td id="tdwidth"></td>
				<td>Name:</td>
				<td><input type="text" id="name" class="infotext" readonly="readonly" name="name" value="<%=rowValues[1]%>"></td>
				<td><input type="hidden" name="rowid" value="<%=rowValues[2]%>"></td>
				<td><input type="submit" name="action" value="Accept"></td>
				<td><input type="submit" name="action" value="Delete"></td>
			</tr>
		<%
						}
		} 
		%>
		</table>
		<p><b>Remove Researcher</b></p>
		<table>
		<%
		for (Iterator<String[]> rows = tables.getRowsIterator(); rows.hasNext();) {
						String[] rowValues = rows.next();
						if(UserInfo.isResearcher(rowValues[0])) {
		%>
			<tr>
				<td>E-mail:</td>
				<td><input type="text" class="infotext" readonly="readonly" name="mail" value="<%=rowValues[0]%>"></td>
				<td id="tdwidth"></td>
				<td>Name:</td>
				<td><input type="text" class="infotext" readonly="readonly" name="name" value="<%=rowValues[1]%>"></td>
				<td><input type="hidden" name="rowid" value="<%=rowValues[2]%>"></td>
				<td><input type="submit" name="action" value="Remove"></td>
				<td><input type="submit" name="action" value="Cancel"></td>
			</tr>
		<%
						}
		}
		%>
		</table>
	</form>
<%} %>


	<br/><br/>
	<p>
		<a class="buttons" href="/welcome">Go back</a>
		<a class="buttons" href="<%=request.getParameter("logout")%>">Sign out</a>
	</p>
	<p></p>
	
</body>
</html>
