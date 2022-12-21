#
# Toggl wrapper functions
# 
# todo: individual wrapper functions with unit testing
# todo: Set-TglProject, 
# todo: Set-TglClient???  
# todo: Add-TglTime 2hr -Project -Task "" 
#
# References:
# https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md
# 
# The reports API base URL is https://api.track.toggl.com/reports/api/v2
# Weekly report URL GET https://api.track.toggl.com/reports/api/v2/weekly
# Summary report URL: GET https://api.track.toggl.com/reports/api/v2/summary

$global:TglInitialized = $false
[DateTimeOffset]$global:TglDate = Get-Date
$global:TglMe = $null
$global:TglWorkspace = $null
$global:TglProjectID
$global:TglUserAgent
$global:WorkspaceID = $null

$reportUri = 'https://api.track.toggl.com/reports/api/v2/details'
$projectsUri = 'https://api.track.toggl.com/api/v8/projects'

$global:headers = @{}

Function Initialize-Toggl([string]$APIToken, [string]$UserAgent, [string]$WorkspaceName) {
    if ($UserAgent) {
        $global:TglUserAgent = $UserAgent
    }
    $global:headers = @{
        'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($apitoken + ':api_token'));
        'Content-Type' = 'application/json'
    }

    # get info about me
    $aboutMeUri = 'https://api.track.toggl.com/api/v8/me'
    $global:TglMe = Invoke-RestMethod -Uri $aboutMeUri -Method Get -Headers $headers

    # get workspaces (if only one, then this is my workspace)
    # todo handle multiple
    $workspacesUri = 'https://api.track.toggl.com/api/v8/workspaces'
    $global:TglWorkspace = Invoke-RestMethod -Uri $workspacesUri -Method Get -Headers $headers
    foreach($workspace in $TglWorkspace) {
        if ($workspace.name -eq $WorkspaceName) {
            $workspaceId = $workspace.id
            break
        }
    }
    $global:WorkspaceID = $workspaceId

    # key info:
    #   user id $me.data.id
    #   workspace id $ws.id

    $global:TglInitialized = $true
}

Function Get-TglDate() {
    return $global:TglDate
}

Function Set-TglDate([DateTimeOffset]$NewDate ) {
    $global:TglDate = $NewDate
}

Function Get-TglTimeEntries() {
    param (
        $TimeEntryID = $null
    )
    
    # dates must be ISO 8601
    # only returns last 9 days by default
    # max of 1000 entries returned

    $timeEntriesUri = 'https://api.track.toggl.com/api/v8/time_entries'
    if ($TimeEntryID) {
        $timeEntriesUri += "`/$TimeEntryID"
    }
    write-debug "URL: $timeEntriesUri"
    return Invoke-RestMethod -Uri $timeEntriesUri -Method Get -Headers $headers
}

Function Get-TglClients($WorkspaceID = $WorkspaceID) {
    #todo get workspace if not gotten
    $workspaceClientsUri = 'https://api.track.toggl.com/api/v8/workspaces/'+$WorkspaceID+'/clients'
    $Tglclients = Invoke-RestMethod -Uri $workspaceClientsUri -Method Get -Headers $headers
    $TglClients
}

Function Get-TglProjects() {
    # todo figure out types, if I filter the project list, I lost type info as in
    #  foreach ($p in ($projects.cid -eq 884250))  { $p, $p.GetType() }
    $workspaceProjectsUri = 'https://api.track.toggl.com/api/v8/workspaces/'+ $WorkspaceID +'/projects?active=both'
    $global:TglProjects = Invoke-RestMethod -Uri $workspaceProjectsUri -Method Get -Headers $headers
    $global:TglProjects
}

Function Set-TglProject() {
    # find project based on provided parameters
    # set the project and return the id
    return "not implemented"
}

Function Get-TglDetailedReport($UserAgent = $global:TglUserAgent, $WorkspaceID = $WorkspaceID) {
    $detailedReportUri = $reportUri+"?user_agent=$UserAgent&workspace_id=$WorkspaceID"
    $report = Invoke-RestMethod -Uri $detailedReportUri -Method Get -Headers $headers
    $report
}

function Get-TglDetailedReport2 {
    param (
        [DateTime]$Since,
        [DateTime]$Until,
        [string]$UserAgent = $null,
        [string]$UserIDs = $null,
        [string]$ProjectIDs = $null,
        [string]$WorkspaceID = $WorkspaceID
    )
	
    $pageNumber = 1
    $urlBase = $reportUri+"?workspace_id=$WorkspaceID&user_agent=$userAgent&rounding=on&display_hours=decimal"
    if ($Since) {
        $urlBase += "&since=$($Since.ToString('o'))"
    }
    if ($Until) {
        $urlBase += "&until=$($Until.ToString('o'))"
    }
    if ($UserIDs) {
        $urlBase += "&user_ids=$UserIDs"
    }
    if ($ProjectIDs) {
        $urlBase += "&project_ids=$ProjectIDs"
    }
    $url = $urlBase + "&page=$pageNumber"
    $report = @()
    $keepGoing = $true

    do {
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
        Write-Debug "$(Get-Date -Format 's'): Current page: $pageNumber Response total count: $($response.total_count) Response per page: $($response.per_page)"
        $report += $response.data

        if ($response.per_page*$pageNumber -lt $response.total_count) {
            $pageNumber += 1
            $url = $urlBase + "&page=$pageNumber"
            Start-Sleep -Milliseconds 500
        }
        else {
            $keepGoing = $false
        }

    } while ($keepGoing)

    return $report
}

Function Add-TglTimeEntry {
    #todo parameters for project, customer, hours, date with defaults using preset values
    param (
      $ProjectID = $global:TglProjectID,
      $Description = 'no description',
      $Duration = 30,  # default time entry is 30 minutes
      $Billable = $false,
      [DateTimeOffset]$StartDate = $global:TglDate,
      $Debug = $false
    )

    # Retain passed parameters as new defaults
    $global:TglProjecID = $ProjectID
    $global:TglDate = $StartDate

    $addTimeEntryUri = "https://api.track.toggl.com/api/v8/time_entries"
    $timeEntryDetails = @{
        'wid' = $global:TglWorkspace.id;
        'pid' =  $ProjectID;
        'description' = $Description;
        'duration' = $Duration*60;
        'created_with' = 'powershell';
        'start' = $StartDate.ToString('o'); # '2014-01-02T15:00:00Z'; # 
        'billable' = $Billable;
    }
    $timeEntry = @{'time_entry' = $timeEntryDetails }

    if ($Debug -eq $true) {
        $timeEntryDetails | fl
    }
    else {
        $result = Invoke-RestMethod -Uri $addTimeEntryUri -Method Post -Headers $headers -Body (ConvertTo-Json $timeEntry)
        $result
    }
}

Function Get-TglUsers($WorkspaceID) {
    # todo figure out types, if I filter the project list, I lost type info as in
    #  foreach ($p in ($projects.cid -eq 884250))  { $p, $p.GetType() }
    
    $workspaceUsersUri = "https://api.track.toggl.com/api/v8/workspaces/$WorkspaceID/users"
    $global:TglUsers = Invoke-RestMethod -Uri $workspaceUsersUri -Method Get -Headers $headers
    return $global:TglUsers
}


