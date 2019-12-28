[CmdletBinding()]
param
(
  [Parameter(Mandatory = $true, Position = 0)]
  [System.IO.DirectoryInfo]
  [string]
  $ModulePath,
  [Parameter(Mandatory = $false)]
  [switch]
  $Major
)

function GetVersionInfo ($version, $type) {
  switch ($type) {
    "Major" {
      return "$($version.Major + 1).0.0"
    }
    "Minor" {
      return "$($version.Major).$($version.Minor + 1).0"
    }
    "Build" {
      return "$($version.Major).$($version.Minor).$($version.Build + 1)"
    }
  }
}

function GetFunctionAliases ($functions) {
  $aliases = @()
  foreach ($function in $functions) {
    $definition = (Get-Command $function).Definition.Split("`n")
    $paramStartLine = ($definition | Select-String -Pattern "^\s*[Pp]aram").LineNumber
    $aliases += ($definition | Select-String -Pattern "(?<!#\s*)\[Alias\([\""|'](\w+)[\""|']\)\]" | Where-Object LineNumber -LT $paramStartLine).Matches | ForEach-Object {if ($_.Groups.Count -gt 0) { $_.Groups[1].Value }}
  }
  return $aliases
}

if (-not (Test-Path $ModulePath)) {
  Write-Error "Could not find module $ModulePath" -ErrorAction Stop
}

Push-Location $ModulePath

# Add all the functions this module uses into our scope
Get-ChildItem *.ps1 -Path Export,Private -Recurse | Foreach-Object {
  . $_.FullName
}

$currentMetadata = Test-ModuleManifest -Path "$ModulePath.psd1"

$functionsToExport = Get-ChildItem *.ps1 -Path Export -Recurse | `
  # Get the name of the function  
  Select-Object -ExpandProperty BaseName | `
  Sort-Object

# We are requesting a major bump
if ($Major.IsPresent) {
  $version = GetVersionInfo $currentMetadata.Version "Major"
}
# There are new functions added to the module, bump the minor
elseif ($functionsToExport.Count -gt $currentMetadata.ExportedCommands.Count) {
  $version = GetVersionInfo $currentMetadata.Version "Minor"
}
# No new functions were added so we assume we should bump the build
else {
  $version = GetVersionInfo $currentMetadata.Version "Build"
}

Update-ModuleManifest -Path "$ModulePath.psd1" `
  -RootModule "$ModulePath.psm1" `
  -FunctionsToExport $functionsToExport `
  -AliasesToExport (GetFunctionAliases $functionsToExport) `
  -ModuleVersion $version

Test-ModuleManifest -Path "$ModulePath.psd1"

# Remove the functions loaded during the manifest update
Get-ChildItem *.ps1 -Path Export,Private -Recurse | ForEach-Object {
  Remove-Item -Path "Function:\$($_.BaseName)" -ErrorAction SilentlyContinue
  Remove-Variable * -Scope Script -ErrorAction SilentlyContinue
}

Pop-Location
