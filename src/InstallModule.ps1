$myModulePath = $env:PSModulePath.Split(";")[0]
Copy-Item -Recurse -Path devtoolbox -Destination $myModulePath -Container -Force
Import-Module devtoolbox
