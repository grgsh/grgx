function Get-GrgxCompletions {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
        if (-not (Get-Module -Name GrgxConfig)) {
                Write-AppLog -Message "GrgxConfig module is not loaded. Cannot retrieve configuration." -LogLevel 'ERROR'
                return
        }

        # Ensure we have the directory (fallback to env or default if variable not found)
        $dir = if ($Config.ModulesDirectory) { $Config.ModulesDirectory } elseif ($Config.EnvModulesDirectory) { $Config.EnvModulesDirectory } else { $Config.DefaultModulesDirectory }

        if (Test-Path $dir) {
                Get-ChildItem "$dir\*.ps1" | Where-Object { $_.BaseName -like "$wordToComplete*" } | ForEach-Object {
                        $name = $_.BaseName
                        if ($name -match '\s') { "'$name'" } else { $name }
                }
        }
}

Export-ModuleMember -Function Get-GrgxCompletions