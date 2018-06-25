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
