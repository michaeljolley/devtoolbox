[CmdletBinding()]
param
(
  [Parameter(Mandatory = $true, Position = 0)]
  [System.IO.DirectoryInfo]
  [string]
  $ModulePath
)

function GetFunctionAliases ($functions) {
  $aliases = @()
  foreach ($function in $functions) {
    $definition = (Get-Command $function).Definition.Split("`n")
    $paramStartLine = ($definition | Select-String -Pattern "^\s*[Pp]aram").LineNumber
    $aliases += ($definition | Select-String -Pattern "(?<!#\s*)\[Alias\([\""|'](\w+)[\""|']\)\]" | Where-Object LineNumber -LT $paramStartLine).Matches | ForEach-Object { if ($_.Groups.Count -gt 0) { $_.Groups[1].Value } }
  }
  return $aliases
}

if (-not (Test-Path "$ModulePath.psd1")) {
  Write-Error "Could not find module $ModulePath" -ErrorAction Stop
}

Push-Location $ModulePath

# Add all the functions this module uses into our scope
Get-ChildItem *.ps1 -Path Export, Private -Recurse | Foreach-Object {
  . $_.FullName
}

$currentMetadata = Test-ModuleManifest -Path "$ModulePath.psd1"

$functionsToExport = Get-ChildItem *.ps1 -Path Export -Recurse | `
  # Get the name of the function  
  Select-Object -ExpandProperty BaseName | `
  Sort-Object

Update-ModuleManifest -Path "$ModulePath.psd1" `
  -RootModule "$ModulePath.psm1" `
  -FunctionsToExport $functionsToExport `
  -AliasesToExport (GetFunctionAliases $functionsToExport)

Test-ModuleManifest -Path "$ModulePath.psd1"

# Remove the functions loaded during the manifest update
Get-ChildItem *.ps1 -Path Export, Private -Recurse | ForEach-Object {
  Remove-Item -Path "Function:\$($_.BaseName)" -ErrorAction SilentlyContinue
  Remove-Variable * -Scope Script -ErrorAction SilentlyContinue
}

Pop-Location
