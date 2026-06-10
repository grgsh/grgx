param(
    [string]$repo
)

$url = "$repo"

# 1. Clone the repo into a hidden .bare folder
git clone --bare $url .bare

# 2. Tell the root folder where the Git history is hidden
echo "gitdir: ./.bare" > .git

# 3. Fix the fetch configuration to see all remote branches
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"


###
# Source: https://dev.to/metal3d/git-worktree-like-a-boss-2j1b
###