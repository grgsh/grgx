param(
        [Parameter(Mandatory = $true)]
        [ArgumentCompleter({ Get-GrgxCompletions $commandName $parameterName $wordToComplete $commandAst $fakeBoundParameters })]
        [string]$ScriptName,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
)

# Load the completer
. "$PSScriptRoot\grgx-completer.ps1"

# Construct the full path to the script
$scriptPath = Join-Path $modulesDir "$ScriptName.ps1"

# Check if the script exists and execute it
if (Test-Path $scriptPath) {
        #Write-Host "Executing script: '$scriptPath'";
        & $scriptPath @Arguments
}
else {
        Write-Error "Script '$ScriptName' not found in $modulesDir. Please ensure the script exists and has a .ps1 extension."
}