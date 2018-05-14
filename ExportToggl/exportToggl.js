const Request = require('request');
var fs = require('fs');
var date = require('date-and-time');

const mongodb = require('mongodb')
const mongo = mongodb.MongoClient

// todo configure
const url = 'mongodb://toggldb:w8lwy6xeyIIyoqp3Aeh96RGuDLAnTBINS132Qc8DtpTalbY2ibyo8xeRrCnAQ6WNYrOacvSnvHPdV9jwykPESw==@toggldb.documents.azure.com:10255/?ssl=true'
// const url = 'mongodb://localhost:27017/toggl'

var writeFile = true;	//todo make it an option
const dataPath = "c:\\data\\";

var apiToken = 'b842531c68f5f20ccc091803d5584140'; //todo configure
var togglWorkspace = null;
var RequestOptions = {
	url: '',
	json: true,
	headers: {
		Authorization: `Basic ${new Buffer(`${apiToken}:api_token`, 'utf8').toString('base64')}`
	},
	timeout: 10 * 1000
};
var clients = [];
var timeEntries = [];
var userAgent = 'user_agent=phil@intellitect.com';
var pageCount = 0;

function getClients(workspace) {
	// todo get workspace if not gotten
	RequestOptions.url = 'https://www.toggl.com/api/v8/workspaces/'+workspace.id+'/clients'

	Request(RequestOptions, function(err, res, clients){

		if (err) {
			console.dir(err);
			return;
		}
		console.log('getClients status code: ' + res.statusCode);

		clients.forEach(function(element) {
			console.log('' + element.name);
		}, this);
		return;
	});
}

function getProjects(workspace) {
	RequestOptions.url = 'https://www.toggl.com/api/v8/workspaces/'+workspace.id+'/projects'

	Request(RequestOptions, function(err, res, projects){
		if (err) {
			console.dir(err);
			return;
		}
		console.log('getProjects status code: ' + res.statusCode);

		projects.forEach(function(element) {
			console.log('' + element.name);
		}, this);
		return;
	});
	
}

function getTimeEntries(workspace, currentPageNumber) {
	//todo remember where we left off/stash the latest and earliest time entry
	//todo check status for rejects

	// "https://toggl.com/reports/api/v2/details?workspace_id=123&since=2013-05-19&until=2013-05-20&user_agent=api_test"
    // GET "https://www.toggl.com/api/v8/time_entries?start_date=2013-03-10T15%3A42%3A46%2B02%3A00&end_date=2013-03-12T15%3A42%3A46%2B02%3A00"
	// dates must be ISO 8601
	
	if (!currentPageNumber) {
		currentPageNumber = 1;
	}
	RequestOptions.url = 'https://www.toggl.com/reports/api/v2/details?workspace_id='+workspace.id+'&page='+currentPageNumber+'&'+userAgent;
	
	Request(RequestOptions, function(err, res, detailedReport){
		if (err) {
			console.dir(err);
			return;
		}
		if (res.statusCode === 200) {
			pageCount = detailedReport.total_count;
			console.log('detailed Report page count '+detailedReport.total_count+' per page, '+detailedReport.per_page);
			if (writeFile) {
				var fileName = `${dataPath}_timeentries_${currentPageNumber}.json`;
				fs.writeFile(fileName, JSON.stringify(detailedReport.data), (err) => {
					if (err) {
						console.log('Error writing'+fileName+': '+err);
					}
				});
			}
		}
		else {
			console.log('getTimeEntries status code: ' + res.statusCode);
		}
		return;
	});


}


function getDetailedReportToFiles(workspace, projectID, currentPageNumber) {
	//todo remember where we left off/stash the latest and earliest time entry
	//todo check status for rejects

	if (!currentPageNumber) {
		currentPageNumber = 1;
	}
	
	var since = new Date();
	since = date.addDays(since, -364);

	RequestOptions.url = `https://www.toggl.com/reports/api/v2/details`;
	RequestOptions.url = RequestOptions.url + `?workspace_id=${workspace.id}&project_ids=${projectID}&page=${currentPageNumber}`;
	RequestOptions.url = RequestOptions.url + `&since=${date.format(since, "YYYY-MM-DD")}`;
	RequestOptions.url = RequestOptions.url + `&${userAgent}`;
	
	Request(RequestOptions, function(err, res, detailedReport){
		if (err) {
			console.dir(err);
			return;
		}
		if (res.statusCode === 200) {
			pageCount = detailedReport.total_count;
			console.log('detailed Report item count '+detailedReport.total_count+' per page, '+detailedReport.per_page);
			if (writeFile) {
				var fileName = `${projectName}_${projectID}_timeentries_${currentPageNumber}.json`;
				fs.writeFile(fileName, JSON.stringify(detailedReport.data), (err) => {
					if (err) {
						console.log('Error writing'+fileName+': '+err);
					}
				});
			}
			setTimeout(getDetailedReport, 1000, workspace, projectID, currentPageNumber+1);
		}
		else {
			console.log('getTimeEntries status code: ' + res.statusCode);
		}
		return;
	});

}

function getDetailedReport(timeEntries, workspace, projectID, currentPageNumber) {
	//todo remember where we left off/stash the latest and earliest time entry

	if (!currentPageNumber) {
		currentPageNumber = 1;
	}
	console.log('requesting page '+currentPageNumber);

	//todo hmm
	var since = new Date();
	since = date.addDays(since, -364);

	RequestOptions.url = `https://www.toggl.com/reports/api/v2/details`;
	RequestOptions.url = RequestOptions.url + `?workspace_id=${workspace.id}`
	if (projectID) {
		RequestOptions.url = RequestOptions.url + `&project_ids=${projectID}`;
	}
	RequestOptions.url = RequestOptions.url + `&page=${currentPageNumber}&since=${date.format(since, "YYYY-MM-DD")}`;
	RequestOptions.url = RequestOptions.url + `&${userAgent}`;
	
	Request(RequestOptions, function(err, res, detailedReport){
		if (err) {
			console.dir(err);
			return;
		}
		if (res.statusCode === 200) {
			console.log('detailed Report item count '+detailedReport.total_count+' per page, '+detailedReport.per_page);
			if (detailedReport.data.length > 0) {
				timeEntries.insert(detailedReport.data, (error, result) => {
					if (error) {
						console.log('Error inserting data: ' + error)
					}
				})
			}
			if (detailedReport.total_count < detailedReport.per_page*currentPageNumber) {
				console.log('done requesting data')
				//todo finally close everything up
			}
			else {
				setTimeout(getDetailedReport, 1000, timeEntries, workspace, projectID, currentPageNumber+1);
			}
		}
		else {
			console.log('getTimeEntries status code: ' + res.statusCode);
		}
		console.log('request complete')
		return;
	});

}

function processTimeEntries(timeEntries) {
	// stubbed for later
	console.log('TimeEntry count: ' + timeEntries.length)
	timeEntries.forEach(function(element) {
		console.log('' + element.description + ', ' + element.duration);
	}, this);
}

function getWorkspace() {
	RequestOptions.url = 'https://www.toggl.com/api/v8/workspaces';
	Request(RequestOptions, function(err, res, body){
		if (err) {
			console.dir(err);
			return;
		}
		if (res.statusCode === 200) {
			//todo don't assume one workspace
			togglWorkspace = body[0];
			console.log('Workspace id: '+togglWorkspace.id+' name: '+togglWorkspace.name);

		}
		else {
			console.log('status code: ' + res.statusCode);
		}
		return;		
	});
}

function scheduleRequest() {
	mongo.connect(url, (err, db) => {
		if (err) {
			console.log('Error connecting to db: '+err)
			return process.exit(1)
		}
		var time = db.collection('projectentries')
		console.log('connected')

		setTimeout(getDetailedReport, 1000, time, togglWorkspace, projectId);
	})
}


// do the do

console.log('getting workspace... ');
getWorkspace();

var pageNumber = 1;
var projectId = "";
var projectName = process.argv[2];

if (projectName) {
	console.log('getting time entries for project: '+projectName);
}
if (projectName === "StayAlfred") {
	// *** project codes
	// StayAlfred https://toggl.com/app/projects/360536/edit/95285334
	projectId = "95285334";
}
else if (projectName === "WATrust") {
	// WATrust Branch Manual: https://toggl.com/app/projects/360536/edit/97366140
	projectId = "97366140";
}


// todo use async/await to insure we have a workspace vs. a timer
setTimeout(scheduleRequest, 2000)

console.log('ended')





