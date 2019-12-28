$Export = @(Get-ChildItem -Path $PSScriptRoot\Export -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)

foreach ($import in @($Private + $Export)) {
  try {
    . $import.FullName
  }
  catch {
    Write-Error -Message "Failed to import function $($import.BaseName): $_"
  }
}

Export-ModuleMember -Function $Export.BaseName -Alias (Get-FunctionAliases $Export.BaseName)
