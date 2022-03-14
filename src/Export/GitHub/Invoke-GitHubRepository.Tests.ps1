$Script:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace "\.Tests\.", "."
. "$here\$sut"

Describe("Invoke-GitHubRepository") {
  $repoUrl = "https://github.com/MichaelJolley/devtoolbox"
  $repoSSH = "git@github.com:MichaelJolley/devtoolbox"

  BeforeAll {
    # Override git.exe file so we can mock it within our tests
    function git {
      param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $PassThruArgs
      )
    }
  }

  It("Should open default browser to $repoUrl") {
    Mock -CommandName "git" -MockWith { return $repoUrl }
    Mock -CommandName "Start-Process" -MockWith {
      param($FilePath)
      $Script:cmd = $FilePath
    }

    Invoke-GitHubRepository
    $cmd | Should -Be $repoUrl
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
  
  It("Should open default browser to $repoURL/tree/vnext") {
    Mock -CommandName "git" -ParameterFilter { $PassThruArgs[0] -eq "config" } -MockWith { return $repoUrl }
    Mock -CommandName "git" -ParameterFilter { $PassThruArgs[0] -eq "branch" -and $PassThruArgs[1] -eq "--show-current" } -MockWith { return "vnext" }
    Mock -CommandName "git" -ParameterFilter { $PassThruArgs[0] -eq "branch" -and $PassThruArgs[1] -eq "-r" } -MockWith { return @("origin/vnext") }
    Mock -CommandName "Start-Process" -MockWith {
      param($FilePath)
      $Script:cmd = $FilePath
    }

    Invoke-GitHubRepository -Branch
    $cmd | Should -Be ($repoUrl + "/tree/vnext")
  }

  It("Should throw if branch doesn't exist") {
    Mock -CommandName "git" -ParameterFilter { $PassThruArgs[0] -eq "config" } -MockWith { return $repoUrl }
    Mock -CommandName "git" -ParameterFilter { $PassThruArgs[0] -eq "branch" -and $PassThruArgs[1] -eq "--show-current" } -MockWith { return "vnext" }
    Mock -CommandName "git" -ParameterFilter { $PassThruArgs[0] -eq "branch" -and $PassThruArgs[1] -eq "-r" } -MockWith { return @("origin/main") }
    Mock -CommandName "Start-Process" -MockWith {}

    { Invoke-GitHubRepository -Branch } | Should -Throw -ExpectedMessage "Git branch 'vnext' does not exist at $repoUrl"
  }
}