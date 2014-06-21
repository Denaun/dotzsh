# Should speed up
skip_global_compinit=1

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.zsh/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="miloshadzic"
#miloshadzic
#fwalch
#sporty_256
#sorin
#geoffgarside
#daveverwer
#mrtazz
#fishy
#robbyrussell
#fino

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git zsh-syntax-highlighting gem);
case $OSTYPE in
  darwin*)
    plugins+=(osx brew terminalapp cloudapp);
    ;;
  linux*)
    plugins+=(debian);
    ;;
esac
# vi-mode	removed because it disables shift-tab
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets patterns)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

case $OSTYPE in
  darwin*)
    source $HOME/.profile
    ;;
esac

# List directory contents after a 'cd'
# (Only if the output will be less then 20 lines long)
function chpwd()
{
  emulate -LR zsh

  if [[ `ls -AC | wc -l` -le 20 ]]
  then
    ls -A
  fi
}

# Named directories
export dbox=~/Dropbox/
export work=~dbox/Appunti/Magistrale/Secondo\ Anno/Primo\ Semestre/
export shared=~dbox/Appunti/Universita\`/

# Extended Move Command
autoload -U zmv
alias mmv='noglob zmv -W'

# Enable patterns in history search
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

bid()
{
  local shortname location

  # combine all args as regex
  # (and remove ".app" from the end if it exists due to autocomplete)
  shortname=$(echo "${@%%.app}"|sed 's/ /.*/g')
  # if the file is a full match in apps folder, roll with it
  if [ -d "/Applications/$shortname.app" ]; then
    location="/Applications/$shortname.app"
  else # otherwise, start searching
    location=$(mdfind -onlyin /Applications -onlyin ~/Applications -onlyin /Developer/Applications 'kMDItemKind==Application'|awk -F '/' -v re="$shortname" 'tolower($NF) ~ re {print $0}'|head -n1)
  fi
  # No results? Die.
  [[ -z $location || $location = "" ]] && echo "$1 not found, I quit" && return
  # Otherwise, find the bundleid using spotlight metadata
  bundleid=$(mdls -name kMDItemCFBundleIdentifier -r "$location")
  # return the result or an error message
  [[ -z $bundleid || $bundleid = "" ]] && echo "Error getting bundle ID for \"$@\"" || echo "$location: $bundleid"
}
