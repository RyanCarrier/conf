#!/bin/bash

# if RCARRIER_PROFILE_LOADED is set, return
# if [ -n "$RCARRIER_PROFILE_LOADED" ]; then
# 	echo "RCARRIER_PROFILE_LOADED is set, returning"
# 	return
# fi
# export RCARRIER_PROFILE_LOADED=1

export GOROOT=/usr/lib/go
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
export EDITOR=vim

export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:/opt/flutter/bin
export PATH=$PATH:/usr/local/flutter/bin
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

if command -v rustc >/dev/null 2>&1; then
	RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
	export RUST_SRC_PATH
fi

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
alias gcamend="git commit --amend"
unalias gwta

# git worktree add in parent directory as reponame_branchname
# (or with -b if the branch doesn't exist)
function gwta() {
	if [ -z "$1" ]; then
		echo "gib branch name"
		return
	fi
	# get repo root and name
	local repo_root
	repo_root=$(git worktree list | head -1 | awk '{print $1}')
	local repo_name
	repo_name=$(basename "$repo_root")
	local parent_dir
	parent_dir=$(dirname "$repo_root")

	# replace / with _ for directory name
	local branch_dir="${1//\//_}"
	local worktree_path="${parent_dir}/${repo_name}_${branch_dir}"

	# if worktree already exists, just offer to cd
	if [ -d "$worktree_path" ]; then
		echo "$worktree_path already exists"
	else
		# check if local branch exists
		if git show-ref --verify --quiet "refs/heads/$1"; then
			echo "branch $1 exists locally, checking out"
			git worktree add "$worktree_path" "$1"
			echo "checked out to $worktree_path"
		# check if remote branch exists
		elif git show-ref --verify --quiet "refs/remotes/origin/$1"; then
			echo "branch $1 exists on remote, checking out"
			git worktree add "$worktree_path" "$1"
			echo "checked out to $worktree_path"
		else
			git worktree add -b "$1" "$worktree_path"
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

# completion for gwta - complete on local and remote branches
_gwta_completions() {
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local branches
	# get local and remote branches, strip remote prefix
	branches=$(git branch -a 2>/dev/null | sed 's/^[* ]*//' | sed 's|remotes/origin/||' | grep -v '^HEAD' | sort -u)
	COMPREPLY=($(compgen -W "$branches" -- "$cur"))
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
alias t="tmux"
# alias ta="tmux attach"
alias tn="tmux new-session -s"
alias tl="tmux ls"
## Project specific
alias jg="j gym_"
alias vimlc="vim leetcode.nvim"
alias claude_api="unset CLAUDE_CODE_OAUTH_TOKEN && claude"
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

function gwtat() {
	if [ -z "$1" ]; then
		echo "gib branch name"
		return 1
	fi
	gwta "$1"
	tn "$1" -d
	# tmux send-keys -t "$1":0 'claude' Enter
	ta "$1"
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
	fzfversion=$(fzf --version | awk '{print $1}')
	# if fzfversion >= 0.48
	if [ "$fzfversion" = "$(echo -e "$fzfversion\n0.48" | sort -V | tail -n1)" ]; then
		eval "$(fzf --zsh)"
	fi
fi
if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh --cmd j)"
fi
if command -v emulator &>/dev/null; then
	complete -W "$(emulator -list-avds | sed '1d' | sed 's/^/@/g')" emulator
fi
if command -v pyenv &>/dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
	[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init - zsh)"
fi

if [ ! -f "$HOME/.tmux-themepack/powerline/default/cyan.tmuxtheme" ]; then
	echo -e "no tmux theme;\ngit clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack"
fi
export DEFAULT_USER="rcarrier"
unsetopt nomatch
if [ "$(uname)" = "Darwin" ]; then
	include "$HOME/.mac.sh"
else
	if [ -f "/usr/share/nvm/init-nvm.sh" ]; then
		include /usr/share/nvm/init-nvm.sh
	elif [ -f "$HOME/.nvm/nvm.sh" ]; then
		include "$HOME/.nvm/nvm.sh"
	fi
fi
