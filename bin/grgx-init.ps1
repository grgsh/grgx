$GrgxRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Definition)

Import-Module (Join-Path $GrgxRoot "lib/GrgxConfig.psm1")
Import-Module (Join-Path $GrgxRoot "lib/GrgxUtilities.psm1")
Import-Module (Join-Path $GrgxRoot "completions/GrgxTabCompletions.psm1")

Register-ArgumentCompleter -CommandName grgx, grgx.ps1 -ScriptBlock {
        Get-GrgxCompletions $commandName $parameterName $wordToComplete $commandAst $fakeBoundParameters
}

$checkmark = [char]0x2713;
Write-Host "$checkmark " -ForegroundColor Green -NoNewline
Write-Host "grgx initialized"