var request = require('request');
var fs = require('fs');
var writeFile = true;	//todo make it an option

//todo get all time entries
//todo track differences
//todo save files
//todo check for leaky bucket
//todo get api token from non checked in config, put template in repo
//todo chain after workspace
//todo Write to database
//todo process changes
//todo https://azure.microsoft.com/en-us/blog/introducing-the-azure-cosmosdb-change-feed-processor-library/
//

var apiToken = 'b842531c68f5f20ccc091803d5584140';
var togglWorkspace = null;
var requestOptions = {
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

function getClients(workspace) {
	// todo get workspace if not gotten
	requestOptions.url = 'https://www.toggl.com/api/v8/workspaces/'+workspace.id+'/clients'

	request(requestOptions, function(err, res, clients){

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
	requestOptions.url = 'https://www.toggl.com/api/v8/workspaces/'+workspace.id+'/projects'

	request(requestOptions, function(err, res, projects){
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
	requestOptions.url = 'https://www.toggl.com/reports/api/v2/details?workspace_id='+workspace.id+'&page='+currentPageNumber+'&'+userAgent;
	
	request(requestOptions, function(err, res, detailedReport){
		if (err) {
			console.dir(err);
			return;
		}
		if (res.statusCode === 200) {
			pageCount = detailedReport.total_count;
			console.log('detailed Report page count '+detailedReport.total_count+' per page, '+detailedReport.per_page);
			if (writeFile) {
				var fileName = "timeentries_"+currentPageNumber+".json";
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

function processTimeEntries(timeEntries) {
	// stubbed for later
	console.log('TimeEntry count: ' + timeEntries.length)
	timeEntries.forEach(function(element) {
		console.log('' + element.description + ', ' + element.duration);
	}, this);
}

function getWorkspace() {

	requestOptions.url = 'https://www.toggl.com/api/v8/workspaces';

	request(requestOptions, function(err, res, body){
		if (err) {
			console.dir(err);
			return;
		}

		console.log('status code: ' + res.statusCode);
		
		if (res.statusCode === 200) {
			//todo don't assume one workspace
			togglWorkspace = body[0];
			console.log('Workspace id: '+togglWorkspace.id+' name: '+togglWorkspace.name);

			// don't do this here... standalone functions
			// getClients(togglWorkspace);
			// getProjects(togglWorkspace);

		}
		else {
			console.log('status code: ' + res.statusCode);
		}

		return;		
	});
}

console.log('get workspace');
getWorkspace();

pageNumber = 1;
pageCount = 1;

function scheduleRequest() {
	console.log('next request '+pageCount);
	getTimeEntries(togglWorkspace, pageNumber);
	pageNumber++;
	if (pageCount < pageNumber) {
		console.log('all done: '+pageCount);
		return;
	} else {
		setTimeout(scheduleRequest, 2000)
	}
}
setTimeout(scheduleRequest, 2000);

