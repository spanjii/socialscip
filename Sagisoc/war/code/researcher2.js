var slide = 0x01; // Buttons - Slider bit mask
var play = 0x02; // Play button bit mask
var forward = 0x04; // Forward button bit mask
var backward = 0x08; // Backward button bit mask
var jump = 0x3F << 4; // Jump duration bit mask (6 bits 0-63 seconds)
var interaction = 0xFF << 10; // Total interaction time bit mask (8 bits 0-255 minutes)
var row;

var chartdata = '1BXEvX-yZPD2-*******JJJ94sR-tnWDYzJomQIc' // Id of Fusion Table containing the data for the chart
	
// New experiment row HTML code 
var newrow = '<tr><td class="descr"></td><td class="hidden"></td>' + 
	'<td class="hidden"></td><td class="hidden"></td><td class="hidden"></td>' +
	'<td class="hidden"></td><td><input type="button" value="Edit" class="edit" /></td>' +
	'<td><input type="button" value="Charts" class="charts" /></td>' +
	'<td><input type="button" value="Get URL" class="geturl" /></td>' +
	'<td><input type="button" value="Delete" class="delete" /></td>' +
	'<td><input type="button" value="Download data" class="data" /></td></tr>';

/* This function translates the value that accepts as input to the corresponding 
 * controls (Buttons/Slider, Play, Forward and Backward buttons plus the Jump value and total
 * Interaction time
 */
function toControls(fld) {
	if (fld & slide == 1) {
		var control = $("form input[name='controltype']")[1];
	} else {
		var control = $("form input[name='controltype']")[0];
	}
	$("#play").prop('checked', ((fld & play) != 0) ? true : false);
	$("#forward").prop('checked', ((fld & forward) != 0) ? true : false);
	$("#backward").prop('checked', ((fld & backward) != 0) ? true : false);
	$("#jump").val((fld & jump) >>> 4);
	$("#interaction").val((fld & interaction) >>> 10);
	$(control).prop('checked', true).change();
}


/* 
 * This function return a time from jump. 
 */
function getJump(fld) {
	return ((fld & jump) >>> 4);
}



/* This function is the opposite from the previous. It translates the values of the various 
 * controls (Buttons/Slider, Play, Forward and Backward buttons plus the Jump value and total
 * Interaction time) selected by the user into an integer. 
 */
function fromControls() {
	var fld = 0;

	if ($("form input[name='controltype']:checked").val() == "slide")
		fld |= slide;
	if ($("#play").is(":checked"))
		fld |= play;
	if ($("#forward").is(":checked"))
		fld |= forward;
	if ($("#backward").is(":checked"))
		fld |= backward;
	fld |= ($("#jump").val() << 4);
	fld |= ($("#interaction").val() << 10);
	
	return fld;
}

/* This function is executed when the user presses the edit button in a 
 * experiment description. It fills the form input controls with the values 
 * for the experiment so as to enable the user to edit them.
 */
function edit() {
	row = $(this).closest("tr"); // Table row that contains the experiment data
	$("#descr").val($("td:eq(0)", row).html());
	$("#expid").val($("td:eq(1)", row).html()); // Experiment id 
	$("#videourl").val($("td:eq(2)", row).html());
	$("#controls").val($("td:eq(3)", row).html());
	$("#question").val($("td:eq(4)", row).html());
	$("#info").val($("td:eq(5)", row).html());
	$("#submit").val("Update"); // Submit button label
	$("#action").val("1"); // Action code for an update
	$("#videoinfo").overlay().load(); // Open form as an overlay
	toControls($("#controls").val()); // Fill form controls
}


/* This function is executed after update. It transfers the values from the
 * form to the columns of the table if the update was successfull.
 */
function postEdit(response) {
	if (response == "OK") {
		alert("Successfull update");
		$("td:eq(0)", row).html($("#descr").val());
		$("td:eq(2)", row).html($("#videourl").val());
		$("td:eq(3)", row).html($("#controls").val());
		$("td:eq(4)", row).html($("#question").val());
		$("td:eq(5)", row).html($("#info").val());
	}
	else
		alert("Action failed");
}


/* This function is executed after the insertion of the new experiment
 * It prints out a message and then inserts a new row in the HTML table
 * containing the info of the experiments.
 */
function postInsert(response) {
	if (response != "ERROR") {
		window.location.reload();
	} else
		alert("Action failed");
}

/* This function is executed when the user presses the Insert button.
 * It opens a form for the user to ill in the details of the experiment.
 */
function insert() {
	$("#descr").val("");
	$("#videourl").val("");
	$("#controls").val("0");
	$("#question").val("");
	$("#info").val("");
	$("#submit").val("Create");
	$("#action").val("2");
    $("#accordion").accordion({ collapsible: true, active: false });
	$("#videoinfo").overlay().load();
	toControls($("#controls").val());
}

/* This function is executed when the user presses the Delete button. It 
 * prints out the info of the experiment and waits for the user to press
 * Delete button again for confirmation.
 */
function del() {
	row = $(this).closest("tr"); // Table row that contains the experiment data
	$("#expiddel").val($("td:eq(1)", row).html()); // Experiment id 
	$("#expid").val($("td:eq(1)", row).html()); // Experiment id
	$("div#page").attr("class", "opacity");
	$( "#dialog" ).dialog({width: 450, beforeClose: function(event,ui){ $("div#page").removeAttr("class"); } });
}


/* This function is executed after the deletion of the experiment.
 * It prints out a message and removes the experiment row from the HTML 
 * table.
 */
function postDelete(response) {
	if (response == "OK") {
		$("h3#h" + $("#expiddel").val()).remove();
		$("div#h" + $("#expiddel").val()).remove();
		$("#dialog").dialog('close');
	} else
		alert("Action failed");
}


/*
* This function is executed when the user presses the Get URL button and
* prints out the url that someone has to type to watch the video.
*/
function getURL() {
	row = $(this).closest("tr");
	var expid = $("td:eq(1)", row).html();
	$("#geturl").val(window.location.hostname + "/?videoId=" + expid);
	$("div#page").attr("class", "opacity");
	$("#urlvideoid").dialog({width: 600, beforeClose: function(event,ui){ $("div#page").removeAttr("class"); }});
}

/*
* This function is executed when the user presses the
* Charts button and prints out buttons to view the charts.
*/
function getCharts() {
	row = $(this).closest("tr");
	$("#charts").html($("td:eq(1)", row).html()); 
	$("#controls").html($("td:eq(3)", row).html());
	//$("div#page").attr("class", "opacity");
	//$("#viewcharts").dialog({width: 600, beforeClose: function(event,ui){ $("div#page").removeAttr("class"); }});
	$("#viewcharts").overlay().load();
}



function downloadData() {
	row = $(this).closest("tr");
	
	var expid = $("td:eq(1)", row).html();
	var descr = $("td:eq(0)", row).html();
	
	window.location.href ="/download?videoid=" + expid + "&video=" + descr;
	return false;
}


/* This function contains initialization code that is executed right after the
 * page is loaded and the DOM is ready to be manipulated.
 */
$(document).ready(function () {
	$(".edit").click(edit);
	$(".delete").click(del);
	$(".geturl").click(getURL);
	$(".charts").click(getCharts);	
	$(".view").click(loadChart);
	$(".viewreplay").click(loadReplayChart);
	$(".final1").click(loadFinalChart);	
	$(".data").click(downloadData);
	$("form input[name='controltype']").change(function () {
		if ($(this).closest("form input[name='controltype']:checked").val() == "slide") {
			$("#buttons").slideUp();
		} else {
			$("#buttons").slideDown();
		}
	});
	$("#controls").val(fromControls()); // Controls value
	$("form#createupdate").submit(function (e) { // Custom submit function
		e.preventDefault(); // Cancel default action
		$("#controls").val(fromControls()); // Controls value
		// Send request to server with the form data
		$.post("/researcher_videos", $("form").serialize(), function (data) {
			var action = $("#action").val();
			if (action == 1) {
				postEdit(data);
			} else if (action == 2) {
				postInsert(data);
			} 
			$("#videoinfo").overlay().close();
		}, "text");
	});
	
	$("form#deleteform").submit(function (e) { // Custom submit function
		e.preventDefault(); // Cancel default action
		$("#controls").val(fromControls()); // Controls value
		// Send request to server with the form data
		$.post("/researcher_videos", $("form#deleteform").serialize(), function (data) {
				postDelete(data);
		}, "text");
	});
	$("#videoinfo").overlay(); // Prepare experiment popup form
	$("#urlinfo").overlay(); // Prepare URL popup
	$("#chart").overlay(); // Prepare Chart popup window
	$("#replaychart").overlay(); // Prepare Chart popup window
	$("#finalchart").overlay(); // Prepare Chart popup window
	$("#viewcharts").overlay(); // Prepare Charts popup window
	
	
	
});



/* This function is executed when the user presses the Transactions chart button. It just loads
 * the Google Chart Api and calls the viewChart function after it is loaded.
 */
function loadChart() {
	row = $(this).closest("tr");
	google.load("visualization", "1", {"callback" : viewChart, packages:["corechart"]});
}

/* This function requests the data for the experiment from the Fusion Table Service
 * which they are used to draw the chart.
 */
function viewChart() {
	var expid = ($("#charts").html());
	// Replace the data source URL on next line with your data source URL.
    // Specify that we want to use the XmlHttpRequest object to make the query.
	//	  var opts = {sendMethod: 'xhr'};
	var query = new google.visualization.Query('http://www.google.com/fusiontables/gvizdata?tq=');
	var queryString = "SELECT Time, TransactionId, Count() FROM " + chartdata + " WHERE VideoId='" + expid +
		"' GROUP BY Time, TransactionId ORDER BY Time";
	// Request only Time, TransactionId and Count grouped by Time and TransactionId. Replace ID with
	// your table ID (Table 4 in Implementation Document)
	query.setQuery(queryString);
	  
	// Send the query with a callback function.
	query.send(handleQueryResponse);
}

/* This function takes the response from the Fusion Table Service and prepares the 
// * data for the Chart.
 */
function handleQueryResponse(response) {
	if (response.isError()) {
		alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
		return;
	}
	
	var data = response.getDataTable(); //Get DataTable from Fusion Table response
	var backwardView = new google.visualization.DataView(data); // Backward

	backwardView.setRows(backwardView.getFilteredRows([{column: 1, value: 1}])); // Keep rows with TransactionId 1
	// Keep Time and Count columns modified by 2 
	backwardView.setColumns([0, {calc:doubleVal, type:'number', label:'GoBackward'}]); 
	
	var forwardView = new google.visualization.DataView(data); // Forward
	forwardView.setRows(forwardView.getFilteredRows([{column: 1, value: 2}]));// Keep rows with TransactionId 2
	// Keep Time and Count columns modified by 2
	forwardView.setColumns([0, {calc:minusDoubleVal, type:'number', label:'GoForward'}]);

	var playView = new google.visualization.DataView(data); // Play
	playView.setRows(playView.getFilteredRows([{column: 1, value: 3}]));// Keep rows with TransactionId 3
	// Keep Time and Count columns modified by 2
	playView.setColumns([0, {calc:doubleVal, type:'number', label:'Play'}]);

	var pauseView = new google.visualization.DataView(data); // Pause
	pauseView.setRows(pauseView.getFilteredRows([{column: 1, value: 4}]));// Keep rows with TransactionId 4
	// Keep Time and Count columns modified by 2
	pauseView.setColumns([0, {calc:doubleVal, type:'number', label:'Pause'}]);

	var seekView = new google.visualization.DataView(data); // Seek
	seekView.setRows(seekView.getFilteredRows([{column: 1, value: 5}]));// Keep rows with TransactionId 5
	// Keep Time and Count columns modified by 2
	seekView.setColumns([0, {calc:doubleVal, type:'number', label:'Seek'}]);

	// Join Forward and Backward
	var inter1 = google.visualization.data.join(backwardView, forwardView, 'full', [[0,0]], [1], [1]);
	// Join Forward, Backward and Play
	var inter2 = google.visualization.data.join(inter1, playView, 'full', [[0,0]], [1, 2], [1]);
	// Join Forward, Backward, Play and Pause
	var inter3 = google.visualization.data.join(inter2, pauseView, 'full', [[0,0]], [1, 2, 3], [1]);
	// Join Forward, Backward, Play, Pause and Seek
	var inter4 = google.visualization.data.join(inter3, seekView, 'full', [[0,0]], [1, 2, 3, 4], [1]);
	
	var view = new google.visualization.DataView(inter4);
	//view.setColumns([0, 1, 2, 3, 4, 5]);
	view.setColumns([0, 1, 2, 3, 4, 5, {calc:summary, type:'number', label:'SocialSkip'}]);
	var chart = new google.visualization.LineChart(document.getElementById('visualization'));
	chart.draw(view, {width: 700, height: 525, strictFirstColumnType: true});
	$("#chart").overlay().load();
}
	
function doubleVal(dataTable, rowNum){
	return dataTable.getValue(rowNum, 2) * 2;	
}

function minusDoubleVal(dataTable, rowNum){
	return dataTable.getValue(rowNum, 2) * -2;	
}

function summary(dt, rowNum){
	return 23 + dt.getValue(rowNum, 1) + dt.getValue(rowNum, 2) + dt.getValue(rowNum, 3) + dt.getValue(rowNum, 4);	
}


function Val(dataTable, rowNum){
	return dataTable.getValue(rowNum, 2) * 1;	
}

function minusVal(dataTable, rowNum){
	return dataTable.getValue(rowNum, 2) * -1;	
}

function important(dt, rowNum){
	var max = dt.getColumnRange(1).max;
	var max1 = dt.getColumnRange(2).max;
	if(max1 > max) {
		max = max1;
	}
	return 0.5 + (dt.getValue(rowNum, 1) - dt.getValue(rowNum, 2))/(2*max);	
}

function summaryForFinal(dt, rowNum){
	return dt.getValue(rowNum, 1) + dt.getValue(rowNum, 2) + dt.getValue(rowNum, 3) + dt.getValue(rowNum, 4);	
}



/* This function is executed when the user presses the Replay chart button. It just loads
 * the Google Chart Api and calls the viewChart function after it is loaded.
 */
function loadReplayChart() {
	row = $(this).closest("tr");

	google.load('visualization', '1', {"callback" : replayChart, packages: ['corechart']});
}

/* This function requests the data for the experiment from the Fusion Table Service
 * which they are used to draw the chart.
 */
function replayChart() {

	var expid = ($("#charts").html());
	
	// Replace the data source URL on next line with your data source URL.
    // Specify that we want to use the XmlHttpRequest object to make the query.
	//	  var opts = {sendMethod: 'xhr'};
	var query = new google.visualization.Query('http://www.google.com/fusiontables/gvizdata?tq=');
	var queryString = "SELECT Time, TransactionId, JumpTime FROM " + chartdata + " WHERE VideoId='" + expid + "'";
	// Request only Time, TransactionId and Count grouped by Time and TransactionId. Replace ID with
	// your table ID (Table 4 in Implementation Document)
	query.setQuery(queryString);
	  
	// Send the query with a callback function.
	query.send(handleQueryResponseRep);
}


/* This function takes the response from the Fusion Table Service and prepares the 
//* data for the Chart.
*/
function handleQueryResponseRep(response) {

	  if (response.isError()) {
	    alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
	    return;
	  }

	  var jump = parseInt(getJump($("#controls").html()));
	  
	  var data = response.getDataTable(); //Get DataTable from Fusion Table response
	  
	  var numberOfRows = data.getNumberOfRows();
	  
	  var timecol;

	  for ( var i = 0; i < numberOfRows; i++) {
			timecol = data.getValue(i, 0);
			

			if ((data.getValue(i, 1)) == 1 || (data.getValue(i, 1)) == 2 || (data.getValue(i, 1)) == 3 || (data.getValue(i, 1)) == 4) {
				
				for ( var j = 1; j < jump; j++) {
					if (timecol - j > 0) {
						if ((data.getValue(i, 1)) == 1) {
							data.addRow([ timecol - j, 1, 1 ]);
						} else if ((data.getValue(i, 1)) == 2) {
							data.addRow([ timecol + j, 2, 1 ]);
						}
					}
				}
				
			} else if ((data.getValue(i, 1)) == 5 || (data.getValue(i, 1)) == 6) {
				for ( var j = 1; j < data.getValue(i, 2); j++) {
					if (timecol - j > 0) {
						if ((data.getValue(i, 1)) == 5) {
							data.addRow([ timecol - j, 2, 1 ]);
						} else if ((data.getValue(i, 1)) == 6) {
							data.addRow([ timecol + j, 1, 1 ]);
						} 
					}
				}
				
			}
		}
	  
	    // Sort data on time
	    data.sort([{column: 0}]);

	    // Group data
	    var datagp = google.visualization.data.group(
	    		data, [0, 1],
	    	      [{'column': 2, 'aggregation': google.visualization.data.sum, 'type': 'number'}]);
	    
	    var backwardView = new google.visualization.DataView(datagp); // Backward
	    backwardView.setRows(backwardView.getFilteredRows([{column: 1, value: 1}])); // Keep rows with TransactionId 1	    
		// Keep Time and Count columns modified by 2 
	    backwardView.setColumns([0, {calc:Val, type:'number', label:'GoBackward'}]); 
		
		
		var forwardView = new google.visualization.DataView(datagp); // Forward
		forwardView.setRows(forwardView.getFilteredRows([{column: 1, value: 2}]));// Keep rows with TransactionId 2
		// Keep Time and Count columns modified by 2
		forwardView.setColumns([0, {calc:Val, type:'number', label:'GoForward'}]);
	
		// Join Forward and Backward
		var result = google.visualization.data.join(backwardView, forwardView, 'full', [[0,0]], [1], [1]);
	  
		// Join Forward and Backward
		var view = new google.visualization.DataView(result);
        //view.setColumns([0, 1, 2, {calc:important, type:'number', label:'Important'}]);
		view.setColumns([0, {calc:important, type:'number', label:'Important'}]);
		var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
		
		var options = {'title':'How much important is the video each time moment (0 = low, 1 = very)',
				'vAxis': {'maxValue': 1, 'minValue': 0},
			    'hAxis': {'title': 'Time (sec)'},
                'width':700,
                'height':525};
		
		chart.draw(view, options);
		$("#replaychart").overlay().load();
	}


/* This function is executed when the user presses the Replay chart button. It just loads
 * the Google Chart Api and calls the viewChart function after it is loaded.
 */
function loadFinalChart() {
	row = $(this).closest("tr");
	google.load('visualization', '1', {"callback" : finalChart, packages: ['corechart']});
}

/* This function requests the data for the experiment from the Fusion Table Service
 * which they are used to draw the chart.
 */
function finalChart() {
	var expid = ($("#charts").html());
	
	// Replace the data source URL on next line with your data source URL.
    // Specify that we want to use the XmlHttpRequest object to make the query.
	//	  var opts = {sendMethod: 'xhr'};
	var query = new google.visualization.Query('http://www.google.com/fusiontables/gvizdata?tq=');
	var queryString = "SELECT Time, TransactionId, JumpTime FROM " + chartdata + " WHERE VideoId='" + expid + "'";
	// Request only Time, TransactionId and Count grouped by Time and TransactionId. Replace ID with
	// your table ID (Table 4 in Implementation Document)
	query.setQuery(queryString);
	  
	// Send the query with a callback function.
	query.send(handleQueryResponseFinal);
}


/* This function takes the response from the Fusion Table Service and prepares the 
//* data for the Chart.
*/
function handleQueryResponseFinal(response) {
	if (response.isError()) {
		alert('Error in query: ' + response.getMessage() + ' '
				+ response.getDetailedMessage());
		return;
	}

	var jump = parseInt(getJump($("#controls").html()));

	var data = response.getDataTable(); // Get DataTable from Fusion Table
										// response

	var numberOfRows = data.getNumberOfRows();

	var timecol;
	for ( var i = 0; i < numberOfRows; i++) {
		timecol = data.getValue(i, 0);
		

		if ((data.getValue(i, 1)) == 1 || (data.getValue(i, 1)) == 2 || (data.getValue(i, 1)) == 3 || (data.getValue(i, 1)) == 4) {
			
			for ( var j = 1; j < jump; j++) {
				if (timecol - j > 0) {
					if ((data.getValue(i, 1)) == 1) {
						data.addRow([ timecol - j, 1, 1 ]);
					} else if ((data.getValue(i, 1)) == 2) {
						data.addRow([ timecol + j, 2, 1 ]);
					} else if ((data.getValue(i, 1)) == 3) {
						data.addRow([ timecol, 3, 1 ]);
						break;
					} else if ((data.getValue(i, 1)) == 4) {
						data.addRow([ timecol, 4, 1 ]);
						break;
					}
				}
			}
			
		} else if ((data.getValue(i, 1)) == 5 || (data.getValue(i, 1)) == 6) {
			for ( var j = 1; j < data.getValue(i, 2); j++) {
				if (timecol - j > 0) {
					if ((data.getValue(i, 1)) == 5) {
						data.addRow([ timecol - j, 2, 1 ]);
					} else if ((data.getValue(i, 1)) == 6) {
						data.addRow([ timecol + j, 1, 1 ]);
					} 
				}
			}
			
		}
	}

	// Sort data on time
	data.sort([ {
		column : 0
	} ]);

	// Group data
	var datagp = google.visualization.data.group(data, [ 0, 1 ], [ {
		'column' : 2,
		'aggregation' : google.visualization.data.sum,
		'type' : 'number'
	} ]);

	var backwardView = new google.visualization.DataView(datagp); // Backward
	backwardView.setRows(backwardView.getFilteredRows([ {
		column : 1,
		value : 1
	} ])); // Keep rows with TransactionId 1
	// Keep Time and Count columns modified by 2
	backwardView.setColumns([ 0, {
		calc : doubleVal,
		type : 'number',
		label : 'GoBackward'
	} ]);

	var forwardView = new google.visualization.DataView(datagp); // Forward
	forwardView.setRows(forwardView.getFilteredRows([ {
		column : 1,
		value : 2
	} ]));// Keep rows with TransactionId 2
	// Keep Time and Count columns modified by 2
	forwardView.setColumns([ 0, {
		calc : minusDoubleVal,
		type : 'number',
		label : 'GoForward'
	} ]);

	var playView = new google.visualization.DataView(datagp); // Play
	playView.setRows(playView.getFilteredRows([ {
		column : 1,
		value : 3
	} ]));// Keep rows with TransactionId 3
	// Keep Time and Count columns modified by 2
	playView.setColumns([ 0, {
		calc : doubleVal,
		type : 'number',
		label : 'Play'
	} ]);

	var pauseView = new google.visualization.DataView(datagp); // Pause
	pauseView.setRows(pauseView.getFilteredRows([ {
		column : 1,
		value : 4
	} ]));// Keep rows with TransactionId 4
	// Keep Time and Count columns modified by 2
	pauseView.setColumns([ 0, {
		calc : doubleVal,
		type : 'number',
		label : 'Pause'
	} ]);

	// Join Forward and Backward
	var inter1 = google.visualization.data.join(backwardView, forwardView,
			'full', [ [ 0, 0 ] ], [ 1 ], [ 1 ]);
	// Join Forward, Backward and Play
	var inter2 = google.visualization.data.join(inter1, playView, 'full', [ [
			0, 0 ] ], [ 1, 2 ], [ 1 ]);
	// Join Forward, Backward, Play and Pause
	var inter3 = google.visualization.data.join(inter2, pauseView, 'full', [ [
			0, 0 ] ], [ 1, 2, 3 ], [ 1 ]);

	var view = new google.visualization.DataView(inter3);
	view.setColumns([ 0, {
		calc : summaryForFinal,
		type : 'number',
		label : 'Summary'
	} ]);
	var chart = new google.visualization.AreaChart(document
			.getElementById('visualization'));

	var options = {
		'hAxis' : {
			'title' : 'Time (sec)'
		},
		'width' : 700,
		'height' : 525
	};
	chart.draw(view, options);
	$("#chart").overlay().load();

}


