$checkmark = [char]0x2713;

function Copy-DirectoryIfExist {
        <#
.SYNOPSIS
    Copies a named subdirectory's contents from a source root to an install root, 
    but only if the source subdirectory exists.
.DESCRIPTION
    This function verifies the existence of the full source path ($SourceRoot\$FolderName), 
    creates the destination path ($InstallRoot\$FolderName) if necessary, 
    and copies all contents recursively.
.PARAMETER SourceRoot
    The base directory containing the source subfolders (e.g., the path to your Git repository).
.PARAMETER InstallRoot
    The base directory where the files should be installed (e.g., the user's modules folder).
.PARAMETER FolderName
    The name of the subdirectory (e.g., 'plugins', 'bin', 'tabcompleters'). 
    The function uses this name to construct the full source and destination paths.
.EXAMPLE
    # Copies contents of C:\Project\tabcompleters to C:\Modules\tabcompleters
    Copy-DirectoryIfExist -SourceRoot "C:\Project" -InstallRoot "C:\Modules" -FolderName 'tabcompleters'

.EXAMPLE
    # Example using -Verbose
    Copy-DirectoryIfExist -SourceRoot $PSScriptRoot -InstallRoot $env:HOME -FolderName 'plugins' -Verbose
#>
        [CmdletBinding(SupportsShouldProcess = $true)]
        param(
                [Parameter(Mandatory = $true)]
                [string]$SourceRoot,

                [Parameter(Mandatory = $true)]
                [string]$InstallRoot,

                [Parameter(Mandatory = $true)]
                [string]$FolderName
        )

        # Construct the full source and destination paths
        $SourceDirectory = Join-Path $SourceRoot $FolderName
        $DestinationDirectory = Join-Path $InstallRoot $FolderName

        # Use -ShouldProcess for safety and -Verbose output
        if (-not $PSCmdlet.ShouldProcess("Copy directory contents from '$SourceDirectory' to '$DestinationDirectory'.")) {
                return
        }

        # 1. Check if the source directory exists
        if (-not (Test-Path -Path $SourceDirectory -PathType Container)) {
                # Keep this log for verbose mode when skipping a folder
                Write-Verbose "Skipping: Source folder '$SourceDirectory' not found."
                return
        }

        # 2. Ensure the destination directory exists (New-Item creates the directory structure if missing)
        if (-not (Test-Path -Path $DestinationDirectory -PathType Container)) {
                Write-Verbose "Creating destination folder: '$DestinationDirectory'."
        
                try {
                        New-Item -ItemType Directory -Force -Path $DestinationDirectory | Out-Null
                }
                catch {
                        Write-Error "Failed to create destination directory '$DestinationDirectory'. Error: $($_.Exception.Message)"
                        return
                }
        }
    
        # 3. Perform the copy operation
        Write-Verbose "Copying contents to '$DestinationDirectory'."
    
        try {
                # Copy-Item copies the contents (*) of the source path to the destination
                Copy-Item -Path "$SourceDirectory\*" -Destination $DestinationDirectory -Force -Recurse -ErrorAction Stop
        
                Write-Verbose "Copied contents of folder: $FolderName/"
        }
        catch {
                Write-Error "Failed to copy contents from '$SourceDirectory'. Error: $($_.Exception.Message)"
        }
}

function Get-RemoteZip {
        [CmdletBinding()]
        param(
                [Parameter(Mandatory = $true)]
                [string]$Url
        )

        Write-Verbose "Downloading from URL: $Url"
        Write-Host "Downloading latest version... " -NoNewline

        $tempZip = Join-Path $env:TEMP "grgx.zip"

        try {
                Invoke-WebRequest -Uri $Url -OutFile $tempZip -ErrorAction Stop
                Write-Host "$checkmark " -ForegroundColor Green -NoNewline
                Write-Host "Downloaded"
                Write-Verbose "Downloaded to $tempZip"
                return $tempZip
        }
        catch {
                Write-Error "Failed to download zip from '$Url'. Error: $($_.Exception.Message)"
                return $null
        }
}

function Expand-ReleaseZip {
        [CmdletBinding()]
        param(
                [Parameter(Mandatory = $true)]
                [string]$Path
        )

        Write-Verbose "Extracting: $Path"
        Write-Host "Extracting... " -NoNewline

        $tempDir = Join-Path $env:TEMP "grgx-extract"
        
        try {
                # Cleanup existing temp directory if present
                if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
                Expand-Archive -Path $Path -DestinationPath $tempDir -Force
    
                # $extractedRoot = Get-ChildItem $tempDir -Directory | Select-Object -First 1

                Write-Host "$checkmark " -ForegroundColor Green -NoNewline
                Write-Host "Extracted"
                Write-Verbose "Extracted to $tempDir"

                return $tempDir
        }
        catch {
                Write-Error "Failed to extract zip from '$Path'. Error: $($_.Exception.Message)"
                return $null
        }
}

function Show-GrgxLogo {
        <#
.SYNOPSIS
    Displays the GRGX logo in ASCII art.
.DESCRIPTION
    Outputs the GRGX ASCII logo using Write-Host for visual display.
.EXAMPLE
    Show-GrgxLogo
#>
        [CmdletBinding()]
        param()

        # ASCII Art for GRGX using a here-string for literal output
        $Logo = @'
+-------------------------------------------------------+
|                                                       |
|    ,adPPYb,d8  8b,dPPYba,   ,adPPYb,d8  8b,     ,d8   |
|   a8"    `Y88  88P'   "Y8  a8"    `Y88   `Y8, ,8P'    |
|   8b       88  88          8b       88     )888(      |
|   "8a,   ,d88  88          "8a,   ,d88   ,d8" "8b,    |
|    `"YbbdP"Y8  88           `"YbbdP"Y8  8P'     `Y8   |
|    aa,    ,88               aa,    ,88                |
|     "Y8bbdP"                 "Y8bbdP"      By grgsh   |
|                                                       |
+-------------------------------------------------------+
'@

        # Output the logo with a blank line for spacing
        Write-Host ""
        Write-Host $Logo
        Write-Host ""
}

Export-ModuleMember -Function Copy-DirectoryIfExist, Get-RemoteZip, Expand-ReleaseZip, Show-GrgxLogo
Export-ModuleMember -Variable checkmark