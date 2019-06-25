$myModulePath = $env:PSModulePath.Split(";")[0]
$dest = [System.IO.Path]::Combine($myModulePath, "devtoolbox")
Remove-Item -Path $dest -Recurse -Force
