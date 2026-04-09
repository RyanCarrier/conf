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

export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

export PATH="/Users/rcarrier/.antigravity/antigravity/bin:$PATH"
export DOCKER_HOST=unix://$HOME/.colima/default/docker.sock
# check if java 21 is installed and set JAVA_HOME
if [ -d "/opt/homebrew/opt/openjdk@21" ]; then
	export JAVA_HOME="$(/usr/libexec/java_home -v 21)"
fi
if [ -d "/opt/homebrew/share/android-commandlinetools" ]; then
	export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
	export ANDROID_SDK_ROOT=$ANDROID_HOME
	export PATH=$PATH:$ANDROID_HOME/platform-tools
fi
# PATH="/opt/homebrew/opt/ruby/bin:$PATH"  # conflicts with rbenv shims
# eval "$(/usr/libexec/path_helper)"  # reshuffles PATH, pushes system ruby ahead of rbenv
