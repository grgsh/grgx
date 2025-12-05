$installDir = Join-Path $env:APPDATA ".grgh\grgx"
$modulesDir = Join-Path $installDir "modules"

Write-Host "Installing grgx suite to $installDir from LOCAL..."

# 1. Create directories
if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Force -Path $installDir | Out-Null
        Write-Host "Created directory: $installDir"
}
if (-not (Test-Path $modulesDir)) {
        New-Item -ItemType Directory -Force -Path $modulesDir | Out-Null
        Write-Host "Created directory: $modulesDir"
}

# 2. Download and Extract
try {
        $sourceDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

        # 3. Copy files
        $filesToCopy = (Get-ChildItem -Path $sourceDir -Include grgx*.ps1, grgx*.psm1 -Recurse).Name

        foreach ($file in $filesToCopy) {
                $src = Join-Path $sourceDir $file
                if (Test-Path $src) {
                        Copy-Item -Path $src -Destination $installDir -Force
                        Write-Host "Copied $file"
                }
                else {
                        Write-Warning "File not found: $file"
                }
        }

        # 4. Copy module scripts
        $moduleSrc = Join-Path $sourceDir "modules"
        if (Test-Path $moduleSrc) {
                Copy-Item -Path "$moduleSrc\*" -Destination $modulesDir -Force -Recurse
                Write-Host "Copied module scripts"
        }

}
catch {
        Write-Error "Installation failed: $_"
        exit 1
}

# 5. Add to PATH
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$installDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$userPath;$installDir", "User")
        Write-Host "Added $installDir to User PATH."
        Write-Host "You may need to restart your terminal for PATH changes to take effect."
}
else {
        Write-Host "$installDir is already in PATH."
}

# 6. Instructions
Write-Host "`nInstallation Complete!"
Write-Host "----------------------"
Write-Host "1. Restart your terminal."
Write-Host "2. To enable tab completion, add this to your PowerShell profile (`$PROFILE`):"
Write-Host "   . `"$installDir\grgx-init.ps1`""