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
export PATH="$PATH:/home/rcarrier/.shorebird/bin"
export PATH=/home/rcarrier/.opencode/bin:$PATH
export PATH="$PATH:/home/rcarrier/.turso"
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

#?? idk
fpath+=~/.zfunc

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
unalias gwta

# git worktree add $1 .worktrees/$1
# (or with -b if the branch doesn't exist)
function gwta() {
	if [ -z "$1" ]; then
		echo "gib branch name"
		return
	fi
	# if does not worktree exists, create it
	if [ -d ".worktrees/$1" ]; then
		echo ".worktrees/$1 already exists"
	else
		mkdir -p .worktrees
		# check if branch exists
		if git show-ref --verify --quiet "refs/heads/$1"; then
			echo "branch $1 exists, checking out"
			git worktree add ".worktrees/$1" "$1"
			echo "checked out to .worktrees/$1"
		else
			git worktree add -b "$1" ".worktrees/$1"
			echo "created and checked out to .worktrees/$1"
		fi
	fi
	# by default cd into the new worktree, unless they anwer n to the prompt
	echo -n "cd into .worktrees/$1? (Y/n) "
	read -r response
	if [[ "$response" != "n" && "$response" != "N" ]]; then
		cd ".worktrees/$1" || return
	fi
}

# remove the worktree, if we are in the work tree, then cd back out
# then remove the directory
function gwtr() {
	if [ -z "$1" ]; then
		echo "gib branch name"
		return
	fi
	if [ "$(basename "$PWD")" = "$1" ] || [ "$(basename "$(dirname "$PWD")")" = "$1" ]; then
		cd ../../ || return
	fi
	git worktree remove ".worktrees/$1"
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
