param(
    [string]$name,
    [string]$base = "main"
)

$branch = "$name"

git fetch origin

git worktree add $branch `
    -b $branch `
    --no-track "origin/$base"