$Script:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace "\.Tests\.", "."
. "$here\$sut"

Describe("Invoke-GitHubRepository") {
  $repoUrl = "https://github.com/MichaelJolley/devtoolbox"
  $repoSSH = "git@github.com:MichaelJolley/devtoolbox"

  It("Should open default browser to $repoUrl") {
    Mock -CommandName "git" -MockWith { return $repoUrl }
    Mock -CommandName "Start-Process" -MockWith {
      param($FilePath)
      $Script:cmd = $FilePath
    }
  }

  It("Should convert $repoSSH to $repoUrl") {
    Mock -CommandName "git" -MockWith { return $repoSSH }
    Mock -CommandName "Start-Process" -MockWith {
      param($FilePath)
      $Script:cmd = $FilePath
    }

    Invoke-GitHubRepository
    $cmd | Should -Be $repoUrl
  }
}