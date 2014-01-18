<%@page import="java.net.SocketTimeoutException"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="sagisoc.FusionApi"%>
<%@ page import="sagisoc.UserInfo" %>

<%
	//if user is not researcher redirect in Guests page			
	if(!(UserInfo.isAdministrator())) {
		response.sendRedirect("/welcome"); 
	}

	// user signs in with his google account 
	FusionApi tables = new FusionApi();
	FusionApi tables1 = new FusionApi();

	// Look for researcher videos
	try {
	tables.run("SELECT ROWID, VideoURL, VideoDescr, ResearcherId FROM " + FusionApi.EXPERIMENTS);
	tables1.run("SELECT ROWID, Name FROM " + FusionApi.RESEARCHERS);
	} catch(SocketTimeoutException e) {
		response.sendRedirect("/wrong.jsp");
	} catch(RuntimeException e) {
		response.sendRedirect("/wrong.jsp");
	} catch(Exception e) {
		response.sendRedirect("/wrong.jsp");
	}
%>

<head>
<link rel="stylesheet" type="text/css" href="/css/allpages.css" />
<link rel="stylesheet" type="text/css" href="/css/experiments.css" />
<title>SocialSkip Service - Experiments</title>
<link href="/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
</head>

<body>

	<table class="header"><tr><td width="25%"></td><td>Experiments</td><td width="25%"></td></tr></table>

	<div>
	<br/>
		<p class="pstyle">In this list there are all experiments of all researchers.</p>
		<br/>
		<form action="/welcome" method="get">
		  <table border="1" class="videolist">
			<%
			
				for (Iterator<String[]> rows = tables.getRowsIterator(); rows.hasNext();) {
					String[] rowValues = rows.next();
					
					for (Iterator<String[]> rows1 = tables1.getRowsIterator(); rows1.hasNext();) {
						String[] rowValues1 = rows1.next();
						
						if( rowValues1[0].equals(rowValues[3]) ) {
						
			%>
				<tr>
			      	<td class="videolist"><input type="radio" name="videoId" value="<%=rowValues[0]%>">
					<input value="<%=rowValues1[1]%>" class="infotext" readonly="readonly" type="text">
					<input value="<%=rowValues[2]%>" class="infotext" readonly="readonly" type="text"></td>
				</tr>

					
			<%				
						}
					}
				}
			%>
			
			<tr><td class="videolist"><input type="submit" value="Go to video"></td></tr>
		</table>
		
		</form>


	</div>

	<div >
		<br/>
		<p>
			<a class="buttons" href="/welcome">Go back</a>
			<a class="buttons" href="<%=request.getParameter("logout")%>">Sign out</a>
		</p>
	</div>
<br/>
</body>