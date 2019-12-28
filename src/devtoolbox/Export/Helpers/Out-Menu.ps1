Function Out-Menu {
  [Alias("menu")]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [object[]]$Object,
    [string]$Header,
    [string]$Footer,
    [switch]$AllowCancel,
    [switch]$AllowMultiple
  )

  if ($input) {
    $Object = @($input)
  }

  Write-Host ""

  do {
    $prompt = New-Object System.Text.StringBuilder
    switch ($true) {
      { [bool]$Header -and $Header -notmatch '^(?:\s+)?$' } { $null = $prompt.Append($Header); break }
      $true { $null = $prompt.Append('Choose an option:') }
      $AllowCancel { $null = $prompt.Append(', or enter "c" to cancel.') }
      $AllowMultiple { $null = $prompt.Append('`nTo select multiple, enter numbers separated by a comma. EX: 1, 2') }
    }

    Write-Host $prompt.ToString()

    $nums = $Object.Count.ToString().Length
    for ($i = 0; $i -lt $Object.Count; $i++) {
      Write-Host "$("{0:D$nums}" -f ($i+1)). $($Object[$i])"
    }

    if ($Footer) {
      if ($Footer.EndsWith(".")) {
        $Footer = $Footer.Replace(".",":")
      }
      Write-Host $Footer " " -NoNewLine
    }

    if ($AllowMultiple) {
      $answers = @(Read-Host).Split(",").Trim()

      if ($AllowCancel -and $answers -match 'c') {
        return
      }

      $ok = $true
      foreach ($ans in $answers) {
        if ($ans -in 1..$Object.Count) {
          $Object[$ans - 1]          
        }
        else {
          Write-Host "Not an option!" -ForegroundColor Red
          Write-Host ""
          $ok = $false
        }
      }
    }
    else {
      $answer = Read-Host

      if ($AllowCancel -and $answer -eq 'c') {
        return
      }

      $ok = $true
      if ($answer -in 1..$Object.Count) {
        $Object[$answer - 1]
      } 
      else {
        Write-Host "Not an option!" -ForegroundColor Red
        Write-Host ""
        $ok = $false
      }
    }
  } while (-not $ok)
}