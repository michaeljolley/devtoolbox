$myModulePath = $IsMacOS ? $env:PSModulePath.Split(":")[0] : $env:PSModulePath.Split(";")[0]
$dest = New-Item -Path $myModulePath -Name devtoolbox -ItemType Directory -Force
Copy-Item -Path src\* -Recurse -Destination $dest -Force
Import-Module devtoolbox
