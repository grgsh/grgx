# Setup script for grgx command completion
# Run this in your PowerShell profile to enable tab completion for grgx

# Load the completer definitions
. "$PSScriptRoot\grgx-completer.ps1"

# Register the argument completer for the grgx command
Register-ArgumentCompleter -CommandName grgx -ScriptBlock $grgxCompleter

Write-Host "grgx tab completion has been set up!"