$defaultModulesDir = Join-Path $PSScriptRoot "modules"
$modulesDir = if ($env:GRGX_DIR) { $env:GRGX_DIR } else { $defaultModulesDir }

function Get-GrgxCompletions {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
        # Ensure we have the directory (fallback to env or default if variable not found)
        $dir = if ($modulesDir) { $modulesDir } elseif ($env:GRGX_DIR) { $env:GRGX_DIR } else { $defaultModulesDir }

        if (Test-Path $dir) {
                Get-ChildItem "$dir\*.ps1" | Where-Object { $_.BaseName -like "$wordToComplete*" } | ForEach-Object {
                        $name = $_.BaseName
                        if ($name -match '\s') { "'$name'" } else { $name }
                }
        }
}

$grgxCompleter = { Get-GrgxCompletions $commandName $parameterName $wordToComplete $commandAst $fakeBoundParameters }