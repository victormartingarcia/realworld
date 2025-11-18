---
name: commit-pending-changes
description: Ensure pending code changes meet expectations and commit to repository origin with descriptive commit message.  Use when the user asks for commiting changes.
---

# Commit Pending Changes

## Overview

This guide covers essential commit operations using command-line tools.

## Commit workflow

Copy this checklist and track your progress:

```
Commit Progress:
- [ ] Step 1: Add tests
- [ ] Step 2: Run pre-commit
- [ ] Step 3: Run tests
- [ ] Step 4: Commit
```

**Step 1: Add tests**

Execute claude `/addtests` command to add/edit/delete any tests to comply with project's testing guidelines if needed.

**Step 2: Run pre-commit**

Execute `make pre-commit` on repository's root path. It should be green, always fixing underlying issues. Only supress/ignore any rule with user's explicit approval.

**Step 3: Run tests**
Execute `make test` on repository's root path. It should be green, so you should fix any failing test following project's testing guidelines.

**Step 4: Commit**
Execute `/commit` claude code custom command to generate a meaningful commit message, push to origin and create Pull Request if needed.
