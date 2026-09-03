---
name: herdr-worktree
description: "Spin up an isolated Herdr workspace + git worktree for one or more GitHub issues (or ad-hoc tasks) and open Claude in each with the /auto-branch command pre-typed (not submitted). Use when the user asks to start, handle, take on, work on, kick off, or spin up issue(s) in worktrees / new workspaces — e.g. 'start #146', 'handle those issues now', 'kick these off', 'spin up worktrees for the ones we just made'. One Herdr workspace per issue. Wraps the gwthauto shell function; only works when THIS session is inside Herdr (HERDR_ENV=1)."
---

# herdr-worktree

Open a fresh Herdr workspace + git worktree for a GitHub issue (or ad-hoc task) and launch Claude in it, with `/rc-toolkit:auto-branch <issue>` **typed but not submitted** — leaving the user room to set model/effort before they hit Enter. This is the Herdr-native version of `gwtatauto`.

## Prerequisites (check first)

1. **This session must be inside Herdr.** Run `test "${HERDR_ENV:-}" = 1`. If it fails, say the session is not inside Herdr and STOP — do not try to substitute another mechanism. (Outside Herdr, the user runs `gwtatauto <issue>` or `gwtauto <issue>` themselves in a terminal.)
2. `gwthauto` must be defined (it lives in the user's sourced profile, `~/.rcarrier_profile.sh`). `jq`, `gh`, and `claude` must be on PATH — `gwthauto` checks and errors clearly if not.

## How to run

One invocation per issue, via Bash:

```bash
gwthauto [-m <model>] <issue-number | "task description">
```

- `gwthauto 146`
- `gwthauto -m opus 146`
- `gwthauto --model fable make the retry backoff jittered`

It: has a headless haiku name the branch, `gwta` creates the worktree (in a subshell, so the caller's pane does not move), opens a new Herdr workspace at the worktree with Claude, and — via a background poller — types `/rc-toolkit:auto-branch <issue>` into that pane once Claude is ready, **without submitting it**.

## Model mapping

Default **Opus**. Use `-m opus` explicitly for Trivial–High. Use `-m fable` **only** for genuinely High + open-ended long-horizon work (native/FFI/concurrency, can't be proven locally). If the issue body carries a `Suggested model:` line, follow it.

## Guardrails

- **Confirm the issue number(s)/description with the user before running.** Each call creates a real git worktree and launches a real Claude instance (cost). Do not run speculatively. If the user refers to issues indirectly ('handle those', 'the ones we just made'), resolve them to concrete issue numbers from the conversation and confirm the list first.
- **One workspace per issue.** For several issues, call `gwthauto` once per issue. (Only relevant here: if two issues touch the same file, tell the user to merge them in order — that's a per-project concern, not this skill's.)
- **Never submit the `/auto-branch` command.** `gwthauto` deliberately leaves it typed-not-submitted. Do not send Enter into that pane — the user sets effort/model and submits.
- **Don't assume success.** The `/auto-branch` typing is backgrounded (waits up to ~2 min for Claude + any trust-folder dialog to clear). After running, report the workspace id from the output; if the user reports it wasn't typed, they can type `/rc-toolkit:auto-branch <issue>` themselves in the new workspace.

## If something goes wrong

`gwthauto` echoes what it did (branch, worktree path, workspace id). Since this session is inside Herdr, drive and inspect the new workspace with the **`herdr` skill** (load it) or `herdr --help`:

- Find it: `herdr workspace list`, then `herdr pane list --workspace <id>`.
- See the pane: `herdr pane read <pane> --source visible --lines 40`.
- Check Claude is up: `herdr pane process-info --pane <pane>` (foreground should be `claude`/`node`).
- Inspect/adjust the launcher itself: the `gwthauto` function lives in `~/.rcarrier_profile.sh`.

Common failures:
- **Not in Herdr** (`HERDR_ENV` unset) → `gwthauto` refuses; the user runs `gwtatauto`/`gwtauto` in a plain terminal instead.
- **Missing `jq` / `gh` / `claude`** → `gwthauto` errors naming the missing tool.
- **Branch/worktree** → haiku failed to name a valid branch, or the branch/worktree already exists; rerun or let the user resolve it.
- **`/auto-branch` not typed** (background poller timed out — Claude slow to start, or a trust-folder dialog still open) → nothing is lost; type `/rc-toolkit:auto-branch <issue>` in the new workspace by hand.

## When NOT to use

- Outside Herdr (see prerequisite 1).
- When the user wants to work in the current session/branch rather than spin up a new isolated worktree.
