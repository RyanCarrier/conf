# All gwt* worktree commands, split out of .rcarrier_profile.sh to keep that file
# from ballooning. Sourced from there (guarded). Grouped top-down: the worktree
# primitives (gwta add+cd, gwtr remove, gwtat tmux-open) and their bash completions,
# then the shared _gwt_branch namer, then the auto-launchers that tie them together.
#
# The tmux helpers gwtat/gwtatauto lean on (tn/ta) stay in the profile; shell
# functions resolve at call time, so living in separate files is fine as long as
# both are sourced into the same shell.
#
# Auto-launchers (all take a leading -m/--model, then an issue number or task desc;
# the haiku branch-namer is unaffected by -m):
#   gwtauto    plain: claude opens in the current terminal (no tmux/herdr)
#   gwtatauto  tmux: new session, claude opened + /auto-branch typed via send-keys
#   gwthcauto  herdr CREATE: new workspace + worktree, backgrounded, notifies
#   gwthauto   herdr in-place: same, but in the workspace you're already in

unalias gwta

# git worktree add in parent directory as reponame_branchname
# (or with -b if the branch doesn't exist)
# optional second arg is a start point (tag, branch or commit) to cut the new
# branch from, e.g. `gwta v19.9.0-hotfix v19.9.0`
function gwta() {
	if [ -z "$1" ]; then
		echo "gib branch name"
		return 1
	fi
	local branch="$1"
	local start_point="$2"
	# get repo root and name
	local repo_root
	repo_root=$(git worktree list | head -1 | awk '{print $1}')
	local repo_name
	repo_name=$(basename "$repo_root")
	local parent_dir
	parent_dir=$(dirname "$repo_root")

	# replace / with _ for directory name
	local branch_dir="${branch//\//_}"
	local worktree_path="${parent_dir}/${repo_name}_${branch_dir}"

	# if worktree already exists, just offer to cd
	if [ -d "$worktree_path" ]; then
		echo "$worktree_path already exists"
	elif [ -n "$start_point" ]; then
		# explicit start point: always cut a fresh branch from it
		if ! git rev-parse --verify --quiet "${start_point}^{commit}" >/dev/null; then
			echo "start point $start_point not found (if it's a new tag: git fetch --tags)"
			return 1
		fi
		if git show-ref --verify --quiet "refs/heads/$branch"; then
			echo "branch $branch already exists locally, refusing to move it to $start_point"
			echo "use \`gwta $branch\` to check it out as-is, or pick another name"
			return 1
		fi
		if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
			echo "warning: origin/$branch already exists, cutting from $start_point anyway"
		fi
		git worktree add -b "$branch" "$worktree_path" "$start_point" || return 1
		echo "created $branch from $start_point at $worktree_path"
	else
		# check if local branch exists
		if git show-ref --verify --quiet "refs/heads/$branch"; then
			echo "branch $branch exists locally, checking out"
			git worktree add "$worktree_path" "$branch"
			echo "checked out to $worktree_path"
		# check if remote branch exists
		elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
			echo "branch $branch exists on remote, checking out"
			git worktree add "$worktree_path" "$branch"
			echo "checked out to $worktree_path"
		else
			git worktree add -b "$branch" "$worktree_path"
			echo "created and checked out to $worktree_path"
		fi
	fi
	# by default cd into the new worktree, unless they answer n to the prompt
	echo -n "cd into $worktree_path? (Y/n) "
	read -r response
	if [[ "$response" != "n" && "$response" != "N" ]]; then
		cd "$worktree_path" || return
	fi
}

# completion for gwta - branches for the branch name, tags too for the optional
# start point in second position
_gwta_completions() {
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local branches candidates
	# get local and remote branches, strip remote prefix
	branches=$(git branch -a 2>/dev/null | sed 's/^[* ]*//' | sed 's|remotes/origin/||' | grep -v '^HEAD')
	if [ "$COMP_CWORD" -ge 2 ]; then
		candidates=$(printf '%s\n%s\n' "$(git tag 2>/dev/null)" "$branches" | sort -u)
	else
		candidates=$(echo "$branches" | sort -u)
	fi
	COMPREPLY=($(compgen -W "$candidates" -- "$cur"))
}
complete -F _gwta_completions gwta gwtat

# completion for gwtr - complete on existing worktrees in parent directory
_gwtr_completions() {
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local repo_root repo_name parent_dir worktrees
	repo_root=$(git worktree list 2>/dev/null | head -1 | awk '{print $1}')
	repo_name=$(basename "$repo_root" 2>/dev/null)
	parent_dir=$(dirname "$repo_root" 2>/dev/null)
	# find directories matching reponame_* and strip the prefix
	worktrees=$(ls -1d "${parent_dir}/${repo_name}_"* 2>/dev/null | xargs -n1 basename | sed "s/^${repo_name}_//")
	COMPREPLY=($(compgen -W "$worktrees" -- "$cur"))
}
complete -F _gwtr_completions gwtr

# remove the worktree from parent directory
function gwtr() {
	local branch="$1"
	local repo_root repo_name parent_dir

	# Get the main repository root (first worktree listed)
	repo_root=$(git worktree list | head -1 | awk '{print $1}')
	repo_name=$(basename "$repo_root")
	parent_dir=$(dirname "$repo_root")

	# If no branch name provided, try to detect from current worktree
	if [ -z "$branch" ]; then
		local current_worktree
		current_worktree=$(git rev-parse --show-toplevel 2>/dev/null)
		local current_name
		current_name=$(basename "$current_worktree")

		# Check if we're in a reponame_* worktree
		if [[ "$current_name" == "${repo_name}_"* ]]; then
			branch="${current_name#${repo_name}_}"
			echo "detected current worktree: $branch"
		else
			echo "gib branch name or run from within a worktree"
			return
		fi
	fi

	# replace / with _ for directory name
	local branch_dir="${branch//\//_}"
	local worktree_path="${parent_dir}/${repo_name}_${branch_dir}"

	# cd to repo root if we're currently in the worktree being removed
	local current_worktree
	current_worktree=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ "$current_worktree" == "$worktree_path" ]]; then
		echo "cd to repo root: $repo_root"
		cd "$repo_root" || return
	fi

	echo "removing worktree: $worktree_path"
	git worktree remove "$worktree_path"
}

# gwta + a tmux session sitting in the new worktree. Optional second arg is a
# start point, so a hotfix off a release tag is:
#   gwtat v19.9.0-hotfix v19.9.0
function gwtat() {
	if [ -z "$1" ]; then
		echo "gib branch name"
		return 1
	fi
	gwta "$1" "$2" || return 1
	# tmux splits -t targets on . and : (session:window.pane), so a tag-shaped
	# branch like v19.9.0-hotfix has to be flattened or the attach below fails
	# with "can't find pane: 9.0-hotfix"
	local session="${1//[.:]/_}"
	tn "$session" -d
	# tmux send-keys -t "$session":0 'claude' Enter
	ta "$session"
}

# _gwt_branch <issue-number | task description>: resolve the arg(s) to a validated
# git branch name, printed on stdout. Progress ("asking haiku...") goes to stderr
# so callers can capture just the name. A bare #?N looks up the issue title via gh
# so haiku has something to name after, falling back to issue/N if gh can't reach
# it. Returns non-zero only when haiku can't produce a valid name for a real desc.
_gwt_branch() {
	local desc="$*"
	local naming_input="$desc" issue_num="" issue_re='^#?[0-9]+$'
	if [[ "$desc" =~ $issue_re ]]; then
		issue_num="${desc#\#}"
		local title
		title=$(gh issue view "$issue_num" --json title -q .title 2>/dev/null)
		if [ -n "$title" ]; then
			naming_input="GitHub issue #${issue_num}: ${title}"
		else
			echo "couldn't fetch issue #${issue_num} via gh, falling back to issue/${issue_num}" >&2
			naming_input=""
		fi
	fi

	if [ -z "$naming_input" ]; then
		printf '%s\n' "issue/${issue_num}"
		return 0
	fi

	echo "asking haiku for a branch name..." >&2
	local raw attempt branch branch_re='^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$'
	for attempt in 1 2; do
		raw=$(claude --model haiku -p "Reply with ONLY a git branch name for this task, nothing else - no prose, no quotes, no backticks. Format: type/short-kebab-description, where type is one of feat, fix, chore, refactor, docs or test and the description is 2-6 lowercase words joined by hyphens (a-z, 0-9 and - only, exactly one /). If the task references an issue number, start the description with it, e.g. fix/123-flaky-retry. Task: ${naming_input}")
		# last non-empty line, stripped of whitespace/quotes/backticks
		branch=$(printf '%s\n' "$raw" | awk 'NF{l=$0} END{print l}' | tr -d "[:space:]\`\"'")
		if [[ "$branch" =~ $branch_re ]] &&
			git check-ref-format --branch "$branch" >/dev/null 2>&1; then
			printf '%s\n' "$branch"
			return 0
		fi
	done
	echo "haiku couldn't produce a valid branch name, last answer:" >&2
	echo "$raw" >&2
	return 1
}

# gwtatauto without the tmux: a headless haiku names the branch, gwta worktrees
# + cds into it, then claude opens right here in the current terminal. A plain
# foreground claude can't be handed the command typed-but-unsubmitted (that was a
# tmux send-keys trick), so the /auto-branch command is printed for you to paste,
# leaving room to set effort/model in the TUI first. (In herdr, gwthauto CAN type
# it in-place -- see below.)
#   gwtauto 123
#   gwtauto make the retry backoff jittered
#   gwtauto -m opus 123
#   gwtauto --model fable make the retry backoff jittered
function gwtauto() {
	# optional leading -m/--model <model>; everything after is the issue number
	# or task description, so the flag has to be parsed off the front first
	local model=""
	while [ "$#" -gt 0 ]; do
		case "$1" in
		-m | --model)
			if [ -z "$2" ]; then
				echo "gib a model name after $1"
				return 1
			fi
			model="$2"
			shift 2
			;;
		--model=*) model="${1#--model=}"; shift ;;
		-m=*) model="${1#-m=}"; shift ;;
		*) break ;;
		esac
	done

	if [ -z "$1" ]; then
		echo "gib issue number or description"
		return 1
	fi
	local desc="$*"

	local branch
	branch=$(_gwt_branch "$desc") || return 1
	echo "branch: $branch"

	# gwta asks before cd'ing into the worktree; feed it a y to stay hands-off
	# (redirection only feeds the read -- the cd still lands in this shell)
	gwta "$branch" <<<"y" || return 1

	# no tmux, so claude runs in this terminal. Print the command to paste (it
	# scrolls into scrollback once claude takes over), then launch claude in the
	# worktree gwta just cd'd us into.
	echo "paste into claude:"
	echo "/rc-toolkit:auto-branch ${desc}"
	if [ -n "$model" ]; then
		claude --model "$model"
	else
		claude
	fi
}

# the default way to start work: hand it what you'd give /auto-branch (an issue
# number or a task description), a headless haiku names the branch, then it
# worktrees+tmuxes into it and leaves claude open with the auto-branch command
# typed but NOT submitted, so there's still room to set model/effort first.
#   gwtatauto 123
#   gwtatauto make the retry backoff jittered
#   gwtatauto -m opus 123
#   gwtatauto --model fable make the retry backoff jittered
function gwtatauto() {
	local model=""
	while [ "$#" -gt 0 ]; do
		case "$1" in
		-m | --model)
			if [ -z "$2" ]; then
				echo "gib a model name after $1"
				return 1
			fi
			model="$2"
			shift 2
			;;
		--model=*) model="${1#--model=}"; shift ;;
		-m=*) model="${1#-m=}"; shift ;;
		*) break ;;
		esac
	done

	if [ -z "$1" ]; then
		echo "gib issue number or description"
		return 1
	fi
	local desc="$*"

	local branch
	branch=$(_gwt_branch "$desc") || return 1
	echo "branch: $branch"

	# gwta asks before cd'ing into the worktree; feed it a y to stay hands-off
	# (redirection only feeds the read -- the cd still lands in this shell)
	gwta "$branch" <<<"y" || return 1

	# gwtat's .: flattening, plus / since these names always carry one
	local session="${branch//\//_}"
	session="${session//[.:]/_}"
	if tmux has-session -t "=$session" 2>/dev/null; then
		echo "session $session already exists, attaching"
		ta "$session"
		return
	fi
	tn "$session" -d
	local claude_cmd='claude'
	[ -n "$model" ] && claude_cmd="claude --model ${model}"
	tmux send-keys -t "$session" "$claude_cmd" Enter
	# type the auto-branch command once claude's TUI is actually ready. Runs as
	# a detached background poller so the attach below is instant and a fresh
	# worktree's trust-folder dialog can be answered first -- the poller waits
	# for claude to own the pane, then for the dialog to clear, then types the
	# command but does NOT send it, leaving room to set effort (and model, if
	# -m wasn't passed) first.
	# Gives up quietly after ~2min (e.g. claude never started). ; is escaped so
	# tmux doesn't read it as a command separator.
	(
		{
			deadline=$((SECONDS + 120))
			while [ "$SECONDS" -lt "$deadline" ]; do
				case "$(tmux display-message -p -t "$session" '#{pane_current_command}' 2>/dev/null)" in
				claude | node) break ;;
				esac
				sleep 0.5
			done
			sleep 1
			while [ "$SECONDS" -lt "$deadline" ] &&
				tmux capture-pane -p -t "$session" 2>/dev/null | grep -qi 'trust this folder'; do
				sleep 0.5
			done
			sleep 1
			case "$(tmux display-message -p -t "$session" '#{pane_current_command}' 2>/dev/null)" in
			claude | node)
				tmux send-keys -t "$session" -l "/rc-toolkit:auto-branch ${desc//;/\\;}"
				;;
			esac
		} >/dev/null 2>&1 &
	)
	ta "$session"
}

# gwtatauto, but for herdr instead of tmux: git worktree herdr CREATE auto. Opens
# a fresh herdr workspace, has a headless haiku name the branch, gwta worktrees
# into it, then claude opens in the new workspace with the /auto-branch command
# TYPED BUT NOT SUBMITTED -- same hands-off-until-effort-is-set flow as gwtatauto,
# using `herdr pane send-text` (literal text, no Enter) where gwtatauto used tmux
# `send-keys -l`. For the in-place variant (no new workspace) see gwthauto below.
# Must run inside herdr (HERDR_ENV=1); needs jq.
# An optional leading -m/--model picks claude's launch model; the namer is haiku.
# Runs in the BACKGROUND by default: the new workspace is created unfocused and a
# desktop notification fires once claude is ready, so you can stay where you are.
# -f/--focus switches to it instead.
#   gwthcauto 123
#   gwthcauto -m opus 123
#   gwthcauto --model fable make the retry backoff jittered
#   gwthcauto -g 123            # also press enter to launch /auto-branch right away
#   gwthcauto -f 123            # switch to the new workspace (default: background + notify)
function gwthcauto() {
	[ "${HERDR_ENV:-}" = 1 ] || { echo "gwthcauto must run inside herdr (HERDR_ENV=1)"; return 1; }
	command -v jq >/dev/null 2>&1 || { echo "gwthcauto needs jq"; return 1; }

	# optional leading -m/--model <model>, same front-parse as gwtauto.
	# -g/--go/--enter/--submit also presses enter to launch /auto-branch (default: typed, not submitted).
	# -f/--focus switches to the new workspace (default: background, notify when ready).
	local model="" submit="" focus=""
	while [ "$#" -gt 0 ]; do
		case "$1" in
		-m | --model)
			if [ -z "$2" ]; then echo "gib a model name after $1"; return 1; fi
			model="$2"; shift 2 ;;
		--model=*) model="${1#--model=}"; shift ;;
		-m=*) model="${1#-m=}"; shift ;;
		-g | --go | --enter | --submit) submit=1; shift ;;
		-f | --focus) focus=1; shift ;;
		*) break ;;
		esac
	done
	if [ -z "$1" ]; then echo "gib issue number or description"; return 1; fi
	local desc="$*"

	local branch
	branch=$(_gwt_branch "$desc") || return 1
	echo "branch: $branch"

	# make the worktree in a SUBSHELL so gwta's cd doesn't move this pane; the
	# subshell's final pwd is the worktree path (gwta cds into it on the fed y).
	local repo_root worktree
	repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
	worktree=$( (gwta "$branch" <<<"y" >/dev/null 2>&1 && pwd) )
	if [ -z "$worktree" ] || [ "$worktree" = "$repo_root" ]; then
		echo "gwta didn't produce a worktree for $branch"
		return 1
	fi
	echo "worktree: $worktree"

	# fresh herdr workspace rooted in the worktree; claude launches inside it
	local claude_cmd="claude"
	[ -n "$model" ] && claude_cmd="claude --model ${model}"
	local ws_json ws_id pane
	ws_json=$(herdr workspace create --cwd "$worktree" --label "$branch" --no-focus 2>&1) ||
		{ echo "herdr workspace create failed:"; echo "$ws_json"; return 1; }
	ws_id=$(printf '%s' "$ws_json" | jq -r '.result.workspace.workspace_id')
	pane=$(printf '%s' "$ws_json" | jq -r '.result.root_pane.pane_id')
	if [ -z "$ws_id" ] || [ "$ws_id" = null ] || [ -z "$pane" ] || [ "$pane" = null ]; then
		echo "couldn't read workspace/pane id from herdr:"
		echo "$ws_json"
		return 1
	fi
	sleep 1.5 # let the new pane's shell reach its prompt before we drive it
	herdr pane run "$pane" "$claude_cmd" >/dev/null 2>&1
	# background by default so a launch never yanks you out of the workspace you are
	# in; -f/--focus opts into switching. The poller notifies when claude is ready.
	local mode="background; you'll be notified when it's ready"
	if [ -n "$focus" ]; then herdr workspace focus "$ws_id" >/dev/null 2>&1; mode="focused"; fi
	echo "herdr workspace $ws_id (pane $pane): claude opening in $worktree ($mode)"

	# background poller: drive the launch through herdr's agent lifecycle API
	# instead of scraping process names / the trust dialog (tier 3). Wait for the
	# agent to be detected, then for `idle` -- which herdr reports only AFTER the
	# trust dialog (a `blocked` state) clears and claude sits at a ready prompt --
	# then hand over /auto-branch and notify. Handover uses `pane send-text` (types,
	# proven reliable) plus a `send-keys enter` for -g (submit) -- `agent prompt`
	# was flaky at actually submitting, so it is deliberately not used.
	# Verified: claude's trust dialog reads as `blocked`, so `--until idle` never
	# fires while it is up. Gives up quietly after ~2 min.
	(
		{
			# 1) wait (bounded) for herdr to detect the launched claude agent
			det=$((SECONDS + 30))
			until herdr agent get "$pane" 2>/dev/null | jq -e '.result.agent.agent_status' >/dev/null 2>&1 ||
				[ "$SECONDS" -ge "$det" ]; do
				sleep 0.25
			done
			# 2) wait for claude to settle: `blocked` = a first-run trust dialog is
			#    up, `idle` = ready. In the background you are not there to clear the
			#    trust prompt, so notify and keep waiting for idle (longer window).
			herdr agent wait "$pane" --until blocked --until idle --timeout 120000 >/dev/null 2>&1 || exit 0
			if [ "$(herdr agent get "$pane" 2>/dev/null | jq -r '.result.agent.agent_status')" = blocked ]; then
				herdr notification show "worktree needs you: ${branch}" --body "Open ${ws_id} and trust the folder to continue" --sound request >/dev/null 2>&1
				herdr agent wait "$pane" --until idle --timeout 600000 >/dev/null 2>&1 || exit 0
			fi
			# 3) type the /auto-branch command; press enter only for -g (submit).
			#    A send-text fired on the exact idle edge can be dropped, so give the
			#    TUI a moment to become input-ready first.
			sleep 1
			herdr pane send-text "$pane" "/rc-toolkit:auto-branch ${desc}" >/dev/null 2>&1
			if [ -n "$submit" ]; then
				sleep 0.5
				herdr pane send-keys "$pane" enter >/dev/null 2>&1
				herdr notification show "worktree launched: ${branch}" --body "/auto-branch running in ${ws_id}" --sound done >/dev/null 2>&1
			else
				herdr notification show "worktree ready: ${branch}" --body "/auto-branch typed in ${ws_id}. Set effort and submit." --sound request >/dev/null 2>&1
			fi
		} >/dev/null 2>&1 &
	)
}

# In-place sibling of gwthcauto: run it in the herdr workspace you're ALREADY in.
# No new workspace -- it names the branch, gwta worktrees + cds THIS pane into it,
# launches claude right here, and (via a background poller that self-targets this
# pane, since a foreground claude can't be driven from the now-blocked shell) types
# /rc-toolkit:auto-branch, typed-but-not-submitted. So gwthcauto == gwthauto plus
# "create + background a fresh workspace first". Quiet (no notifications): you're
# here to watch it and to clear any trust-folder dialog yourself.
# Must run inside herdr (HERDR_ENV=1); needs jq.
# An optional leading -m/--model picks claude's launch model; the namer is haiku.
#   gwthauto 123
#   gwthauto make the retry backoff jittered
#   gwthauto -m opus 123
#   gwthauto -g 123            # also press enter to launch /auto-branch right away
function gwthauto() {
	[ "${HERDR_ENV:-}" = 1 ] || { echo "gwthauto must run inside a herdr workspace (HERDR_ENV=1)"; return 1; }
	command -v jq >/dev/null 2>&1 || { echo "gwthauto needs jq"; return 1; }

	# optional leading -m/--model <model>, same front-parse as gwthcauto.
	# -g/--go/--enter/--submit also presses enter to launch /auto-branch (default: typed, not submitted).
	# no -f/--focus: you're already in this workspace, there's nothing to switch to.
	local model="" submit=""
	while [ "$#" -gt 0 ]; do
		case "$1" in
		-m | --model)
			if [ -z "$2" ]; then echo "gib a model name after $1"; return 1; fi
			model="$2"; shift 2 ;;
		--model=*) model="${1#--model=}"; shift ;;
		-m=*) model="${1#-m=}"; shift ;;
		-g | --go | --enter | --submit) submit=1; shift ;;
		*) break ;;
		esac
	done
	if [ -z "$1" ]; then echo "gib issue number or description"; return 1; fi
	local desc="$*"

	# our own pane id -- herdr sets HERDR_WORKSPACE_ID/HERDR_TAB_ID for a pane's
	# shell but no HERDR_PANE_ID, so ask which pane this shell is in. Grab it up
	# front so the background poller can target us; the id is stable across gwta's cd.
	local pane
	pane=$(herdr pane current 2>/dev/null | jq -r '.result.pane.pane_id')
	if [ -z "$pane" ] || [ "$pane" = null ]; then
		echo "couldn't resolve the current herdr pane"
		return 1
	fi

	local branch
	branch=$(_gwt_branch "$desc") || return 1
	echo "branch: $branch"

	# in-place: let gwta cd THIS pane into the worktree (gwthcauto used a subshell
	# to avoid moving; here moving is the point)
	gwta "$branch" <<<"y" || return 1

	# background poller: same lifecycle approach as gwthcauto, but self-targeting
	# and quiet. First wait for our freshly-launched claude to actually come up
	# (working, or blocked on the trust dialog) -- otherwise a stale idle from a
	# previous agent in this pane could make us type too early -- then wait for it
	# to settle at a ready prompt, then type. Gives up quietly after its timeouts.
	(
		{
			herdr agent wait "$pane" --until working --until blocked --timeout 60000 >/dev/null 2>&1 || exit 0
			herdr agent wait "$pane" --until idle --timeout 600000 >/dev/null 2>&1 || exit 0
			sleep 1
			herdr pane send-text "$pane" "/rc-toolkit:auto-branch ${desc}" >/dev/null 2>&1
			if [ -n "$submit" ]; then
				sleep 0.5
				herdr pane send-keys "$pane" enter >/dev/null 2>&1
			fi
		} >/dev/null 2>&1 &
	)

	# claude takes over this pane in the foreground; the poller above drives it.
	echo "claude opening here (pane $pane); /auto-branch will be typed when ready"
	if [ -n "$model" ]; then
		claude --model "$model"
	else
		claude
	fi
}
