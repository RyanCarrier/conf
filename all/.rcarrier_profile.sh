#!/bin/bash

# if RCARRIER_PROFILE_LOADED is set, return
# if [ -n "$RCARRIER_PROFILE_LOADED" ]; then
# 	echo "RCARRIER_PROFILE_LOADED is set, returning"
# 	return
# fi
# export RCARRIER_PROFILE_LOADED=1

# doesn't need to be set anymore and macos is different to arch
# export GOROOT=/usr/lib/go
export GOPATH=$HOME/Projects
# check if Android/Sdk exists
if [ -d "$HOME/Android/Sdk" ]; then
	export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
else
	export ANDROID_SDK_ROOT="/opt/android-sdk"
fi
export JAVA_HOME='/usr/lib/jvm/default'
export ANDROID_HOME="$ANDROID_SDK_ROOT"
CHROME_EXECUTABLE=$(which google-chrome-stable)
export CHROME_EXECUTABLE
for _ed in nvim vim vi; do
	if command -v "$_ed" >/dev/null 2>&1; then
		export EDITOR="$_ed"
		export VISUAL="$_ed"
		break
	fi
done
unset _ed

export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:/opt/flutter/bin
export PATH=$PATH:/usr/local/flutter/bin
# fvm (Flutter Version Management) isn't installed on every host that uses this conf;
# prepend so its flutter/dart shims take precedence over any system install
[ -d "$HOME/fvm/bin" ] && export PATH="$HOME/fvm/bin:$PATH"
export PATH=$PATH:/usr/local/android-studio/bin
export PATH=$PATH:"$HOME/.cargo/bin"
export PATH=$PATH:"$HOME/.local/bin"
export PATH=$PATH:"/snap/bin"
export PATH=$PATH:"/var/lib/snapd/snap/bin"
export PATH=$PATH:"$ANDROID_SDK_ROOT"
export PATH=$PATH:"$ANDROID_SDK_ROOT/platform-tools"
export PATH=$PATH:"$ANDROID_SDK_ROOT/emulator"
export PATH=$PATH:"$ANDROID_SDK_ROOT/tools/bin"
export PATH=$PATH:"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
export PATH=$PATH:"$HOME/.pub-cache/bin"
export PATH=$PATH:"$HOME/.cargo/bin"
export PATH=$PATH:"$HOME/.shorebird/bin"
export PATH=$PATH:"$JAVA_HOME/bin"
export PATH="$PATH:$HOME/.shorebird/bin"
export PATH="$PATH:$HOME/.opencode/bin"
export PATH="$PATH:$HOME/.turso"
export PATH="$PATH:$HOME/.bun/bin"
if [ -f "$HOME/.cargo/env" ]; then
	. "$HOME/.cargo/env"
fi
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
	PATH=$PATH:"$HOME/bin"
fi

# cache rustc sysroot; auto-invalidates when toolchain dir no longer exists
if command -v rustc >/dev/null 2>&1; then
	_rustc_cache="$HOME/.cache/rustc_sysroot"
	if [[ -f "$_rustc_cache" ]] && [[ -d "$(<"$_rustc_cache")" ]]; then
		RUST_SRC_PATH="$(<"$_rustc_cache")/lib/rustlib/src/rust/src"
	else
		mkdir -p "$HOME/.cache"
		rustc --print sysroot >"$_rustc_cache"
		RUST_SRC_PATH="$(<"$_rustc_cache")/lib/rustlib/src/rust/src"
	fi
	export RUST_SRC_PATH
	unset _rustc_cache
fi
#RUBY - rbenv init moved to end of file (after .mac.sh include) to avoid PATH clobbering
# eval "$(rbenv init -)"

# fpath is set in .zshrc before oh-my-zsh compinit

if [ -z "$ZSH_NAME" ]; then
	alias omg='sudo "$BASH" -c "$(history -p !!)"'
	SHELL="$(which bash)"
	noglob
else
	alias omg='sudo $(fc -ln -1)'
	SHELL="$(which zsh)"
fi

unset fd
unalias rm
unset rm #overwrite oh my zsh rm -i
unalias t
unset t

#lol
alias vimm="\$(which vim)"
#lolol
alias vii="\$(which vi)"

alias qq="exit"
alias server="192.168.0.10"
#haha this should be in my hosts but what if it isn't!?!?
alias carryingpigeons="ssh carryingpigeons.com"
alias myip="curl http://ipecho.net/plain; echo"
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"
alias rm="rm" #overwrite oh my zsh rm -i
if [ "$(uname)" = "Darwin" ]; then
	alias xo="open"
else
	alias xo="xdg-open"
fi
alias p1="ping 1.1.1.1"
alias ip='ip -color=auto'
alias vim='nvim'
# alias grep='rg'
# alias neovide='env -u WAYLAND_DISPLAY neovide'
alias gvim='neovide'
alias gs='$HOME/.local/bin/gs'
alias yaysyyu='yay -Syyu --noconfirm'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cat='bat'
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -a'
alias cdfzf='cd $(find . -type d | fzf)'
alias gb="git branch"
alias gc="git checkout"
alias gpl="git pull"
alias gcamend="git commit --amend"
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

alias lns="ln -s"

# Anchor the tmux server to $HOME. The server keeps the cwd of whatever first
# starts it for its entire life; if that first `tmux` ran in a git worktree that
# later gets removed, the server (and every new session/shell that falls back to
# it) is left pointing at a dead dir. Birthing it from $HOME avoids that.
# `exit-empty off` is what lets us do this without a keepalive session: by
# default a server with no sessions exits immediately, so a bare `start-server`
# would die before the real session arrives. With it off the server sticks
# around holding the $HOME anchor and `tmux ls` stays clean -- only the sessions
# you actually asked for. Tradeoff: the server no longer exits on its own when
# the last session goes away; `tmux kill-server` still does it. This shadows the
# tmux binary, so the helpers below (t, tn, tl) route through it automatically.
function tmux() {
	if ! command tmux has-session 2>/dev/null; then
		( builtin cd -- "$HOME" && command tmux start-server \; set -s exit-empty off )
	fi
	command tmux "$@"
}

function t() {
	# If arguments passed, just run tmux with them
	if [ -n "$1" ]; then
		tmux "$@"
		return
	fi

	# Check if we're in a git repo
	local git_root
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)

	if [ -z "$git_root" ]; then
		# Not in a git repo, just run tmux
		tmux
		return
	fi

	local root_name current_dir session_name
	root_name=$(basename "$git_root")
	current_dir=$(pwd)

	if [ "$current_dir" = "$git_root" ]; then
		# At git root
		session_name="$root_name"
	else
		# In subdirectory
		local current_name
		current_name=$(basename "$current_dir")
		session_name="${root_name}_${current_name}"
	fi

	# Check for existing sessions with this name and append number if needed
	local base_name="$session_name"
	local counter=1
	while tmux has-session -t "=$session_name" 2>/dev/null; do
		counter=$((counter + 1))
		session_name="${base_name}_${counter}"
	done

	tmux new-session -s "$session_name"
}
# alias ta="tmux attach"
alias tn="tmux new-session -s"
alias tl="tmux ls"
## Project specific
alias jg="j gym_"
alias ja="j again_"
alias vimlc="vim leetcode.nvim"
alias claude_api="unset CLAUDE_CODE_OAUTH_TOKEN && claude"
# Run Claude Code through OpenRouter with each tier mapped to a different model,
# leaving the plain `claude` command pointed at Anthropic. Needs $OPENROUTER_API_KEY.
# The /model opus|sonnet|haiku picker resolves through the DEFAULT_* vars below;
# the haiku tier also drives background work (titles, summaries), so it's the
# cheap-offload knob. ANTHROPIC_MODEL is left unset so the tier picker wins.
# Env is set in a subshell so it never leaks into the calling shell.
function claude-or() {
	if [ -z "$OPENROUTER_API_KEY" ]; then
		echo "OPENROUTER_API_KEY not set" >&2
		return 1
	fi
	(
		export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
		export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
		export ANTHROPIC_API_KEY=""
		export ANTHROPIC_DEFAULT_OPUS_MODEL="z-ai/glm-5.2"
		export ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek/deepseek-v4-pro"
		export ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek/deepseek-v4-flash"
		claude "$@"
	)
}
if [ "$TERM" = "xterm-kitty" ]; then
	alias ssh="kitty +kitten ssh"
	alias icat="kitty +kitten icat"
	alias diff="kitty +kitten diff"
fi
if [ "$TERM" = "xterm-ghostty" ]; then
	alias ssh="TERM=xterm-256color ssh"
fi
# unset gl

alias feh="feh --scale-down"
if command -v go-task &>/dev/null; then
	alias task="go-task"
	# check for zsh completions
	if [ -n "$ZSH_NAME" ]; then
		task_completion_file="$HOME/.zfunc/_task"
		if [ ! -f "$task_completion_file" ]; then
			echo "task completion file not found: $task_completion_file"
			echo -n "generate it? (Y/n) "
			read -r response
			if [[ "$response" != "n" && "$response" != "N" ]]; then
				mkdir -p "$HOME/.zfunc"
				go-task --completion zsh >"$task_completion_file"
				echo "generated $task_completion_file"
			fi
		fi
	fi
fi

# clear /tmp/ai if it exists,	 and make it, then jump into it, and run 'claude' then exit back out of the dir and remove it
function ai() {
	if [ -d /tmp/ai ]; then
		rm -rf /tmp/ai
	fi
	mkdir /tmp/ai
	cd /tmp/ai || return
	claude "$@"
	cd - || return
	rm -rf /tmp/ai
}
function ta() {
	if [ -z "$1" ]; then
		tmux attach
	else
		tmux attach -t "$1"
	fi
}

_ta_completion() {
	local sessions
	sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)
	COMPREPLY=($(compgen -W "$sessions" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _ta_completion ta

function stl() {
	if [ -z "$1" ]; then
		echo "usage: stl <host>"
		return 1
	fi
	ssh "$1" '$SHELL -lc "tmux ls"'
}

function sta() {
	if [ -n "$TMUX" ]; then
		echo "already in tmux"
		return 1
	fi
	if [ -z "$1" ]; then
		echo "usage: sta <host> [session]"
		return 1
	fi
	if [ -z "$2" ]; then
		ssh -t "$1" '$SHELL -lc "tmux attach"'
	else
		ssh -t "$1" "\$SHELL -lc 'tmux attach -t \"$2\"'"
	fi
}

_sta_completion() {
	local cur="${COMP_WORDS[COMP_CWORD]}"
	if [ "$COMP_CWORD" -eq 1 ]; then
		local hosts
		hosts=$(
			{
				cat ~/.ssh/config 2>/dev/null | grep -i '^Host ' | awk '{for(i=2;i<=NF;i++) print $i}' | grep -v '[*?]'
				cat ~/.ssh/known_hosts 2>/dev/null | cut -d' ' -f1 | tr ',' '\n' | sed 's/\[//;s/\].*//'
			} | sort -u
		)
		COMPREPLY=($(compgen -W "$hosts" -- "$cur"))
	elif [ "$COMP_CWORD" -eq 2 ]; then
		local host="${COMP_WORDS[1]}"
		local sessions
		sessions=$(ssh -o ConnectTimeout=2 "$host" '$SHELL -lc "tmux list-sessions -F \"#{session_name}\""' 2>/dev/null)
		COMPREPLY=($(compgen -W "$sessions" -- "$cur"))
	fi
}
complete -F _sta_completion sta
complete -F _sta_completion stl

#lol
function tng() {
	jg
	tn gym_score -d -n ''
	t neww -d -t 'gym_score' -n 'emulator'
	tmux split-window -h -t gym_score:emulator
	tmux split-window -v -t gym_score:emulator
	tmux send-keys -t gym_score:1.1 'aider --lint-cmd "dart analyze"' Enter
	tmux send-keys -t gym_score:1.0 'task emulator' Enter
	tmux send-keys -t gym_score:1.2 'gemini' Enter
	tmux send-keys -t gym_score:0 'vim ./' Enter
	ta gym_score
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

# the default way to start work: hand it what you'd give /auto-branch (an issue
# number or a task description), a headless haiku names the branch, then it
# worktrees+tmuxes into it and leaves claude open with the auto-branch command
# typed but NOT submitted, so there's still room to set model/effort first.
# An optional leading -m/--model picks the model claude launches with (e.g.
# opus, fable); the haiku branch-namer is unaffected.
#   gwtatauto 123
#   gwtatauto make the retry backoff jittered
#   gwtatauto -m opus 123
#   gwtatauto --model fable make the retry backoff jittered
function gwtatauto() {
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

	# bare issue number: pull the title so haiku has something to name the
	# branch after, falling back to issue/N if gh can't
	local naming_input="$desc"
	local issue_num="" issue_re='^#?[0-9]+$'
	if [[ "$desc" =~ $issue_re ]]; then
		issue_num="${desc#\#}"
		local title
		title=$(gh issue view "$issue_num" --json title -q .title 2>/dev/null)
		if [ -n "$title" ]; then
			naming_input="GitHub issue #${issue_num}: ${title}"
		else
			echo "couldn't fetch issue #${issue_num} via gh, falling back to issue/${issue_num}"
			naming_input=""
		fi
	fi

	local branch=""
	if [ -z "$naming_input" ]; then
		branch="issue/${issue_num}"
	else
		echo "asking haiku for a branch name..."
		local raw attempt branch_re='^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$'
		for attempt in 1 2; do
			raw=$(claude --model haiku -p "Reply with ONLY a git branch name for this task, nothing else - no prose, no quotes, no backticks. Format: type/short-kebab-description, where type is one of feat, fix, chore, refactor, docs or test and the description is 2-6 lowercase words joined by hyphens (a-z, 0-9 and - only, exactly one /). If the task references an issue number, start the description with it, e.g. fix/123-flaky-retry. Task: ${naming_input}")
			# last non-empty line, stripped of whitespace/quotes/backticks
			branch=$(printf '%s\n' "$raw" | awk 'NF{l=$0} END{print l}' | tr -d "[:space:]\`\"'")
			if [[ "$branch" =~ $branch_re ]] &&
				git check-ref-format --branch "$branch" >/dev/null 2>&1; then
				break
			fi
			branch=""
		done
		if [ -z "$branch" ]; then
			echo "haiku couldn't produce a valid branch name, last answer:"
			echo "$raw"
			return 1
		fi
	fi
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

# gwtatauto without the tmux: a headless haiku names the branch, gwta worktrees
# + cds into it, then claude opens right here in the current terminal. A plain
# foreground claude can't be handed the command typed-but-unsubmitted (that was a
# tmux send-keys trick), so the /auto-branch command is printed for you to paste,
# leaving room to set effort/model in the TUI first.
# An optional leading -m/--model picks the model claude launches with (e.g. opus,
# fable); the haiku branch-namer is unaffected.
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

	# bare issue number: pull the title so haiku has something to name the
	# branch after, falling back to issue/N if gh can't
	local naming_input="$desc"
	local issue_num="" issue_re='^#?[0-9]+$'
	if [[ "$desc" =~ $issue_re ]]; then
		issue_num="${desc#\#}"
		local title
		title=$(gh issue view "$issue_num" --json title -q .title 2>/dev/null)
		if [ -n "$title" ]; then
			naming_input="GitHub issue #${issue_num}: ${title}"
		else
			echo "couldn't fetch issue #${issue_num} via gh, falling back to issue/${issue_num}"
			naming_input=""
		fi
	fi

	local branch=""
	if [ -z "$naming_input" ]; then
		branch="issue/${issue_num}"
	else
		echo "asking haiku for a branch name..."
		local raw attempt branch_re='^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$'
		for attempt in 1 2; do
			raw=$(claude --model haiku -p "Reply with ONLY a git branch name for this task, nothing else - no prose, no quotes, no backticks. Format: type/short-kebab-description, where type is one of feat, fix, chore, refactor, docs or test and the description is 2-6 lowercase words joined by hyphens (a-z, 0-9 and - only, exactly one /). If the task references an issue number, start the description with it, e.g. fix/123-flaky-retry. Task: ${naming_input}")
			# last non-empty line, stripped of whitespace/quotes/backticks
			branch=$(printf '%s\n' "$raw" | awk 'NF{l=$0} END{print l}' | tr -d "[:space:]\`\"'")
			if [[ "$branch" =~ $branch_re ]] &&
				git check-ref-format --branch "$branch" >/dev/null 2>&1; then
				break
			fi
			branch=""
		done
		if [ -z "$branch" ]; then
			echo "haiku couldn't produce a valid branch name, last answer:"
			echo "$raw"
			return 1
		fi
	fi
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

function touche() {
	if [ -z "$1" ]; then
		echo "gib filename"
	else
		touch "$1"
		chmod a+x "$1"
		echo "#!/bin/bash" >>"$1"
	fi
}

function vime() {
	touche "$1"
	vim "$1"
}

function setdate() {
	if [ -z "$1" ]; then
		echo "gib date"
		return
	fi
	NEWDATE="$1 12:00:00"
	echo "timedatectl set-ntp 0 && timedatectl set-time $NEWDATE"
	sudo timedatectl set-ntp 0 && sudo timedatectl set-time "$NEWDATE"
}
function unsetdate() {
	echo "timedatectl set-ntp 1"
	sudo timedatectl set-ntp 1
}

function gobench() {
	if [ "$1" ]; then
		go test -bench=. -benchtime="$1s"
	else
		go test -bench=.
	fi
}

function include() {
	[[ -f "$1" ]] && source "$1"
}

include /etc/profile.d/autojump.zsh
include /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
include "$HOME/.host_profile"
include "$HOME/.flutter_completion"
include "$HOME/.copilot.zsh"
include "$HOME/.secret_profile"

if command -v fzf &>/dev/null; then
	eval "$(fzf --zsh 2>/dev/null)" || true
fi
if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh --cmd j)"
fi
if command -v emulator &>/dev/null; then
	complete -W "$(emulator -list-avds | sed '1d' | sed 's/^/@/g')" emulator
fi
# lazy-load pyenv; shims on PATH immediately, full init deferred until first use
if command -v pyenv &>/dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
	[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
	export PATH="$PYENV_ROOT/shims:$PATH"
	pyenv() {
		unset -f pyenv
		eval "$(command pyenv init - zsh)"
		pyenv "$@"
	}
fi

if [ ! -f "$HOME/.tmux-themepack/powerline/default/cyan.tmuxtheme" ]; then
	echo -e "no tmux theme;\ngit clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack"
fi
export DEFAULT_USER="rcarrier"
unsetopt nomatch
if [ "$(uname)" = "Darwin" ]; then
	include "$HOME/.mac.sh"
else
	export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
	_nvm_init=""
	if [ -f "/usr/share/nvm/init-nvm.sh" ]; then
		_nvm_init="/usr/share/nvm/nvm.sh"
	elif [ -f "$NVM_DIR/nvm.sh" ]; then
		_nvm_init="$NVM_DIR/nvm.sh"
	fi
	if [ -n "$_nvm_init" ]; then
		# add default node bin to PATH immediately so all global binaries work
		if [ -f "$NVM_DIR/alias/default" ]; then
			_nvm_ver="$(<"$NVM_DIR/alias/default")"
			while [ -f "$NVM_DIR/alias/$_nvm_ver" ]; do
				_nvm_ver="$(<"$NVM_DIR/alias/$_nvm_ver")"
			done
			case "$_nvm_ver" in
			stable) _nvm_node_path="$(ls -d "$NVM_DIR/versions/node/"* 2>/dev/null | sort -rV | head -1)" ;;
			*) _nvm_node_path="$(ls -d "$NVM_DIR/versions/node/v${_nvm_ver#v}"* 2>/dev/null | sort -rV | head -1)" ;;
			esac
			[ -d "$_nvm_node_path/bin" ] && export PATH="$_nvm_node_path/bin:$PATH"
			unset _nvm_ver _nvm_node_path
		fi
		# lazy-load nvm function only; node/npm/tsc/etc already work via PATH
		nvm() {
			unset -f nvm
			source "$_nvm_init" --no-use
			[ -f "/usr/share/nvm/bash_completion" ] && source /usr/share/nvm/bash_completion
			unset _nvm_init
			nvm "$@"
		}
	fi
fi

# rbenv init must run after .mac.sh to ensure shims are at front of PATH
if command -v rbenv &>/dev/null; then
	eval "$(rbenv init - zsh)"
fi
# cache gem home dir; auto-invalidates when ruby version changes
if command -v gem >/dev/null 2>&1; then
	_gem_cache="$HOME/.cache/gem_home"
	if [[ -f "$_gem_cache" ]] && [[ -d "$(<"$_gem_cache")" ]]; then
		GEM_HOME="$(<"$_gem_cache")"
	else
		GEM_HOME="$(gem env user_gemhome)"
		mkdir -p "$HOME/.cache"
		printf '%s' "$GEM_HOME" >"$_gem_cache"
	fi
	export PATH="$PATH:$GEM_HOME/bin"
	export GEM_HOME
	unset _gem_cache
fi
