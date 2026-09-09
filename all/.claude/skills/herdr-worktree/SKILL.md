---
name: herdr-worktree
description: "Spin up an isolated Herdr workspace + git worktree for one or more GitHub issues (or ad-hoc tasks) and open Claude in each with the /auto-branch command pre-typed (not submitted). Use when the user asks to start, handle, take on, work on, kick off, or spin up issue(s) in worktrees / new workspaces — e.g. 'start #146', 'handle those issues now', 'kick these off', 'spin up worktrees for the ones we just made'. One Herdr workspace per issue. Wraps the gwthauto shell function; only works when THIS session is inside Herdr (HERDR_ENV=1)."
---

# herdr-worktree

Open a fresh Herdr workspace + git worktree for a GitHub issue (or ad-hoc task) and launch Claude in it, with `/rc-toolkit:auto-branch <issue>` **typed but not submitted** — leaving the user room to set model/effort before they hit Enter. Runs **in the background by default**: the new workspace is created unfocused and a desktop notification fires when Claude is ready, so a launch never pulls the user out of the workspace they are in. This is the Herdr-native version of `gwtatauto`.

## Prerequisites (check first)

1. **This session must be inside Herdr.** Run `test "${HERDR_ENV:-}" = 1`. If it fails, say the session is not inside Herdr and STOP — do not try to substitute another mechanism. (Outside Herdr, the user runs `gwtatauto <issue>` or `gwtauto <issue>` themselves in a terminal.)
2. `gwthauto` must be defined (it lives in the user's sourced profile, `~/.rcarrier_profile.sh`). `jq`, `gh`, and `claude` must be on PATH — `gwthauto` checks and errors clearly if not.

## How to run

One invocation per issue, via Bash:

```bash
gwthauto [-m <model>] [-f] [-g] <issue-number | "task description">
```

- `gwthauto 146` — background; notifies when `/auto-branch` is typed and ready
- `gwthauto -m opus 146`
- `gwthauto --model fable make the retry backoff jittered`
- `gwthauto -f 146` — also switch to the new workspace (default: stay put)
- `gwthauto -g 146` — also submit `/auto-branch` (auto-launch at default effort)

Default (no `-f`, no `-g`) is the right call for the assistant: it does not steal the user's focus and leaves effort/model to them. Add a flag **only when the user asks for that behaviour**:

- `-f`/`--focus` when they want to be taken there — "switch me to it", "open it in front of me", "take me to that workspace", "focus it".
- `-g`/`--go` when they want it to run itself — "just start it", "kick it off and let it run", "launch it", "don't wait for me", "auto-run it", "submit it". (Combine both, e.g. `gwthauto -g -f 146`, if they ask for both.)

It: has a headless haiku name the branch, `gwta` creates the worktree (in a subshell, so the caller's pane does not move), opens a new Herdr workspace at the worktree with Claude **unfocused** (background), and — via a background poller — types `/rc-toolkit:auto-branch <issue>` into that pane once Claude is ready, **without submitting it**, then fires a `worktree ready` desktop notification. `-f/--focus` switches to the workspace instead; `-g` also presses Enter to launch.

## Model mapping

Default **Opus**. Use `-m opus` explicitly for Trivial–High. Use `-m fable` **only** for genuinely High + open-ended long-horizon work (native/FFI/concurrency, can't be proven locally). If the issue body carries a `Suggested model:` line, follow it.

## Guardrails

- **Confirm the issue number(s)/description with the user before running.** Each call creates a real git worktree and launches a real Claude instance (cost). Do not run speculatively. If the user refers to issues indirectly ('handle those', 'the ones we just made'), resolve them to concrete issue numbers from the conversation and confirm the list first.
- **One workspace per issue.** For several issues, call `gwthauto` once per issue. (Only relevant here: if two issues touch the same file, tell the user to merge them in order — that's a per-project concern, not this skill's.)
- **Default: typed-not-submitted, and background-not-focused.** `gwthauto` leaves `/auto-branch` typed-not-submitted and the workspace unfocused, then notifies when ready. Do not send Enter into that pane and do not switch the user to it — they set effort/model and submit. Pass `-g` (submit) or `-f` (focus) **only** when the user explicitly asks for it.
- **Don't assume success.** The `/auto-branch` typing is backgrounded and driven off herdr's agent status (it waits for the agent to reach `idle`); a `worktree ready` notification fires when it lands. If a new worktree first shows Claude's trust-folder dialog, a `worktree needs you` notification fires instead — the user opens that workspace and trusts the folder, then the command is typed. After running, report the workspace id and that a notification will fire. If it never types (no notification after ~2 min), the user can type `/rc-toolkit:auto-branch <issue>` themselves in the new workspace.

## If something goes wrong

`gwthauto` echoes what it did (branch, worktree path, workspace id). Since this session is inside Herdr, drive and inspect the new workspace with the **`herdr` skill** (load it) or `herdr --help`:

- Find it: `herdr workspace list`, then `herdr pane list --workspace <id>`.
- See the pane: `herdr pane read <pane> --source visible --lines 40`.
- Check Claude is up: `herdr agent get <pane>` (`agent_status` is `idle`/`working`/`done`), or `herdr pane process-info --pane <pane>` and look at `.cmdline` for `claude` — on macOS the `.name` field is the version string (e.g. `2.1.265`), not `claude`.
- Inspect/adjust the launcher itself: the `gwthauto` function lives in `~/.rcarrier_profile.sh`.

Common failures:
- **Not in Herdr** (`HERDR_ENV` unset) → `gwthauto` refuses; the user runs `gwtatauto`/`gwtauto` in a plain terminal instead.
- **Missing `jq` / `gh` / `claude`** → `gwthauto` errors naming the missing tool.
- **Branch/worktree** → haiku failed to name a valid branch, or the branch/worktree already exists; rerun or let the user resolve it.
- **`/auto-branch` not typed** (background poller timed out — Claude slow to start, or a trust-folder dialog still open) → nothing is lost; type `/rc-toolkit:auto-branch <issue>` in the new workspace by hand.

## When NOT to use

- Outside Herdr (see prerequisite 1).
- When the user wants to work in the current session/branch rather than spin up a new isolated worktree.
