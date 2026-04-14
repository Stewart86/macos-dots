Work on ONE task denoted with a checkbox `[ ]` and end response normally.

## Workflow

1. Study `progress.txt` - check **Codebase Patterns** section first
2. Study `IMPLEMENTATION_PLAN.md`
3. Decide which task to work on next. This should be the one YOU decide has the highest priority, not necessarily the first in the list
4. Implement that single task
5. Run quality checks: {{VALIDATION_COMMANDS}}
6. If pass:
   - Edit `IMPLEMENTATION_PLAN.md` to mark task `[x]`
   - Append to `progress.txt`
   - Commit: `git add -A && git commit -m "feat: [Task ID] - [description]"`
7. If fail: fix and retry until green

## Quality Requirements

- ALL commits must pass: {{VALIDATION_COMMANDS}}
- Do NOT commit broken code
- Follow existing code patterns
- Keep changes focused and minimal

## Progress Log Format

APPEND to `progress.txt` after each task:

```
## [Task ID] - DONE
- What: [Brief description]
- Files: [Files changed]
- Learned: [Patterns discovered, gotchas]
---
```

If stuck:

1. Log what you tried and why it failed
2. Try a different approach
3. If task is too complex, split it in IMPLEMENTATION_PLAN.md
4. End the task without commit or update progress
5. we will revisit on next iteration

## Codebase Patterns

Add discoveries to TOP of `progress.txt` in the **Codebase Patterns** section:

```
## Codebase Patterns
- {{PATTERN_1}}
- {{PATTERN_2}}
```

## Stop Condition

- After several failed attempts, do not mark task done, end response normally
- MORE `[ ]` tasks remain: end response normally
- ALL tasks are `[x]`: output `<promise>COMPLETE</promise>` on its own line

## Project Info

```
{{PROJECT_STRUCTURE}}
```

Validation: {{VALIDATION_COMMANDS}}

## Important

- ONE task per iteration
- mark task done only after passing validation
- Commit on task completion only
- Keep CI green, even if not related to your changes
- Read Codebase Patterns before starting
