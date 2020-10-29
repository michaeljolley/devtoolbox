Remove-Module devtoolbox -Force -ErrorAction SilentlyContinue
$myModulePath = $IsMacOS ? $env:PSModulePath.Split(":")[0] : $env:PSModulePath.Split(";")[0]
$dest = [System.IO.Path]::Combine($myModulePath, "devtoolbox")
Remove-Item -Path $dest -Recurse -Force
