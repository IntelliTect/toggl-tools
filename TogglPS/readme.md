# Toggl PowerShell Tools

WIP: starting of a PowerShell module of Toggl utilties

## Getting Started
Start by loading Connect-Toggl into PowerShell context

```
. .\Connect-Toggl.ps1
```

Then, call 

```
Intialize-Toggl $apitoken
```

where $apitoken is your user api token. The api token can be found under "My Profile" in your Toggl account

## Using the utilities

Returns the body of the API response. typically this will be rendered as an array of custom objects representing each project.

```
$projects = Get-Projects
```
Returns all projects in the workspace


## References:
- [Toggl API Docs](https://github.com/toggl/toggl_api_docs)

