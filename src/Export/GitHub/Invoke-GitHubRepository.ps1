Function Invoke-GitHubRepository {
  [Alias('github')]
  Param(
    # Browse the branch
    [Parameter()]
    [switch]
    $Branch
  )

  $GitURL = (git config remote.origin.url)

  if ($Branch) {
    $CurrentBranch = (git branch --show-current)
    if (-not ((git branch -r).Trim() -contains "origin/$CurrentBranch")) {
      Write-Error "Git branch '$CurrentBranch' does not exist at $GitURL. Make sure you have pushed your branch and try again." -ErrorAction Stop
    }
    $GitURL += "/tree/$CurrentBranch"
  }

  if ($null -ne $GitURL -and
    $GitURL.Substring(0, 4).ToLower() -eq "http" -and
    $GitURL.ToLower().Contains("github")) {
    Start-Process -FilePath $GitURL
  }
  elseif ($GitURL.Substring(0,4) -match "git@*") {
    $GitURL = "https://" + $GitURL.Substring(4,$GitURL.Length - 4).Replace(":", "/")
    Start-Process -FilePath $GitURL
  }
  else {
    Write-Warning "Directory not tracked by GitHub"
  }
}
