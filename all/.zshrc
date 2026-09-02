# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="daveverwer"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=60

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
plugins=(git golang colored-man-pages rust command-not-found common-aliases pip python ssh-agent web-search zsh-autosuggestions)

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/rcarrier/.dart-cli-completion/zsh-config.zsh ]] && . /home/rcarrier/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# custom completions (must be before oh-my-zsh compinit)
fpath+=~/.zfunc
# the AUR package installs the binary as `go-task`, homebrew's as `task`.
# the completion shells out to $TASK_EXE to list tasks, so it must be the real
# name or task-name completion silently comes back empty.
if command -v go-task &>/dev/null; then
	export TASK_EXE=go-task
else
	export TASK_EXE=task
fi

# skip compaudit directory security check on startup
ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh

# register task completion for both command names
if [[ -f ~/.zfunc/_task ]]; then
	source ~/.zfunc/_task
	compdef _task task go-task
fi

source ~/.rcarrier_profile.sh

# --- herdr: tmux-style automatic tab rename -------------------------------
# Herdr has no native automatic-rename, so mimic tmux: label the current tab
# after the running command, and fall back to the directory name when idle.
# Only active inside a herdr-managed pane (HERDR_TAB_ID is injected per pane).
if [[ "${HERDR_ENV:-}" == 1 && -n "${HERDR_TAB_ID:-}" ]] && command -v herdr >/dev/null 2>&1; then
  _herdr_rename_tab() { herdr tab rename "$HERDR_TAB_ID" "$1" >/dev/null 2>&1 }
  _herdr_preexec() { local w=${1%% *}; _herdr_rename_tab "${w:t}" }        # running: command name
  _herdr_precmd()  { local d=${PWD:t}; [[ $PWD == $HOME ]] && d="~"; _herdr_rename_tab "$d" }  # idle: dir name
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _herdr_preexec
  add-zsh-hook precmd  _herdr_precmd
fi
# -------------------------------------------------------------------------
