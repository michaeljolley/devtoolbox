Function Get-DockerComposeService {
  param
  (
    [Parameter(Mandatory = $true)]
    [string]$Path
  )
  if (-not (Test-Path $Path)) {
    throw
  }
  $file = Get-Content (Convert-Path $Path)
  $categories = $file | Select-String -Pattern "^\w+:"
  $service = $categories | Where-Object {$_.Line -like "services:*"}
  $serviceIdx = $categories.IndexOf($service)
  $startLine = ($categories[$serviceIdx] | Select-Object -ExpandProperty LineNumber)
  $endLine = $(if ($serviceIdx -lt $categories.Length - 1) {$categories[$serviceIdx+1] | Select-Object -ExpandProperty LineNumber} else {$file.Count})
  $file | Select-Object -Skip $startLine -First ($endLine - $startLine) | Select-String -Pattern "^\s{2}\w+:" | Select-Object @{Name="Service";Expression={$_.Line.Trim().Replace(":","")}} | Sort-Object -Property Service
}