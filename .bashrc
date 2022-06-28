# Activate autoenv
# source /Library/Frameworks/Python.framework/Versions/3.7/bin/activate.sh
# cd .


source ~/.dotfiles/.bash_profile

# Activate Virtualenv
export WORKON_HOME=~/.virtualenvs
# VIRTUALENVWRAPPER_PYTHON=$(which python)
# source /Users/maxdauber/.pyenv/shims/virtualenvwrapper.sh
pyenv virtualenv-init -
pyenv virtualenvwrapper_lazy


# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo " on ${BRANCH}"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

function ss() {
  if [[ "$#" == 0 || "$1" == "help" ]]; then
    echo "ss exec <simple_stack_name> <command>- run command in pod, command arg defaults to bash shell if not supplied"
    echo "ss logs <simple_stack_name> watch - get logs from pod, watch is optional and acts like tail -f"
    echo "ss cp <simple_stack_name> <local_file/dir> <remote_path/file_name> - copy file from local to remote pod"
    echo "ss get <simple_stack_name> <remote_file/dir> <local_path/file_name> - copy file from remote pod to local"
    echo "ss pod <simple_stack_name> - Get pod name"
    echo "------------------------------------------"
    echo "Reference Docs - https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands"
    return;
  fi

  if [ -z "${AWS_PROFILE}" ]; then
    echo "AWS_PROFILE env variable needs to be set, please refer to https://primer.atlassian.net/wiki/spaces/DEVOPS/pages/567836772/Primer+SimpleStack+Slack+Bot"
    return;
  fi

  if ! [ -x "$(command -v kubectl)" ]; then
    echo "kubectl is not installed, please refer to https://primer.atlassian.net/wiki/spaces/DEVOPS/pages/267288586/Kubernetes"
    return
  fi

  if ! type scontext &>/dev/null; then
    echo "scontext switcher is not in bash_profile, please refer \"Helpful Bash Functions section\" of https://primer.atlassian.net/wiki/spaces/DEVOPS/pages/267288586/Kubernetes"
    return
  fi

  if ! [ -f "$HOME/.kube/config" ] && [ -z "$KUBECONFIG" ]; then
    echo "kube config does not exist, please refer to https://primer.atlassian.net/wiki/spaces/DEVOPS/pages/267288586/Kubernetes"
    return
  fi

  ns="simple-stack"
  pod=$(kubectl -n $ns get pods --field-selector=status.phase=Running | grep -w "$2"| awk '{print $1}')
  if [ "$1" == "exec" ]; then
    if [ "$#" -lt  "3" ]; then
      kubectl -n $ns exec -it $pod -- /bin/bash
    else
      shift 2
      kubectl -n $ns exec -it $pod -- $@
    fi
  elif [ "$1" == "logs" ]; then
    if [ "$3" ==  "watch" ]; then
      kubectl -n $ns logs -f $pod
    fi
    kubectl -n $ns logs $pod
  elif [ "$1" == "pod" ]; then
    echo $pod
  elif [ "$1" == "cp" ]; then
    kubectl cp $3 $ns/$pod:$4
  elif [ "$1" == "get" ]; then
    kubectl cp $ns/$pod:$3 $4
  elif [ "$1" == "restart" ]; then
    kubectl -n $ns delete --force --grace-period=0 pod $pod
  else
    ss help
  fi
}

export PS1="\[\e[01;36m\]\u\[\e[m\]@\h in \[\e[01;31m\]\W\[\e[m\]\[\e[01;35m\]\`parse_git_branch\`\[\e[m \n$ "
