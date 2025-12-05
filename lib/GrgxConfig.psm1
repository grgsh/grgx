$Script:GrgxRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$Script:DefaultModulesDirectory = Join-Path $Script:GrgxRoot "plugins"
$Script:ModulesDirectory = if ($env:GRGX_DIR) { $env:GRGX_DIR } else { $Script:DefaultModulesDirectory }
$Script:LogFile = Join-Path $Script:GrgxRoot "grgx.log"

$Script:Config = @{
        GrgxRoot                = $Script:GrgxRoot
        ModulesDirectory        = $Script:ModulesDirectory
        DefaultModulesDirectory = $Script:DefaultModulesDirectory
        LogFile                 = $Script:LogFile
}

Export-ModuleMember -Variable Config