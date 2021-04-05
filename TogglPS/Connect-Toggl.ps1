#
# Toggl wrapper functions
# 
# todo: individual wrapper functions with unit testing
# todo: Set-TglProject, 
# todo: Set-TglClient???  
# todo: Add-TglTime 2hr -Project -Task "" 
#
# https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md
# 

$global:TglInitialized = $false
[DateTimeOffset]$global:TglDate = Get-Date
$global:TglMe = $null
$global:TglWorkspace = $null
$global:TglProjectID

$reportUri = 'https://toggl.com/reports/api/v2/details'
$projectsUri = 'https://www.toggl.com/api/v8/projects'

$global:headers = @{}

Function Initialize-Toggl([string]$APIToken) {
    $global:headers = @{
        'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($apitoken + ':api_token'));
        'Content-Type' = 'application/json'
    }

    # get info about me
    $aboutMeUri = 'https://www.toggl.com/api/v8/me'
    $global:TglMe = Invoke-RestMethod -Uri $aboutMeUri -Method Get -Headers $headers

    # get workspaces (if only one, then this is my workspace)
    # todo handle multiple
    $workspacesUri = 'https://www.toggl.com/api/v8/workspaces'
    $global:TglWorkspace = Invoke-RestMethod -Uri $workspacesUri -Method Get -Headers $headers

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
    # GET "https://www.toggl.com/api/v8/time_entries?start_date=2013-03-10T15%3A42%3A46%2B02%3A00&end_date=2013-03-12T15%3A42%3A46%2B02%3A00"
    # dates must be ISO 8601
    $timeEntriesUri = 'https://www.toggl.com/api/v8/time_entries'
    return Invoke-RestMethod -Uri $timeEntriesUri -Method Get -Headers $headers
}

Function Get-TglClients() {
    #todo get workspace if not gotten
    $workspaceClientsUri = 'https://www.toggl.com/api/v8/workspaces/'+$TglWorkspace.id+'/clients'
    $Tglclients = Invoke-RestMethod -Uri $workspaceClientsUri -Method Get -Headers $headers
    $TglClients
}

Function Get-TglProjects() {
    # todo figure out types, if I filter the project list, I lost type info as in
    #  foreach ($p in ($projects.cid -eq 884250))  { $p, $p.GetType() }
    $workspaceProjectsUri = 'https://www.toggl.com/api/v8/workspaces/'+ $TglWorkspace.id+'/projects'
    $global:TglProjects = Invoke-RestMethod -Uri $workspaceProjectsUri -Method Get -Headers $headers
    $global:TglProjects
}

Function Set-TglProject() {
    # find project based on provided parameters
    # set the project and return the id
    return "not implemented"
}

Function Get-TglDetailedReport() {
    $detailedReportUri = 'https://toggl.com/reports/api/v2/details?user_agent=phil@intellitect.com&workspace_id=' + $TglWorkspace.id
    $report = Invoke-RestMethod -Uri $detailedReportUri -Method Get -Headers $headers
    $report
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

    $addTimeEntryUri = "https://www.toggl.com/api/v8/time_entries"
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


