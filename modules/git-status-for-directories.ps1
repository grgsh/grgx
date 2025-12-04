# Get all directories in the current location
$directories = Get-ChildItem -Directory

# Define symbols for status
$checkmark = [char]0x2713
$cross = [char]0x2717

# Loop through each directory
foreach ($dir in $directories) {
        Write-Output "`nRunning for: '$($dir.FullName)'"

        # Check if it's a git repository
        if (Test-Path (Join-Path $dir.FullName ".git")) {
                # Check if there are any changes using git status --porcelain
                $status = git -C $dir.FullName status --porcelain

                if ($status) {
                        Write-Output "$cross Has changes"
                }
                else {
                        Write-Output "$checkmark Clean"
                }
        }
        else {
                Write-Output "Not a git repository"
        }
}