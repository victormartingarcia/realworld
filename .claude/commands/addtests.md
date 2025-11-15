# /addtests

## Summary

This command analyzes the pending changes in the repository and ensures that corresponding unit tests exist or are updated as needed. It follows the project's testing rules defined in `CLAUDE.md`.

## Goals

1. ✅ Identify all staged and unstashed changes relevant to the service layer
2. ✅ For each affected service:
   - Add new unit tests if new functionality was introduced
   - Update existing unit tests if the logic or API changed
   - Remove or adapt tests if code paths were deleted
3. ✅ Follow the testing rules in `CLAUDE.md`:
   - Test only the **service layer**
   - Mock all external dependencies (APIs, databases, queues, etc.)
   - Verify behavior, not implementation details
4. ✅ Generate clear, maintainable test code that matches project conventions (naming, structure, mocking style)
5. ✅ Stage the generated/updated test files with `git add`
6. ✅ Show the proposed test changes to the user for review and confirmation
7. ✅ Upon confirmation, run the test suite (`cd ~/Repos/realworld && make test`)
8. ✅ If tests pass, leave them staged for commit; otherwise, prompt the user to review and fix
9. ✅ Make sure the command `cd ~/Repos/realworld && make pre-commit` passes

## Notes

- Never generate integration tests; always unit tests for service logic only
- Keep tests **readable and purposeful**, focusing on value to developers
- Do not mention `claude` or attribute test generation to it
