# Sample usage

. .\Connect-Toggl.ps1

# dump detailed report data to CSV
Get-TglDetailedReport2 -UserAgent $useragent -Since $since -Until $until | Export-Csv "$($since.ToString("yyyy-mm-dd"))-details.csv" -NoTypeInformation

# display project id, client id, project name
Get-TglProjects | Select id, cid, name

# display details for projects with a name like including admin
$(Get-TglProjects).Where( {$_.name -like '*admin*'}) | Select id, cid, name



