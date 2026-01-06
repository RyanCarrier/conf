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
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
plugins=(git golang colored-man-pages rust command-not-found common-aliases pip python ssh-agent web-search zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source ~/.rcarrier_profile.sh

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/rcarrier/.dart-cli-completion/zsh-config.zsh ]] && . /home/rcarrier/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]



# opencode
export PATH=/home/rcarrier/.opencode/bin:$PATH

# Turso
export PATH="$PATH:/home/rcarrier/.turso"
# Added by Antigravity
export PATH="/Users/rcarrier/.antigravity/antigravity/bin:$PATH"
