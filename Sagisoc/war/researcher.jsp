<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="sagisoc.FusionApi" %>
<%@ page import="sagisoc.UserInfo" %>

<% // user signs in with his google account 
    FusionApi tables = new FusionApi();
	String user = request.getParameter("userid");
		
	// Look for researcher videos
	try {
		tables.run("SELECT ROWID, VideoURL, VideoDescr, Controls, Questionarie, Info FROM " + FusionApi.EXPERIMENTS + " WHERE ResearcherId='" + user + "'");
	
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
	<link rel="stylesheet" type="text/css" href="/css/researcher.css" />
	<link rel="stylesheet" type="text/css" href="/css/allpages.css" />
	<title>SocialSkip Service - Researchers</title>
	<link href="/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<script src="/code/jquery-1.6.4.min.js" type="text/javascript"></script>
	<script src="/code/jquery.tools.min.js" type="text/javascript"></script>	
	<script src="https://www.google.com/jsapi" type="text/javascript"></script>
	<script src="/code/researcher2.js?n=1" type="text/javascript"></script>
	
	 <script src="/code/jquery-ui-1.10.2.custom.min.js" type="text/javascript"></script>
	 <link rel="stylesheet" href="/css/jquery-ui-1.10.2.custom.min.css" />
	
	 <script>
	 function closeDialog() {
		 $("#dialog").dialog('close');
		 $("div#page").removeAttr("class");
	 }
	 </script>

	 <script>
		$(function() {
		//$( "#accordion" ).accordion();
		$("#accordion").accordion({ heightStyle: "content" });
		});
	</script>
	
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
    <script type="text/javascript">
      var count = 0;
      var playerObjects = {};
      
      function onYouTubePlayerReady(playerId) {
        playerObjects[playerId] = document.getElementById(playerId);
      }
      
    </script>
    
   
    
</head>

<body >
	
	<table class="header"><tr><td><span>Researchers</span></td></tr></table>
    
	<div id="page">
	<br>
	
	<div style="margin:2%;">
	<div id="accordion">	
				<% 
				int i = 0; 	
				for (Iterator<String[]> rows = tables.getRowsIterator(); rows.hasNext(); ) { 
						String[] rowValues = rows.next();
				%>
				<h3 id="h<%=rowValues[0]%>"><%= rowValues[2] %></h3>
				<div id="h<%=rowValues[0]%>">
				<script type="text/javascript">
      				$(document).ready(function () {
    	 				countForCharts++;
    				});
				</script>
				
				<table id="exptable">
				
				<tr id="<%=rowValues[0]%>">
				<td class="hidden"><%= rowValues[2] %></td>
					<td class="hidden"><%= rowValues[0] %></td>
					<td class="hidden"><%= rowValues[1] %></td>
					<td class="hidden"><%= rowValues[3] %></td>
					<td class="hidden"><%= rowValues[4] %></td>
					<td class="hidden"><%= rowValues[5] %></td>
					<td class="hidden"><%= i %>"</td>
				
					<td>
					<br>
					<div id="ytapiplayer">
        You need Flash player 8+ and JavaScript enabled to view this video.
      </div>

      <script type="text/javascript">
        var params = { allowScriptAccess: "always" };
        // The allowScriptAccess parameter in the code is needed to allow the player SWF to call functions
        // on the containing HTML page, since the player is hosted on a different domain from the HTML page
        var atts = { id: "myytplayer" };
        // The only attribute we're passing in is the id of the embed object ï¿½ in this case, myytplayer.
        // This id is what we'll use to get a reference to the player using getElementById()     
        
        count++;
        var playerId = "player" + count;

        swfobject.embedSWF(
            "<%=rowValues[1]%>?enablejsapi=1&version=3&playerapiid=" + playerId,
            "ytapiplayer",
            "450",
            "350",
            "9.0.0",
            null,
            null,
            params,
            atts
        );	
      </script>
      </td>
      
      <td style="width:30px;"></td>     
	  <td>
					
					
					<td><input style="width:180px;" type="button" value="Edit" class="edit" />
					<br><input style="width:180px;" type="button" value="Charts" class="charts" />
					<br><input style="width:180px;" type="button" value="Get URL" class="geturl" />
					<br><input style="width:180px;" type="button" value="Delete" class="delete" />
					<br><input style="width:180px;" type="button" value="Download data" class="data" />
					<!-- <br><input style="width:180px;" type="button" value="Chart" id="chart<%= i %>" class="chart" /> -->
					
	</td>
		
				
				</tr>
		</table>
		
		</div>
		
		<%
			i+=1;
		} %>
		
			
		
	</div>
	
	<br><br>
	<input type="button" class="newexp" value="Create new experinment" onclick="insert();" />
	
	
	</div>
	
	
	<div id="pstyle">
	<br/>
	<p>
		<a class="buttons" href="/welcome">Go back</a>
		<a class="buttons" href="<%=request.getParameter("logout")%>">Sign out</a>
	</p>
	<p></p>
	</div>
	
	</div>
	
	<div class="form_overlay" id="videoinfo">
  		<form id="createupdate" action="/researcher_videos" method="post">
  			<input type="text" class="hidden" name="action" id="action" />
  			<input type="text" class="hidden" name="expid" id="expid" />
  			<input type="text" class="hidden" name="researcher" value="<%=  request.getParameter("userid") %>" />
  			<input type="text" class="hidden" name="controls" id="controls" />
			<table>
	  			<tr>
	    			<td>Description: </td>
	    			<td><input type="text" id="descr" class="infotext" name="descr" /></td><td><a title="Help" href="/instructions.html#description" target="_blank"><img src="/images/help.png" alt="Help"></a></td>
	  			</tr>
	  			<tr>
	  				<td>VideoURL: </td>
	  	 			<td><input type="text" id="videourl" class="infotext" name="videourl" /></td><td><a title="Help" href="/instructions.html#video" target="_blank"><img src="/images/help.png" alt="Help"></a></td>
	  			</tr>
	  			<tr>
	  	 			<td>
	  	    			Buttons: <input type="radio" name="controltype" value="buttons" checked="checked"/><br />
	  	   				Slider: <input type="radio" name="controltype" value="slide" />
	    			</td>
	    			<td>
	    				Play/Pause: <input type="checkbox" id="play" name="play" checked="checked" /><br />
	     				<div id="buttons">
	       					Forward: <input type="checkbox" id="forward" name="forward" /><br />
	       					Backward: <input type="checkbox" id="backward" name="backward" /><br />
	       					Jump: <input type="text" id="jump" name="jump" /> sec<br />
	     				</div>
	     				Interaction: <input type="text" id="interaction" name="interaction" /> min
	    			</td><td><a title="Help" href="/instructions.html#buttons" target="_blank"><img src="/images/help.png" alt="Help"></a></td>
	  			</tr>
	  			<tr>
	    			<td>Questionnaire: </td>
	    			<td><input type="text" id="question" class="infotext" name="question" /></td><td><a title="Help" href="/instructions.html#question" target="_blank"><img src="/images/help.png" alt="Help"></a></td>
	  			</tr>
	  			<tr>
	   				<td>Information: </td>
	    			<td><input type="text" id="info" class="infotext" name="info" /></td><td><a title="Help" href="/instructions.html#info" target="_blank"><img src="/images/help.png" alt="Help"></a></td>
	  			</tr>
			</table>
			<center><input type="submit" id="submit" value="TEST" /></center>
 		 </form>
	</div>
	
	
	<div title="Video Experiment url" id="urlvideoid" class="hidden">
		<br/>
		<input type="text" id="geturl" class="infotext1" name="geturl" />
	</div>
	
	<div title="Charts" id="viewcharts" class="charts_overlay">
					<br/>
					<form>
						<table>
						<tr><td><input type="text" class="hidden" name="charts" id="charts" /></td>
						<td><input type="text" class="hidden" name="controls" id="controls" /></td>
						<td><input class="hidden" id="count" type="text"/></td></tr>
					    <tr>
						<td><input type="button" id="chbuttons" value="Chart 1" class="view" /></td>
						<td><input type="button" id="chbuttons" value="Chart 2" class="viewreplay" /></td>
						<td><input type="button" id="chbuttons" value="Chart 3" class="final1" /></td>
						</tr>
						</table>
					</form>
					
	</div>
	
	<div class="chart_overlay" id="chart">
		<div id="visualization"></div>
	</div>
	
	<div class="chart_overlay" id="replaychart">
		<div id="chart_div"></div>
	</div>
	
	<div class="chart_overlay" id="finalchart">
		<div id="chart_div"></div>
	</div>
	
	
	
	<div id="dialog" title="Delete experiment" class="hidden">
		<p>Are you sure you want to delete this experiment?</p>
		<form action="/researcher_videos" method="post" id="deleteform">
		<input type="text" class="hidden" name="expid" id="expiddel" />
		<input type="text" class="hidden" name="action" value="3" />
		<input type="submit" value="Yes"/> <input type="button" value="No" class="canceldelete" onclick="closeDialog();"/>
		</form>
	</div>
<br/>



</body>
</html>