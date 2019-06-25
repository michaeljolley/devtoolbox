$myModulePath = $env:PSModulePath.Split(";")[0]
$dest = [System.IO.Path]::Combine($myModulePath, "mjtools")
Remove-Item -Path $dest -Recurse -Force
