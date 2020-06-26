# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
#export ZSH=/Users/ywpu/.oh-my-zsh

#ZSH_THEME=“Max’s Profile”

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git composer pip python sudo)

#source $ZSH/oh-my-zsh.sh


# Add pyenv init to your shell to enable shims and autocompletion.
# Please make sure `eval "$(pyenv init -)"` is placed toward the end of the shell configuration file
# since it manipulates `PATH` during the initialization.
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

#autocomplete git
# autoload -Uz compinit && compinit

#
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'


# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# Setting PATH for Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$(pyenv root)/shims:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Set editing mode to vim in bash
set -o vi

# Aliases
alias dc="cd"
alias ll='ls -Galtrh'
alias la='ls -A'
alias l='ls -CF'
alias sl="ls"
alias la="ls -Al"
alias bc="bc -l"
alias ecrlogin='eval $(aws ecr get-login --no-include-email)'
alias gerp='grep'
alias tailf="tail -f"

# Custom shortcuts
alias clean='rm -f "#"* "."*~ *~ *.bak *.dvi *.aux *.log' # Delete temp files
alias q='exit'
alias c='clear'
alias h='history'
alias cs='clear;ll' # Clear and list
alias p='cat'
alias rf='rm -rf'
alias vim='vim -p' 

alias install='sudo apt-get --yes --force-yes install'
alias search='sudo apt-cache search'
alias mkdir="mkdir -pv"

# Git aliases
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gbv='git branch -av'
alias gc='git commit -m'
alias gcv='git commit'
alias gch='git checkout'
alias gd='git diff -w --ignore-blank-lines'
alias gdv='git diff'
alias gf='git fetch'
alias gl='git log --oneline -n 10'
alias gll='git log --all --decorate --graph --oneline'
alias gllv='git log --all --decorate --graph'
alias gm='git merge'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gr='git rebase'
alias gcl='git clone'
alias gst='git stash'

# Python aliases
alias p='python'
alias p2='python2'
alias p3='python3'
export EDITOR=vim

# Overwrites cd so every cd is followed by an ls
function cd() {
    new_directory="$*";
    if [ $# -eq 0 ]; then
        new_directory=${HOME};
    fi;
    builtin cd "${new_directory}" && ls
}

# Detects file type and applies corresponding flags when extracting
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)	tar xjf $1		;;
            *.tar.gz)	tar xzf $1		;;
            *.bz2)		bunzip2 $1		;;
            *.rar)		rar x $1		;;
            *.gz)		gunzip $1		;;
            *.tar)		tar xf $1		;;
            *.tbz2)		tar xjf $1		;;
            *.tgz)		tar xzf $1		;;
            *.zip)		unzip $1		;;
            *.Z)		uncompress $1	;;
            *)			echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Set default editor
export EDITOR=vim

# Overwrites cd so every cd is followed by an ls
function cd() {
    new_directory="$*";
    if [ $# -eq 0 ]; then
        new_directory=${HOME};
    fi;
    builtin cd "${new_directory}" && ls
}

# Save original user path 
export MY_ORIGINAL_PATH=$PATH

# Change to python env to conda env
use_conda() {
#    export PATH="/home/max/miniconda3/bin:$PATH"  # commented out by conda initialize
    echo "Conda has been activated"
}

# Login to ECR with fallback for users on AWS CLI >= 2.0.
# Usage ecrlogin [optional endpoint]
# By default will attempt to determine endpoint from values set within your okta profile
function ecrlogin {
  ENDPOINT="$1"
  if [ -z "$ENDPOINT" ] && aws ecr get-login >& /dev/null; then
    echo "get-login is no longer supported in newer versions of awscli.  Please update to the latest version." >&2
    eval "$(aws ecr get-login --no-include-email)"
  else
    (
      set -o pipefail
      if [ -z "$ENDPOINT" ]; then
        ID=$(aws sts get-caller-identity | jq -r .Account)
        if [ -z "$ID" ]; then
          echo "Could not determine identity, run with aws-okta exec" >&2
          return
        fi
        if [ -z "$AWS_REGION" ]; then
          echo "Could not determine region, run with aws-okta exec" >&2
          return
        fi
        ENDPOINT="$ID.dkr.ecr.$AWS_REGION.amazonaws.com"
      fi
      aws ecr get-login-password | docker login --username AWS --password-stdin "$ENDPOINT"
    )
  fi
}

# Change to python env to system env
use_original() {
    if [ -x "$(command -v conda)" ]; then
        source deactivate
    fi
    export PATH=$MY_ORIGINAL_PATH
    echo "Restored original PATH"
    python --version
} 
function scontext() {
    eval $(aws-okta env $1 --mfa-factor-type push --mfa-provider OKTA)
    export KUBECONFIG=$HOME/.kube/config-$2
    kubectl config use-context $2
}

alias aws-dev='aws-okta env dev > out ; source out ; rm out' 
alias aws-prod='aws-okta env prod > out ; source out ; rm out' 
alias kubeprod='scontext prod prod'
alias kubedev='scontext dev dev'


#source ~/.dotfiles/.bashrc
#source ~/.dotfiles/.inputrc
#source ~/.dotfiles/.vimrc
