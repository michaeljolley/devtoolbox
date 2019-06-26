Function Refresh-Environment {
  [Alias("refreshenv")]
  [Alias("reload")]
  param()
  $env = @()
  if ($IsWindows) {
    $SystemEnvironment = Get-Item "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment"
    $UserEnvironment = Get-Item "HKCU:\Environment"
    $SystemEnvironment | Select-Object -ExpandProperty Property | Foreach-Object {
      Set-Item -Path "Env:\$_" = $SystemEnvironment.GetValue($_)
    }
    $UserEnvironment | Select-Object -ExpandProperty Property | Foreach-Object {
      Set-Item -Path "Env:\$_" = $UserEnvironment.GetValue($_)
    }
  }
  if (Test-Path $PROFILE -ErrorAction SilentlyContinue) {
    . $PROFILE
  }
}