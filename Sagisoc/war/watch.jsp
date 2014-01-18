<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="sagisoc.GenerateId"%>

<head>
<link rel="stylesheet" type="text/css" href="/css/watch.css" />
<link rel="stylesheet" type="text/css" href="/css/allpages.css" />
<title>SocialSkip Service</title>
<link href="/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
<script src="/code/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js" type="text/javascript" ></script>
<script src="/code/sagisoc2.js" type="text/javascript"></script>
<script src="/code/socialskip3.js" type="text/javascript"></script>


<script>
	function getCookie(c_name) {
		var i, x, y, ARRcookies = document.cookie.split(";");
		for (i = 0; i < ARRcookies.length; i++) {
			x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
			y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
			x = x.replace(/^\s+|\s+$/g, "");
			if (x == c_name) {
				return unescape(y);
			}
		}
	}
	
	function setCookie(c_name, value, exdays) {
		var exdate = new Date();
		exdate.setDate(exdate.getDate() + exdays);
		var c_value = escape(value)
				+ ((exdays == null) ? "" : "; expires=" + exdate.toUTCString());
		document.cookie = c_name + "=" + c_value;
	}
	
	function checkCookie() {
		var testerId = getCookie("testerId");
		if (testerId != null && testerId != "") {
			$("#testerIdtext").val(testerId);
		} else {
			$.post("/cookies", function (data) {
				testerId = data;
				$("#testerIdtext").val(testerId);
				if (testerId != null && testerId != "") {
					setCookie("testerId", testerId, 100);
				}
			}, "text");
		}
	}
</script>




</head>
<% 
	int controls = Integer.parseInt(request.getParameter("Controls"));
	int jump = (controls & (0x3F << 4)) >>> 4;
	int interaction = (controls & (0xFF << 10)) >>> 10; 
	
	String videoURL = request.getParameter("VideoURL");
	String videoID = videoURL.substring(videoURL.lastIndexOf('/') + 1);
%>
<body onload="checkCookie()">

<table class="header" >
 	
 	<tr><td><span>Video Experiment</span></td></tr>
 	
 	</table>
 <div style="margin-left:auto;margin-right: auto;">
  <div id="content1">
    <div id="leftpanel">
    <div id="playercolor">
	  <input type="text" id="jump" class="hidden" value="<%= jump %>" />
	  <input type="text" id="interaction" class="hidden" value="<%= interaction %>" />
	  <input type="text" id="videourl" class="hidden" value="<%= videoID %>" />
      

      <div id="player"></div>
        <script src="/code/player.js" type="text/javascript"></script>
<div>
      
      <table id="player1">
        <tr>
         <% if ((controls & 0x01) != 0) { %>
          	<td colspan="6">
              <div id="seekbar" class="pbutton" onclick="updateSeekBar(event)">
            	<div id="seekpos"></div>
              </div>
            </td>
            </tr>
            <tr>
            <td>
          	<% if ((controls & 0x02) != 0) { %>
                <img class="pbutton" id="playbutton" src="/images/pause-button-40.png" onClick="playpause();" />
              <% } %>
            </td>
          <% } %>
          <td>
          <% if (interaction != 0) { %>
            <a href="#" id="startlink">
              <img id="playbuttonstart" src="/images/pause-button-40.png" onClick="playpausestart();" />
            </a>   
          <% } %>
          </td>
   
          <%if ((controls & 0x01) == 0) { %> 
            <td>
              <% if ((controls & 0x08) != 0) { %>
                <img class="pbutton" id="backward" src="/images/backward-button-40.png" onClick="gobackward();" />
              <% } %>
            </td>
            <td>
              <% if ((controls & 0x02) != 0) { %>
                <img class="pbutton" id="playbutton" src="/images/pause-button-40.png" onClick="playpause();" />
              <% } %>
            </td>    
            <td>
              <% if ((controls & 0x04) != 0) { %>
                <img class="pbutton" id="forward" src="/images/forward-button-40.png" onClick="goforward();" />
              <% } %>
            </td>
          <% } %>
          <td>    
          <!-- Video's timer -->
            <div id="videoInfo"> 
              <span style="font-size:14px;color: #FFFFFF;" id="videoCurrentTime">--:--</span><span style="font-size:14px;color: #FFFFFF;">/</span><span style="font-size:14px;color: #FFFFFF;" id="videoDuration">--:--</span> 
            </div>
          </td>
          <td>
          <!-- Video's countdown timer for the navigation restriction -->
   	        <input type="text" size="18" id="counter" class="hidden">
          </td>
        </tr>
        </table>      
      
      </div>
      </div>
      <br>
      
      <% if (interaction != 0) { %>
            <a href="#" id="startlink">
              <img id="start" src="/images/start-button-40.png" onClick="FirstwooYay();" />
            </a>   
      <% } %>
      </div>
  	
  	<div id="rightpanel">
  	  <div id="instructions">
      <!-- This google form contains instructions for the user -->

<% if (request.getParameter("Info") != null) { %>
        <iframe src="<%=request.getParameter("Info")%>&amp;embedded=true"
                width="595" height="550"></iframe>
<% } %>
      </div>
      <div id="ifrS" class="hidden"> 
        <!-- this Google form contains the questionnaire -->
<% if (request.getParameter("Questionarie") != null) { %>
        <iframe src="<%= request.getParameter("Questionarie") %>"
                width="595" height="600" frameborder="0" marginheight="0" marginwidth="0">ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½...</iframe>
<% } %>
        <form action="/fusion" method="post" id="transaction">
          <!-- Interactions are saved on text1 variable  --> 
            <textarea name="text1" id="text1" class="hidden"> </textarea>
            <input type="text" value="<%= request.getParameter("videoId") %>" name="videoId" class="hidden" /> 
            <input type="text" value="" name="testerId" id="testerIdtext" class="hidden"/> 
            <br><center><a href="thanks.jsp"><img src="images/finish.png" alt="Finish" onclick="temp()"></center> 
        </form> 
      </div>	 
    </div>
		<br/>
  </div>
  </div>
  <div id="instr5" style="background-color:#000000;width:562px;height:317px;position:absolute;top:102px;left:32px;z-index:1" class="hidden"></div>
   
</body>