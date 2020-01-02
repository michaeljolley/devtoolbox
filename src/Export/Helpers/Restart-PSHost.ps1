Function Restart-PSHost {
  # [Alias("Reload")]
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param
  (
    [switch]$AsAdministrator,
    [switch]$Force
  )
  $proc = Get-Process -Id $PID
  $cmdArgs = [Environment]::GetCommandLineArgs() | Select-Object -Skip 1
  $params = @{FilePath = $proc.Path }
  if ($AsAdministrator) { $params.Verb = 'runas' }
  if ($cmdArgs) { $params.ArgumentList = $cmdArgs }
  if ($Force -or $PSCmdlet.ShouldProcess($proc.Name, "Restart the console")) {
    if ($host.Name -eq 'Windows PowerShell ISE Host' -and $psISE.PowerShellTabs.Files.IsSaved -contains $false) {
      if ($Force -or $PSCmdlet.ShouldProcess('Unsaved work detected?', 'Unsaved work detected. Save changes?', 'Confirm')) {
        foreach ($IseTab in $psISE.PowerShellTabs) {
          $IseTab.Files | ForEach-Object {
            if ($_.IsUntitled -and !$_.IsSaved) {
              $_.SaveAs($_.FullPath, [System.Text.Encoding]::UTF8)
            }
            elseif (!$_.IsSaved) {
              $_.Save()
            }
          }
        }
      }
      else {
        foreach ($IseTab in $psISE.PowerShellTabs) {
          $unsavedFiles = $IseTab.Files | Where-Object IsSaved -eq $false
          $unsavedFiles | ForEach-Object { $IseTab.Files.Remove($_, $true) }
        }
      }
    }
    Start-Process @params
    $proc.CloseMainWindow()
  }
}