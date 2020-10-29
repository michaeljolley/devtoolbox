function Get-DockerContainer {
  param
  (
    [Parameter(ValueFromPipeline = $true)]
    [string]
    $Container,
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
    Update-TypeData -TypeName Docker.Container -DefaultDisplayPropertySet 'Container Id','Image','Command','Created','Status','Ports','Names' -Force
  }

  PROCESS {
    if (-not [string]::IsNullOrWhiteSpace($Container)) {
      $ContainersToProcess += Invoke-DockerCommand container inspect $Container | ConvertFrom-Json
    }
    else {
      $params = @("container","ps")
      if ($All.IsPresent) {
        $params += "-a"
      }
      $containerIds = (Invoke-DockerCommand @params | Select-String -Pattern "^[\d|\w]{12}").Matches.Groups.Value
      $ContainersToProcess = Invoke-DockerCommand container inspect -s $containerIds | ConvertFrom-Json
    }
  }

  END {
    foreach ($c in $ContainersToProcess) {
      [PSCustomObject]@{
        PSTypeName = "Docker.Container"
        "Container Id" = $(if ($NoTrunc.IsPresent) {$c.Id} else {$c.Id.Substring(0, 12)})
        Image = $c.Config.Image
        Command = $c.Config.Entrypoint -join ";"
        Created = [DateTime]::Parse($c.Created)
        Status = [DateTime]::UtcNow-[DateTime]::Parse($c.State.StartedAt)
        State = $c.State.Status
        Ports = $c.Config.ExposedPorts.PSObject.Properties.Name
        Names = $c.Name.Substring(1)
        Size = "$([Math]::Round($c.SizeRW,0,[System.MidpointRounding]::AwayFromZero))B (virtual $([Math]::Round($c.SizeRootFs/1MB,0,[System.MidpointRounding]::AwayFromZero))MB)"        
      }
    }
  }
}
