var request = require('request');
var fs = require('fs');

//todo track differences
//todo save files
//todo check for leaky bucket
//todo get api token from non checked in config, put template in repo
//todo chain after workspace

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

function getTimeEntries() {
	// todo only get 50 at a time
	// todo remember where we left off
	// todo check status for rejects

    // GET "https://www.toggl.com/api/v8/time_entries?start_date=2013-03-10T15%3A42%3A46%2B02%3A00&end_date=2013-03-12T15%3A42%3A46%2B02%3A00"
    // dates must be ISO 8601
	requestOptions.url = 'https://www.toggl.com/api/v8/time_entries';
	
	request(requestOptions, function(err, res, timeEntries){
		if (err) {
			console.dir(err);
			return;
		}
		if (res.statusCode === 200) {
			console.log('TimeEntry count: ' + timeEntries.length)
			timeEntries.forEach(function(element) {
				console.log('' + element.description + ', ' + element.duration);
			}, this);
		}
		else {
			console.log('getTimeEntries status code: ' + res.statusCode);
		}

		return;
	});


}

function getWorkspace() {

	requestOptions.url = 'https://www.toggl.com/api/v8/workspaces';

	request(requestOptions, function(err, res, body){
		if (err) {
			console.dir(err);
			return;
		}
		if (res.StatusCode === 200) {
			//todo don't assume one workspace
			togglWorkspace = body[0];
		}
		else {
			console.log('status code: ' + res.statusCode);
		}

		// getClients(togglWorkspace);
		// getProjects(togglWorkspace);
		getTimeEntries();
		return;		
	});
}

console.log('get workspace >>>');
getWorkspace();
console.log('<<<');

