Function Invoke-ReverseSort {
  [Alias("Sort-Reverse")]
  # Sort is not an approved verb... Not sure of better one that is an approved verb. Will just leave this comment with link for future reference: https://github.com/PowerShell/PowerShell/issues/3370
  $rank = [int]::MaxValue
  $input | Sort-Object { (--(Get-Variable rank -Scope 1).Value) }
}