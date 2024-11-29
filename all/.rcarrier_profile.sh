#!/bin/bash
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
export PATH=$PATH:"$ANDROID_SDK_ROOT"
export PATH=$PATH:"$ANDROID_SDK_ROOT/platform-tools"
export PATH=$PATH:"$ANDROID_SDK_ROOT/emulator"
export PATH=$PATH:"$ANDROID_SDK_ROOT/tools/bin"
export PATH=$PATH:"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
export PATH=$PATH:"$HOME/.pub-cache/bin"
export PATH=$PATH:"$HOME/.cargo/bin"
export PATH=$PATH:"$JAVA_HOME/bin"
#RUBY

if [ -x "$(command -v gem >/dev/null 2>&1)" ]; then
	GEM_HOME="$(gem env user_gemhome)"
	export PATH="$PATH:$GEM_HOME/bin"
fi
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
	PATH=$PATH:"$HOME/bin"
fi

if [ -x "$(command -v rustc >/dev/null 2>&1)" ]; then
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
unset rm #overwrite oh my zsh rm -i
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
alias xo="xdg-open"
alias p1="ping 1.1.1.1"
alias ip='ip -color=auto'
alias vim='nvim'
alias grep='rg'
alias neovide='env -u WAYLAND_DISPLAY neovide'
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
alias lns="ln -s"
alias t="tmux"
# alias ta="tmux attach"
alias tn="tmux new-session -s"
alias tl="tmux ls"
## Project specific
alias jg="j gym_"
alias vimlc="vim leetcode.nvim"
alias icat="kitten icat"
# unset gl

alias feh="feh --scale-down"
if command -v go-task &>/dev/null; then
	alias task="go-task"
fi

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
	tn gym_score -d -n 'vim'
	t neww -d -t 'gym_score' -n 'emulator'
	tmux send-keys -t gym_score:emulator 'task emulator' Enter
	tmux send-keys -t gym_score:vim 'vim ./' Enter
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

if [ ! -f "$HOME/.tmux-themepack/powerline/default/cyan.tmuxtheme" ]; then
	echo -e "no tmux theme;\ngit clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack"
fi
export DEFAULT_USER="rcarrier"
unsetopt nomatch
if [ "$(uname)" = "Darwin" ]; then
	include "$HOME/.mac.sh"
else
	include /usr/share/nvm/init-nvm.sh
fi
