$myModulePath = $env:PSModulePath.Split(";")[0]
$dest = [System.IO.Path]::Combine($myModulePath, "MJ-Aliases")
Remove-Item -Path $dest -Recurse -Force