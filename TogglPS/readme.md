# Toggl PowerShell Tools

WIP: starting of a PowerShell module of Toggl utilties

# Getting Started
Start by loading Connect-Toggl into PowerShell context
```
. .\Connect-Toggl.ps1
```

Then, call 
```
Intialize-Toggl $apitoken
```

where $apitoken is your user api token. The api token can be found under "My Profile" in your Toggl account
This creates a global security header that will be used in other calls in the api
Not calling Initialize-Toggl first will cause all other calls to fail

# Using the utilities
Most of the functions return the body of a Toggl API response as a Powershell custom object or array of custom objeccts.

Output from a function is suitable for use in the Powershell pipeline

## Common Parameters

UserAgent is the email of the user making the calls

## Examples

```
$projects = Get-Projects
```
Returns all projects in the workspace into the $projects variable

```
$clients = Get-Clients
```
Returns all clients in the workspace in the $clients variale

```
Get-TglDetailedReport2 -UserAgent "phil@intellitect.com" -Since "1/1/2021 -Until "1/31/2021" | Export-Csv "2021-01-01-details.csv" -NoTypeInformation
```
Returns all time entries from 1/1/2021 to 1/31/2021 and saves them to 2021-01-01-details.csv

# References:
- [Toggl API Docs](https://github.com/toggl/toggl_api_docs)

