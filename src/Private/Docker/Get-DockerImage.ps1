function Get-DockerImage {
  <#
    .SYNOPSIS
    Get the images currently available from docker

    .PARAMETER All
    Return all images - including intermediate images (hidden by default)

    .PARAMETER NoTrunc
    Returns the full ID - no truncated IDs
  #>
  [Alias("gdi")]
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline = $true)]
    [string]
    $Image,
    [Parameter()]
    [Alias("a")]
    [switch]
    $All,
    [Parameter()]
    [Alias("nt")]
    [switch]
    $NoTrunc
  )

  BEGIN {
    Update-TypeData -TypeName Docker.Image -DefaultDisplayPropertySet 'Repository','Tag','Image Id','Created','Size' -Force
  }

  PROCESS {
    if (-not [string]::IsNullOrWhiteSpace($Image)) {
      $ImagesToProcess += Invoke-DockerCommand image inspect $Image | ConvertFrom-Json
    }
    else {
      $params = @("image","ls")  
      if ($All) {
        $params += "-a"
      }
      $imageIds = (Invoke-DockerCommand @params | Select-String -Pattern "\s[\d|\w]{12}").Matches.Groups.Value.Trim()
      $ImagesToProcess = Invoke-DockerCommand image inspect $imageIds | ConvertFrom-Json
    }
  }

  END {    
    foreach ($i in $ImagesToProcess) {
      $repo = $(if ($i.RepoTags.Length -gt 0) { $i.RepoTags[0].Split(":")[0] } else { "<None>" })
      $tag = $(if ($i.RepoTags.Length -gt 0) { $i.RepoTags[0].Split(":")[1] } else { "<None>" })
      $imgid = $(if ($NoTrunc.IsPresent) {$i.Id} else {$i.Id.Substring(7,12)})
      [PSCustomObject]@{
        PSTypeName = "Docker.Image"
        Repository = $repo
        Tag = $tag
        "Image Id" = $imgid
        "Parent Id" = $(if ($NoTrunc.IsPresent) {$i.Parent} else {if($i.Parent -ne "") {$i.Parent.Substring(7,12)}})
        Created = [DateTime]::Parse($i.Created)
        Size = "$([Math]::Round($i.Size/1000/1000,0,[System.MidpointRounding]::AwayFromZero))MB"
        SizeOnDisk = "$([Math]::Round($i.Size/1MB,0,[System.MidpointRounding]::AwayFromZero))MB"
        Maintainer = $i.Config.Labels.maintainer
        Cmd = $i.Config.Cmd -join " "
        WorkingDir = $i.Config.WorkingDir
        Entrypoint = $i.Config.Entrypoint
        ExposedPorts = $i.Config.ExposedPorts.PSObject.Properties.Name
        User = $i.Config.User
        Name = $(if ($repo -ne "<None>" -and $tag -ne "<None>") { "$($repo):$($tag)" } else { $imgid })
      }
    }
  }
}
