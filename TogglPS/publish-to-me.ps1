$targetPath = "$($env:PSModulePath.Split(";")[0])\TogglPS\"
if (-Not $(Test-Path $targetPath)) {
    New-Item $targetPath -ItemType "Directory" -Force
}
Copy-Item "Connect-Toggl.ps1" $(Join-Path $TargetPath "TogglPS.psm1")
Copy-Item "readme.md" $targetPath