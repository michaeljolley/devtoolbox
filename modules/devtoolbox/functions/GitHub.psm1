Function Invoke-GitHubRepository {
  [Alias('gh')]
  Param()

  $GitURL = (git config remote.origin.url)

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

Export-ModuleMember -Alias * -Function *
