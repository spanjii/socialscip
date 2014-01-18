<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="sagisoc.FusionApi"%>
<%@ page import="sagisoc.UserInfo" %>

<%
	// user signs in with his google account 
	FusionApi tables2 = new FusionApi();
	String user = request.getParameter("userid");

	try {
		// if user is not researcher redirect in Guests page		
		if (!(UserInfo.isResearcher(UserInfo.getMail()))) {
			response.sendRedirect("/welcome");
		}
		tables2.run("SELECT Mail, Name FROM " + FusionApi.REQUESTS);
	} catch (Exception e) {
		response.sendRedirect("/wrong.jsp");
	}
%>

<head>
<link rel="stylesheet" type="text/css" href="/css/researcherpanel.css" />
<link rel="stylesheet" type="text/css" href="/css/allpages.css" />
<title>SocialSkip Service - Researchers</title>
<link href="/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
</head>

<body>
<table class="header"><tr><td width="25%"></td><td><span>Researchers</span></td><td width="25%"></td></tr></table>

	
	<br/>

	<br /><br />
	<p class="pstyle" id="textshadow">Click on one of the following options</p>
		<br />
		<table>
		<tr>		
		<td><a href="/researcher.jsp?userid=<%=user%>&logout=<%=request.getParameter("logout")%>"><button class="gobuttons">Create, edit or delete your experiments</button></a></td>
		<td></td>
			
		<%
	if( UserInfo.isAdministrator()) {
	%>
			<td><a href="/experiments.jsp?userid=<%=user%>&logout=<%=request.getParameter("logout")%>"><button class="gobuttons">View experiments of all researchers</button></a></td>
			<td></td>
			<td>
			<p class="pstyle"><a href="http:/newrequests.jsp?userid=<%=user%>&logout=<%=request.getParameter("logout")%>"><button class="gobuttons">New requests:
			<%if(tables2.rowCount() == 0) { %>
			<span>
			<%} else { %>
			<span style="color:#FF0000">
			<%} %>
			
			 <%=tables2.rowCount()%></span></button></a></p></td>
	<%
	} else {
	%>
		<td><a href="/formremoveresearcher.jsp?userid=<%=user%>&logout=<%=request.getParameter("logout")%>"><button class="gobuttons">Delete from researcher</button></a></td>
		<td></td>
		<td><a href="http://code.google.com/p/socialskip/" target="_blank"><button class="gobuttons">Create your own SocialSkip Service!</button></a></td>
	<%
	}
	%>
		
		
		</tr>
		</table>
	<br/>


		<p class="pstylelink">
			<a class="buttons" href="<%=request.getParameter("logout")%>">Sign out</a>
		</p>
		


</body>