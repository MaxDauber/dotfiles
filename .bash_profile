
# If not running interactively, don't do anything

[ -z "$PS1" ] && return

export BASH_SILENCE_DEPRECATION_WARNING=1

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
# export PATH

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
export PROJECT_HOME=$HOME/dev
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
alias gerp='grep'
alias tailf="tail -f"
alias aosh='aws-okta exec dev --mfa-factor-type push --mfa-provider OKTA -- bash'
alias ecrlogin='aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 963188529772.dkr.ecr.us-west-2.amazonaws.com'
alias dk='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

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
alias mt='make tidy lint-flake8 lint-pylint test-unit'

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
alias gmainx='CURR_BRANCH=$(git branch --show-current) && git checkout main && git pull && git checkout $CURR_BRANCH && git merge main'
alias gmastx='CURR_BRANCH=$(git branch --show-current) && git checkout master && git pull && git checkout $CURR_BRANCH && git merge master'
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

function scontext() {    # Used to switch between clusters, your AWS profile names must match kube config names (dev, devops, prod) 
    aws_env=$1
    cluster_alias=${2-$aws_env}   # second paramter or aws if no second parameter provided
    eval $(aws-okta env $aws_env --mfa-factor-type push --mfa-provider OKTA)
    export KUBECONFIG=$HOME/.kube/config-$cluster_alias
    kubectl config use-context $cluster_alias
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

# Change to python env to system env
use_original() {
    if [ -x "$(command -v conda)" ]; then
        source deactivate
    fi
    export PATH=$MY_ORIGINAL_PATH
    echo "Restored original PATH"
    python --version
} 
#source ~/.dotfiles/.bashrc
#source ~/.dotfiles/.inputrc
#source ~/.dotfiles/.vimrc

## Start setup functions
# The following functions came from:
# https://github.com/PrimerAI/getting-started/blob/main/config-files/helper_functions.sh

function which_shell(){
    if [[ "$SHELL" =~ "bash" ]]; then
        echo "bash"
    elif [[ "$SHELL" =~ "zsh" ]]; then
        echo "zsh"
    else
        echo "Not sure which shell."
    fi
}

## AWS Okta
# Launch a shell based on provided profile
function aosh() {
    if [[ "$#" -lt "1" ]]; then
        echo "usage: aosh <profile>"
    else
        aws-okta exec "$1" --mfa-factor-type push --mfa-provider OKTA -- "$(which_shell)"
    fi
}

# Login to ECR with fallback for users on AWS CLI >= 2.0.
# Usage ecrlogin [optional endpoint]
# By default will attempt to determine endpoint from values set within your okta profile
function ecrlogin {
    ENDPOINT="$1"
    if [[ -z "$ENDPOINT" ]] && aws ecr get-login >& /dev/null; then
        echo "get-login is no longer supported in newer versions of awscli.  Please update to the latest version." >&2
        eval "$(aws ecr get-login --no-include-email)"
    else
        (
            set -o pipefail
            if [[ -z "$ENDPOINT" ]]; then
                ID=$(aws sts get-caller-identity | jq -r .Account)
                if [[ -z "$ID" ]]; then
                    echo "Could not determine identity, run with aws-okta exec" >&2
                    return
                fi
                if [[ -z "$AWS_REGION" ]]; then
                    echo "Could not determine region, run with aws-okta exec" >&2
                    return
                fi
                ENDPOINT="$ID.dkr.ecr.$AWS_REGION.amazonaws.com"
            fi
            aws ecr get-login-password | docker login --username AWS --password-stdin "$ENDPOINT"
        )
    fi
}

# shellcheck source=/dev/null
[[ -r "$HOME/.primer" ]] && . "$HOME/.primer"

## End setup functions
