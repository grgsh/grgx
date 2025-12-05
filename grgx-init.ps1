$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

Import-Module (Join-Path $ScriptRoot "GrgxConfig.psm1")
Import-Module (Join-Path $ScriptRoot "GrgxUtilities.psm1")
Import-Module (Join-Path $ScriptRoot "GrgxCompletions.psm1")

Get-Command Get-GrgxCompletions

Register-ArgumentCompleter -CommandName grgx, grgx.ps1 -ScriptBlock {
        Get-GrgxCompletions $commandName $parameterName $wordToComplete $commandAst $fakeBoundParameters
}

# Write-Host "grgx tab completion initialized. the new way"