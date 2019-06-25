$myModulePath = $env:PSModulePath.Split(";")[0]
$dest = [System.IO.Path]::Combine($myModulePath, "MJ-Aliases")
New-Item -Path $dest -ItemType Directory -ErrorAction SilentlyContinue
Get-ChildItem -Filter *.ps* | Where-Object Name -NotLike "*installmodule.ps1" | Copy-Item -Destination $dest
