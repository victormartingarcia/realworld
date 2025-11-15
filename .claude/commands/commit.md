# /commit

## Summary

This command generates a high-quality, user-facing commit message using the GitHub CLI, based on the current staged and unstashed changes. The message summarizes the value-added impact of the code changes in a clear, concise, and professional format.

## Goals

1. ✅ Stash all files with `git add .`. Review all staged changes using `git diff --cached`
2. ✅ Summarize the changes from a **value-added** perspective — not just what changed, but why it matters
3. ✅ Format the message with:
   - A clear title line (max 72 characters)
   - A bulleted list of meaningful improvements or fixes
   - No unnecessary implementation detail unless it adds clarity
4. ✅ Create the commit using the GitHub CLI. Never mention claude nor attribute it, show it to the user and ask for confirmation.
5. ✅ Push to the current branch
6. ✅ In case the branch is `main` or not associated to any Pull Request in the Github repo, ask the users if we have to create one
7. ✅ In case the user accepts, create a Pull Request following a consistent messaging (check last PRs for inspiration)
8. ✅ Associate the PR to any open issue that is related to the changeset we are pushing

For all git and github interactions use the Github cli (`gh` shell command)

The commit should read as if written manually by a thoughtful, product-aware engineer.

*IMPORTANT:* *Never mention claude nor attribute the commits to it*!
