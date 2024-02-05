$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$dst = $here -replace "\\_build", "\dist"
$src = $here -replace "\\_build", "\src"
if (Test-Path $dst) { Remove-Item -Path $dst -Recurse -Force }
Get-ChildItem -Path $src -Exclude *.Tests.ps1 -Recurse | Where-Object FullName -NotLike "*mocks*" | ForEach-Object {
  $destination = $_.FullName -replace "\\src", "\dist"
  Copy-Item -Path $_.FullName -Destination $destination -Force
}
Write-Line "Build complete."