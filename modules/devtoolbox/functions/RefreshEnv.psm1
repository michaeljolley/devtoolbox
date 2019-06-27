Function Invoke-RefreshEnvironment {
  [Alias("refreshenv")]
  [Alias("reload")]
  param()
  if ($IsWindows) {
    $SystemEnvironment = Get-Item "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment"
    $UserEnvironment = Get-Item "HKCU:\Environment"
    Push-Location Env:
    $SystemEnvironment | Select-Object -ExpandProperty Property | Where-Object {$_ -notlike "PS*"} | Foreach-Object {
      Set-Item -Path "$_" $SystemEnvironment.GetValue($_)
    }
    $UserEnvironment | Select-Object -ExpandProperty Property | Where-Object {$_ -notlike "PS*"} | Foreach-Object {
      if ($_ -eq "Path") {
        Set-Item -Path "$_" ((Get-Item Path).Value + ";" + $UserEnvironment.GetValue($_))
      }
      else {
        Set-Item -Path "$_" ($existing + $UserEnvironment.GetValue($_))
      }
    }
    Set-Item USERNAME $([Environment]::USERNAME)
    Pop-Location
  }
  if (Test-Path $PROFILE -ErrorAction SilentlyContinue) {
    & $PROFILE
  }
}