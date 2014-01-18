<!DOCTYPE html>
  <%	
	if(request.getParameter("login") == null) {
		response.sendRedirect("/welcome");
	}
  %>
<head>
<link rel="stylesheet" type="text/css" href="/css/login.css" />
<link rel="stylesheet" type="text/css" href="/css/allpages.css" />
<script src="/code/jquery-1.6.4.min.js" type="text/javascript"></script>
<title>SocialSkip Service</title>
<link href="/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />

</head>


<body>
 	<table class="header"> <tr><td style="font-size:78px;"><span style="color:#FFFFFF;">SocialSkip</span> <span style="color:#2981d9;">Service</span></td><td style="width:45%;"><img src="/images/informatics.png" /></td></tr></table>
 	
  	<br>
	
    
    <br/><br/> 
		<!-- This is the part where the user can sign in -->   
		<table style="margin: auto;"><tr>
    	<td><a href="<%= request.getParameter("login") %>" class="buttons"> Sign in as researcher</a></td>
    	<td width="20px"></td>
    	<td><a href="/guests.jsp" class="buttons"> Continue as guest </a></td>
    	</tr></table>
    

</body>