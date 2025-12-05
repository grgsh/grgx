# # Import sub-modules for configuration and utilities
# Import-Module (Join-Path $PSScriptRoot 'GrgxConfig.psm1')
# Import-Module (Join-Path $PSScriptRoot 'GrgxUtilities.psm1')

# Core function to invoke a user script from the modules directory
function Invoke-GrgxScript {
        [CmdletBinding()]
        param(
                [Parameter(Mandatory = $true, Position = 0)]
                [string]$ScriptName,
                [Parameter(ValueFromRemainingArguments = $true)]
                [string[]]$Arguments
        )

        Write-AppLog -Message "Starting script execution: '$ScriptName' with arguments: [$($Arguments -join ',')]" -LogLevel 'INFO'

        # Construct the full path to the script
        $ScriptPath = Join-Path $Config.ModulesDirectory "$ScriptName.ps1"

        # Check if the script exists and execute it
        if (Test-Path $ScriptPath) {
                & $ScriptPath @Arguments
        }
        else {
                Write-Host "Script '$ScriptName' not found.`n" -ForegroundColor Red
                Write-Host "Available scripts:"
                Get-ChildItem "$($Config.ModulesDirectory)\*.ps1" | ForEach-Object { Write-Host " - $($_.BaseName)" }
        
                Write-AppLog -Message "Tried to execute '$ScriptName' but it could not be found in $($Config.ModulesDirectory)." -LogLevel 'ERROR'
        }
}

# Export the main function and config for external use
Export-ModuleMember -Function Invoke-GrgxScript
Export-ModuleMember -Variable Config