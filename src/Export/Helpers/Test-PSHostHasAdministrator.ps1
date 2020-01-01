function Test-PSHostHasAdministrator {
  <#
    .SYNOPSIS
    Check to see if the current user is an administrator
  #>
  [Alias("IsAdmin")]
  param()
  $p = New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())
  if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    return $true
  }
  else {
    return $false
  }
  return $false
}