$Script:DefaultModulesDirectory = Join-Path $PSScriptRoot "modules"
$Script:ModulesDirectory = if ($env:GRGX_DIR) { $env:GRGX_DIR } else { $Script:DefaultModulesDirectory }
$Script:LogFile = Join-Path $PSScriptRoot "grgx.log"

$Script:Config = @{
        ModulesDirectory        = $Script:ModulesDirectory
        DefaultModulesDirectory = $Script:DefaultModulesDirectory
        LogFile                 = $Script:LogFile
}

Export-ModuleMember -Variable Config