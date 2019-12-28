function Edit-HostsFile {
  <#
    .SYNOPSIS
    Opens the Windows hosts file in an editor.
  #>
  [Alias('hosts')]
  [CmdletBinding()]
  Param()
  # TO CONSIDER: Should we take a
  # Make sure we're on Windows...
  if ($PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows) {
    # Default editor to notepad.exe
    $fileEditor = 'notepad'
    # Find code if it exists. Giving preference to Stable code over insiders.
    if (Get-Command code -ErrorAction SilentlyContinue) {
      $fileEditor = 'code'
    }
    elseif (Get-Command code-insiders -ErrorAction SilentlyContinue) {
      $fileEditor = 'code-insiders'
    }
    # Use Start-Process to ensure that we're elevated. If already elevated, will not reprompt.
    Start-Process -FilePath $fileEditor -ArgumentList "C:\Windows\System32\drivers\etc\hosts" -Verb RunAs
  }
}