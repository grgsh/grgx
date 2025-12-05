[CmdletBinding()]
param(
)

$InvocationDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
Import-Module (Join-Path $InvocationDirectory "Install.psm1")

$installDir = Join-Path $env:APPDATA "grgsh\grgx"
$pluginsDir = Join-Path $installDir "plugins"

Write-Host "Installing grgx suite to $installDir from LOCAL (restructured)..."


# 1. Create directories
if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Force -Path $installDir | Out-Null
        Write-Host "Created directory: $installDir"
}
if (-not (Test-Path $pluginsDir)) {
        New-Item -ItemType Directory -Force -Path $pluginsDir | Out-Null
        Write-Host "Created directory: $pluginsDir"
}

# 2. Get source directory
$sourceDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# 3. Copy lib/
Copy-DirectoryIfExist -SourceRoot $sourceDir -InstallRoot $installDir -FolderName "lib"

# 4. Copy completions/
Copy-DirectoryIfExist -SourceRoot $sourceDir -InstallRoot $installDir -FolderName "completions"
        
# 5. Copy plugins/
Copy-DirectoryIfExist -SourceRoot $sourceDir -InstallRoot $installDir -FolderName "plugins"

# 6. Copy bin/
Copy-DirectoryIfExist -SourceRoot $sourceDir -InstallRoot $installDir -FolderName "bin"

# 7. Add to PATH (include bin/ if present)
$pathToAdd = Join-Path $installDir "bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$pathToAdd*") {
        [Environment]::SetEnvironmentVariable("Path", "$userPath;$pathToAdd", "User")
        Write-Host "Added $pathToAdd to User PATH."
        Write-Host "You may need to restart your terminal for PATH changes to take effect."
}
else {
        Write-Host "$pathToAdd is already in PATH."
}

# 8. Instructions
Write-Host "`nInstallation Complete!"
Write-Host "----------------------"
Write-Host "1. Restart your terminal."
Write-Host "2. To enable tab completion, add this to your PowerShell profile (`$PROFILE`):"
Write-Host "   `"grgx-init`""
Write-Host "3. Place your scripts in $pluginsDir and run them with 'grgx <scriptname>'."