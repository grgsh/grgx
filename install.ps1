[CmdletBinding()]
param(
        [Parameter(Mandatory = $false, HelpMessage = "Use local source directory instead of downloading from remote.")]
        [switch]$Local
)

$invocationDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
Import-Module (Join-Path $invocationDirectory "Install.psm1")

$installDir = Join-Path $env:APPDATA "grgsh\grgx"
$pluginsDir = Join-Path $installDir "plugins"
$remoteZipUrl = "https://github.com/grgsh/grgx/archive/refs/heads/main.zip"

Write-Verbose "Install directory: $installDir"
Write-Verbose "Plugins directory: $pluginsDir"
Write-Verbose "Remote ZIP URL: $remoteZipUrl"



# 1. Get source directory
if ($Local) {
        Write-Host "Using local source for installation..."
        $sourceDir = $invocationDirectory
}
else {
        $zipDir = Get-RemoteZip -Url $remoteZipUrl
        Start-Sleep -Seconds 1

        $sourceDir = Expand-ReleaseZip -Path $zipDir
}
Write-Verbose "Source directory: $sourceDir"
Start-Sleep -Seconds 1

# 2. Create directories
if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Force -Path $installDir | Out-Null
        Write-Verbose "Created directory: $installDir"
}
if (-not (Test-Path $pluginsDir)) {
        New-Item -ItemType Directory -Force -Path $pluginsDir | Out-Null
        Write-Verbose "Created directory: $pluginsDir"
}


Write-Host "Copying source files... " -NoNewline

# 3. Copy lib/
Copy-DirectoryIfExist -SourceRoot $sourceDir -InstallRoot $installDir -FolderName "lib"

# 4. Copy completions/
Copy-DirectoryIfExist -SourceRoot $sourceDir -InstallRoot $installDir -FolderName "completions"
        
# 5. Copy plugins/
Copy-DirectoryIfExist -SourceRoot $sourceDir -InstallRoot $installDir -FolderName "plugins"

# 6. Copy bin/
Copy-DirectoryIfExist -SourceRoot $sourceDir -InstallRoot $installDir -FolderName "bin"

Write-Host "$checkmark " -ForegroundColor Green -NoNewline
Write-Host "Copied"
Start-Sleep -Seconds 1

# 7. Add to PATH (include bin/ if present)
Write-Host "Verifying PATH... " -NoNewline
$pathToAdd = Join-Path $installDir "bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$pathToAdd*") {
        [Environment]::SetEnvironmentVariable("Path", "$userPath;$pathToAdd", "User")

        Write-Host "$checkmark " -ForegroundColor Green -NoNewline
        Write-Host "Verified"

        Write-Host "Added $pathToAdd to User PATH."
        Write-Host "You may need to restart your terminal for PATH changes to take effect."
}
else {
        Write-Host "$checkmark " -ForegroundColor Green -NoNewline
        Write-Host "Verified"

        Write-Verbose "$pathToAdd is already in PATH."
}

Start-Sleep -Seconds 2

# 8. Instructions
Show-GrgxLogo
Write-Host "`nInstallation Complete!"
Write-Host "----------------------"
Write-Host "1. Restart your terminal."
Write-Host "2. To enable tab completion, add this to your PowerShell profile (`$PROFILE`):"
Write-Host "   `"grgx-init`""
Write-Host "3. Place your scripts in $pluginsDir and run them with 'grgx <scriptname>'."