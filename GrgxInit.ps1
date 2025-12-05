$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

Import-Module (Join-Path $ScriptRoot "src/GrgxConfig.psm1")
Import-Module (Join-Path $ScriptRoot "src/GrgxUtilities.psm1")
Import-Module (Join-Path $ScriptRoot "src/GrgxCompletions.psm1")

Register-ArgumentCompleter -CommandName grgx, grgx.ps1 -ScriptBlock {
        Get-GrgxCompletions $commandName $parameterName $wordToComplete $commandAst $fakeBoundParameters
}

Write-Host "$([char]0x2713) grgx initialized"