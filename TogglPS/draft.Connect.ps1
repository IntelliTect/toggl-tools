$username = 'phil@intellitect.com'
$password = '***'
$apitoken = 'b842531c68f5f20ccc091803d5584140'

$headers = @{
    'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($apitoken + ':api_token'));
    # 'Content-Type' = 'application/json'
} #end headers hash table

# get info about me
$me = invoke-restmethod -URI 'https://www.toggl.com/api/v8/me' -Method Get -Headers $headers


