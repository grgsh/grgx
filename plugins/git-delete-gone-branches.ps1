git fetch -p
git branch -vv | ForEach-Object { if ($_ -match '\[.*: gone\]') { $parts = $_.Trim() -split '\s+'; $branch = $parts[0]; if ($branch -ne '') { git branch -d $branch } } }