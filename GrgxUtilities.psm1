function Write-AppLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [ValidateSet('INFO', 'WARNING', 'ERROR', 'DEBUG')]
        [string]$LogLevel = 'INFO'
    )

    # 1. Get the log path from the configuration object
    $LogPath = $Config.LogFile

    if (-not (Get-Module -Name GrgxConfig)) {
        $LogPath = Join-Path $PSScriptRoot "grgx.log";
    }

    if ([string]::IsNullOrEmpty($LogPath)) {
        Write-Host "Configuration variable 'LogFile' is missing or empty. Cannot log message."
        return
    }

    # 2. Format the log entry
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] [$LogLevel] :: $Message"

    # 3. Ensure the directory exists
    $LogDirectory = Split-Path -Parent $LogPath
    if (-not (Test-Path $LogDirectory)) {
        New-Item -Path $LogDirectory -ItemType Directory -Force | Out-Null
    }

    # 4. Write the message to the file (using -Append for new line)
    try {
        Add-Content -Path $LogPath -Value $LogEntry -ErrorAction Stop
    }
    catch {
        Write-Host "Failed to write to log file '$LogPath'. Error: $($_.Exception.Message)"
    }
}

Export-ModuleMember -Function Write-AppLog