#!/usr/bin/env bash
# herdr dirty-changes poller.
#
# Reports two per-workspace sidebar tokens summarizing uncommitted TRACKED changes
# (staged + unstaged, measured vs HEAD): $dirty_ins ("+N", green in the layout) and
# $dirty_del ("-N", red); each is cleared when its count is zero. Untracked files
# are NOT counted.
#
# One pass over all workspaces. It is run on a ~5s loop by a small daemon started
# from .rcarrier_profile.sh (single instance via flock), which runs on the herdr
# SERVER host where the panes and repos live -- so it works whether the TUI is
# local or remote. A tab-bar command scheduler can't do this: it runs client-side.
#
# Only calls herdr when a workspace's value actually changes (cache under
# ~/.cache/herdr-dirty), so a steady state makes zero socket calls. Exits non-zero
# when the server is unreachable, which tells the daemon loop to stop.

export HERDR_SOCKET_PATH="${HERDR_SOCKET_PATH:-$HOME/.config/herdr/herdr.sock}"
command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0
command -v git >/dev/null 2>&1 || exit 0

cache="$HOME/.cache/herdr-dirty"
mkdir -p "$cache" 2>/dev/null || exit 0

# exit non-zero when the server is unreachable, so the poller daemon loop stops.
snap=$(herdr api snapshot 2>/dev/null) || exit 1

# One "ws_id<TAB>cwd" line per workspace, preferring the focused pane's cwd.
printf '%s' "$snap" | jq -r '
  (.result.snapshot.agents // [])
  | map({ws: .workspace_id, cwd: (.foreground_cwd // .cwd), focused: (.focused // false)})
  | group_by(.ws)
  | map((map(select(.focused)) | first) // .[0])
  | .[] | select(.cwd != null and .ws != null) | "\(.ws)\t\(.cwd)"
' 2>/dev/null | while IFS=$'\t' read -r ws cwd; do
	[ -n "$ws" ] && [ -n "$cwd" ] || continue

	ins=0
	del=0
	if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		read -r ins del < <(git -C "$cwd" diff HEAD --numstat 2>/dev/null | awk '
			$1 != "-" { i += $1 } $2 != "-" { d += $2 } END { printf "%d %d", i + 0, d + 0 }')
	fi

	f="$cache/$ws"
	val="${ins:-0} ${del:-0}"
	prev=$(cat "$f" 2>/dev/null)
	[ "$val" = "$prev" ] && continue
	printf '%s' "$val" >"$f"

	# Two tokens so + and - can be colored separately in the sidebar layout:
	# $dirty_ins (green "+N") and $dirty_del (red "-N"); each hidden when zero.
	args=()
	if [ "${ins:-0}" -gt 0 ]; then args+=(--token "dirty_ins=+${ins}"); else args+=(--clear-token dirty_ins); fi
	if [ "${del:-0}" -gt 0 ]; then args+=(--token "dirty_del=-${del}"); else args+=(--clear-token dirty_del); fi
	herdr workspace report-metadata "$ws" --source dirty-poller "${args[@]}" >/dev/null 2>&1
done

exit 0
