$GrgxRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Definition)

# Import the Grgx module (adjust path if structure changes)
$ModulePath = Join-Path $GrgxRoot 'lib\Grgx.psm1'
if (-not (Test-Path $ModulePath)) {
        Write-Host "Error: Grgx module not found at '$ModulePath'. Ensure the module is built correctly." -ForegroundColor Red
        exit 1
}
Import-Module $ModulePath

# Delegate to the module's core function, passing all args (it handles parsing internally)
Invoke-GrgxScript @args