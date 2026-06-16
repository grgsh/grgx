param(
    [string]$name,
    [string]$base = "main"
)

$branch = "$name"

git fetch origin

# Check if branch exists on remote
if (git ls-remote --heads origin $branch) {
    # Add worktree for existing branch
    git worktree add $branch "origin/$branch"
} else {
    # Create new branch based on base branch
    git worktree add $branch `
        -b $branch `
        --no-track "origin/$base"
}