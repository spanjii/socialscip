//How the interactions are saved into the base
//Gobackward->gb:
//GoForward->gf:
//play->p:
//pause->a:

//Once the player is ready, it will call this function 

function onPlayerReady(event) 
{
	event.target.playVideo(); // Starts the video
	setInterval(updatePlayerInfo, 200); //Every 200ms searches for updates on player's information
	updatePlayerInfo(); 
}

//This function counts down 5 minutes,which is the time restriction for user navigation
function closeW() 
{ 	
	$(".pbutton").hide("slow"); // Hide the players buttons
	player.stopVideo(); // This command stops video's playing state
	player.clearVideo();
	$("#instr5").removeAttr("class");
	alert(duration + " minutes have passed"); // This is the alert message for the user
	window.close();  
}

function FirstwooYay()
{
//This function fires if the user presses the link to enable the buttons
//	setTimeout("ytplayer.pauseVideo();",100); //This goes to 100ms of video and pauses it
		player.seekTo(0, true); // Go to the beginning of the video
		player.playVideo();
		$(".pbutton").show(500); 
		$("#ifrS").show();
		$("#counter").show("slow"); // The counter also
		display();
		$("#startlink").hide("slow"); // The previous link is not available anymore
		$("#start").hide("slow"); 
		$("#playbuttonstart").hide("slow");
		$("#instructions").hide(); // Hide the instructions
		
		setInterval(function(){ 
			$("form#transaction").trigger("submit");    
		}, 15000);
		
// The alert message, which informs about the end of the available time, will pop up
		window.setTimeout("closeW()", duration * 60 * 1000);
}


function playpausestart() //Function for the Play/Pause button 
{ 
	if (player.getPlayerState() == YT.PlayerState.PAUSED) { //an brisketai se katastash Pause
		player.unMute(); // Video has volume
		player.playVideo(); // Video starts
		var time= player.getCurrentTime(); // Collects the current second for the database
		var today = new Date(); // Get the current time
		//Matches the time with the button that has been used and save them on text1
		$("#playbuttonstart").attr("src", "/images/pause-button-40.png");
	}
	else if (player.getPlayerState() == YT.PlayerState.PLAYING) {
		player.pauseVideo(); // Pause video
		var time= player.getCurrentTime(); // Collects the current second for the database
		var today = new Date(); // Get the current time
		// Matches the time with the button that has been used
		$("#playbuttonstart").attr("src", "/images/play-button-40.png");
	}
    $("#playbuttonstart").button('refresh');
}


function playpause() //Function for the Play/Pause button 
{ 
	if (player.getPlayerState() == YT.PlayerState.PAUSED) { //an brisketai se katastash Pause
		player.unMute(); // Video has volume
		player.playVideo(); // Video starts
		var time= player.getCurrentTime(); // Collects the current second for the database
		var today = new Date(); // Get the current time
		//Matches the time with the button that has been used and save them on text1
		$("#text1").val($("#text1").val() + " 3 " + Math.round(time) + " 0 " + today.getTime());
		$("#playbutton").attr("src", "/images/pause-button-40.png");
	}
	else if (player.getPlayerState() == YT.PlayerState.PLAYING) {
		player.pauseVideo(); // Pause video
		var time= player.getCurrentTime(); // Collects the current second for the database
		var today = new Date(); // Get the current time
		// Matches the time with the button that has been used
		$("#text1").val($("#text1").val() + " 4 " + Math.round(time) + " 0 " + today.getTime()); 
		$("#playbutton").attr("src", "/images/play-button-40.png");
	}
    $("#playbutton").button('refresh');
}		
         
function gobackward() //Function for the  goBackward button 
{ 
	player.unMute();

	var ctime= player.getCurrentTime(); // Collects the current second for the database
	var today = new Date(); // Get the current time
	var seekto;

	if (ctime > jump) { // Check if you can go backward the requested amount
		seekto = ctime - jump; // Go backward
	}
	else { //Otherwise go at the beginning of the video and start the video's playing state
		seekto = 0;
	}
	player.seekTo(seekto, true);
	compval = ctime << 16;
	compval = compval | seekto;
	// Matches the time with the button that has been used and save them on text1
	$("#text1").val($("#text1").val() + " 1 " + compval + " " + jump + " " + today.getTime());
}

function goforward() //Function for the Goforward button 
{ 
	player.unMute();

	var ctime = Math.round(player.getCurrentTime()); // Collects the current second for the database
	var duration = player.getDuration(); // Gets video's duration
	var today = new Date(); // Get the current time
	var seekto;
	
	if(ctime + jump <= duration) { //Checks is the time variable is smaller than duration
		seekto = ctime + jump; // This is the new position 
	}
	else {
		seekto = duration; // New position is at the end
	}
	player.seekTo(seekto, true);
	compval = ctime << 16;
	compval = compval | seekto;
	// Matches the time with the button that has been used and save them on text1
	$("#text1").val($("#text1").val() + " 2 " + compval + " " + jump + " " + today.getTime());
}   		

/*
* Polling the player for information
*/

function toTime(secs) //This function converts video time from milliseconds to seconds 
{ 
	var t = new Date(0,0,0);
	t.setSeconds(secs);

	return t.toTimeString().substr(3,5);
}

function onPlayerError(errorCode) // This function is called when an error is thrown by the player
{
	alert("An error occured of type:" + errorCode);
}

function onPlayerStateChange(event) // This function is called when the player changes state
{
  updateHTML("playerState", newState);
}

function display() // function for the countdown timer
{ 
	if (milisec <= 0) { 
		milisec = 9; 
		seconds -= 1; 
	} 
	if (seconds<=-1) { 
		milisec = 0; 
		seconds += 1; 
	} 
	else 
		milisec -= 1; 
	$("#counter").val("Remain Time:" + seconds + "." + milisec); 
	setTimeout("display()", 100);
}

function updateHTML(elmId, value) // Update a particular HTML element with a new value
{ 
	document.getElementById(elmId).innerHTML = toTime(value);
}

//Display information about the current state of the player
function updatePlayerInfo() {
		var total = player.getDuration();
		var ctime = player.getCurrentTime();
		
		updateHTML("videoDuration", total);
		updateHTML("videoCurrentTime", ctime);
		drawSeekBar(ctime / total * seekbar_res);
//		updateHTML("bytesTotal", ytplayer.getVideoBytesTotal());
//		updateHTML("startBytes", ytplayer.getVideoStartBytes());
//		updateHTML("bytesLoaded", ytplayer.getVideoBytesLoaded());
	
}

function temp() //This Function is fired when user presses submit
{ 
	$("form#transaction").trigger("submit"); 
	window.onbeforeunload=null;
}

/* Seekbar code by Petros Gasteratos */

var seekbar_res = 200;

function drawSeekBar(value) {
	var seekbar = document.getElementById("seekbar");
	var seekpos = document.getElementById("seekpos");

	if (seekbar != null && seekpos != null) {
		var barWidth = seekbar.offsetWidth;        
		seekpos.style.width = value / seekbar_res * barWidth;
	}
}

function updateSeekBar(e) {
	var seekbar = document.getElementById("seekbar");
	var seekpos = document.getElementById("seekpos");      
	var today = new Date(); // Get the current time
	
	if (seekbar != null && seekpos != null) {
    //seekbar x
		var element = seekbar;
		var seekbarX = element.offsetLeft;
		
		element = element.offsetParent;
		while(element != null) {
			seekbarX += element.offsetLeft;
			element = element.offsetParent;
		}
		
		
		var curr_width = seekpos.offsetWidth;
		
		var clickX = e.clientX - seekbarX;
		var clickXSt = curr_width;
		var barWidth = seekbar.offsetWidth;        
		drawSeekBar(clickX / barWidth * seekbar_res);
		var duration=player.getDuration();
		var startf = clickXSt / barWidth * duration;
		var seekto = clickX / barWidth * duration;
		player.seekTo(seekto, true);
		var seektime = seekto - startf;
    //store the new playback position
		if(seektime < 0) {
			seektime = -seektime;
			$("#text1").val($("#text1").val() + " 6 " + Math.round(seekto) + " " + Math.round(seektime) + " " + today.getTime());
			
		} else {
			$("#text1").val($("#text1").val() + " 5 " + Math.round(seekto) + " " + Math.round(seektime) + " " + today.getTime());
		}
		
	}
}


$(document).ready(function () {

	$("form").submit(function (e) { // Custom submit function
		e.preventDefault(); // Cancel default action
		$.post("/fusion", $("form").serialize(), function (data) {
			if (data == "ERROR") {
				//alert("Fusion tables error.");
			}
		}, "text");
		$("#text1").val("");
	});
	
});