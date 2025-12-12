if ! command -v brew &>/dev/null; then
	echo "need brew"
fi
# /opt/homebrew/share/zsh/site-functions
# unset task
#
export LANG="en_AU.UTF-8"
export LC_ALL="en_AU.UTF-8"
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

	autoload -Uz compinit
	compinit
fi
CHROME_EXECUTABLE=/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# eval "$(rbenv init -)"
# check if rbenv is installed
if command -v rbenv &>/dev/null; then
	eval "$(rbenv init - zsh)"
fi

#RUBY
if command -v gem >/dev/null 2>&1; then
	GEM_HOME="$(gem env user_gemhome)"
	export PATH="$PATH:$GEM_HOME/bin"
	export GEM_HOME
fi
