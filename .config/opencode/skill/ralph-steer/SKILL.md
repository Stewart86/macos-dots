---
name: ralph-steer
description: Steer the Ralph Loop by adding corrections, patterns, or new tasks. Use when you see the AI doing something wrong and need to course-correct.
license: MIT
compatibility: opencode
metadata:
  workflow: ralph-loop
  audience: developers
---

# Ralph Steer Skill

Use this skill to course-correct the Ralph Loop during HITL (human-in-the-loop) sessions.

## When to Use

- AI used wrong API/pattern
- AI is going in wrong direction
- You noticed a better approach
- Need to add/remove/reprioritize tasks
- Want to capture a learning for future iterations

## What I Do

Based on your feedback, I will:
1. Add a learning to `progress.txt` (Codebase Patterns section)
2. Add/modify tasks in `IMPLEMENTATION_PLAN.md` if needed
3. The next iteration will read these and self-correct

---

## Correction Types

### 1. Pattern Correction

**You say:** "Use gtk4:: not gtk:: for imports"

**I add to progress.txt:**
```markdown
## Codebase Patterns
- **IMPORTANT**: Use `gtk4::` not `gtk::` for all imports
```

### 2. API/Approach Correction

**You say:** "ImageBrowser is deprecated, use displayHint instead"

**I add to progress.txt:**
```markdown
## Learnings
- **IMPORTANT**: ImageBrowser and GridBrowser are DEPRECATED
  - Use ResultItem.displayHint (grid | large_grid) instead
  - See hamr-types/src/lib.rs for type definition
```

**I add to IMPLEMENTATION_PLAN.md (if already committed wrong):**
```markdown
- [ ] [Fix]: Refactor to use displayHint instead of ImageBrowser
  - Acceptance: No ImageBrowser/GridBrowser references remain
  - Files: hamr-gtk/src/window.rs
```

### 3. Task Adjustment

**You say:** "Skip the animation task for now, focus on core functionality"

**I update IMPLEMENTATION_PLAN.md:**
```markdown
- [ ] Core functionality task (PRIORITIZE)
- [ ] ~~Animation task~~ (DEFERRED - focus on core first)
```

### 4. Split Large Task

**You say:** "That task is too big, split it"

**I update IMPLEMENTATION_PLAN.md:**
```markdown
## Original (too large)
- [ ] Implement full widget system

## Split into:
- [ ] Create base Widget trait
- [ ] Implement Button widget
- [ ] Implement Label widget
- [ ] Wire up widget rendering
```

---

## Quick Commands

Tell me one of these:

| Command | What happens |
|---------|--------------|
| "Wrong pattern: X should be Y" | Adds to Codebase Patterns |
| "Deprecated: X, use Y instead" | Adds learning + fix task if needed |
| "Skip task: X" | Marks task as deferred |
| "Prioritize: X" | Moves task up with PRIORITIZE note |
| "Split: X into A, B, C" | Breaks task into subtasks |
| "Add task: X" | Adds new task to plan |
| "Blocked: X because Y" | Adds blocker note to progress |

---

## Progress.txt Structure

I maintain this structure:

```markdown
# Ralph Loop Progress Log
Started: {date}
Branch: {branch}

## Codebase Patterns
- Pattern 1
- Pattern 2

## Learnings
- **IMPORTANT**: Learning 1
- Learning 2

---

## [Task-1] - DONE
- What: Brief description
- Files: Changed files
- Learned: What discovered
---

## [Task-2] - IN PROGRESS
- Status: Current state
---
```

---

## IMPLEMENTATION_PLAN.md Structure

I maintain this structure:

```markdown
# Implementation Plan

## Feature Group 1
- [x] Completed task
- [ ] Pending task (PRIORITIZE)
  - Acceptance: How to verify
  - Files: Affected files
- [ ] Another task
  - Depends: Previous task

## Feature Group 2
- [ ] Task A
- [ ] Task B (DEFERRED - reason)

## Cleanup
- [ ] Fix clippy warnings for Feature Group 1
  - Depends: All Feature Group 1 tasks
```

---

## Examples

### Example 1: Wrong Import

**You:** "It's using gtk:: but should use gtk4::"

**I do:**
```
Added to progress.txt Codebase Patterns:
- **IMPORTANT**: Use `gtk4::` not `gtk::` for all GTK imports
  - The crate is named gtk4, use it consistently
```

### Example 2: Deprecated API

**You:** "Don't use async_std, use tokio"

**I do:**
```
Added to progress.txt Learnings:
- **IMPORTANT**: Use tokio, NOT async_std
  - Project standardized on tokio runtime
  - See Cargo.toml for tokio features

Added to IMPLEMENTATION_PLAN.md:
- [ ] [Fix]: Replace async_std with tokio
  - Acceptance: No async_std in Cargo.toml or imports
  - Files: Cargo.toml, src/**/*.rs
```

### Example 3: Reprioritize

**You:** "Focus on the socket handler first, UI can wait"

**I do:**
```
Updated IMPLEMENTATION_PLAN.md:
- [ ] Implement socket handler (PRIORITIZE - foundation for UI)
- [ ] UI components (DEFERRED - after socket handler works)
```

---

## Tell me what needs correcting.

Format: "[issue type]: [what's wrong] -> [what's correct]"

Examples:
- "Wrong pattern: using unwrap() everywhere -> use ? operator"
- "Deprecated: old_function() -> new_function()"
- "Skip: animation polish -> focus on core"
- "Prioritize: error handling -> before happy path"
