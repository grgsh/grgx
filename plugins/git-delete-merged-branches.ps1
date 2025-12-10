git branch --merged | Select-String -NotMatch '^\*' | ForEach-Object { ($_ -split '\s+')[1] } | ForEach-Object { git branch -d $_ } 
