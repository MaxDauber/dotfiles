
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
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Set editing mode to vim in bash
set -o vi

# Aliases
alias dc="cd"
alias ll='ls -altrh'
alias la='ls -A'
alias l='ls -CF'
alias sl="ls"
alias la="ls -Al"
alias bc="bc -l"

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

source ~/.dotfiles/.bashrc
