export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_HIDE_IF_PWD_IGNORED=true
export GIT_PS1_SHOWCOLORHINTS=true

# In Arch Linux the git prompt isn't sourced by default,
# so do that if __git_ps1 isn't already defined.
if ! hash __git_ps1 2>/dev/null && [[ -e /usr/share/git/git-prompt.sh ]]; then
    source /usr/share/git/git-prompt.sh
fi

# 256 colors:
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

virtualenv_prompt () {
    if [[ $VIRTUAL_ENV != "" ]]; then
        # Strip out the path and just leave the env name
        echo "[${VIRTUAL_ENV##*/}]"
    fi
}

PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command() {
    local EXIT="$?"             # This needs to be first
    PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[1;38;5;220m\]\u@\h\[\033[00m\] \[\033[1;38;5;10m\]\w\[\033[00m\]\[\033[1;38;5;159m\] $(__git_ps1 " %s")\[\033[00m\] \[\033[0;38;5;222m\]$(virtualenv_prompt)\[\033[0m\]\n'

    local RCol='\[\e[0m\]'

    local Red='\[\e[0;31m\]'
    local Gre='\[\e[0;32m\]'
    local BYel='\[\e[1;33m\]'
    local BBlu='\[\e[1;34m\]'
    local Pur='\[\e[0;35m\]'

    if [ $EXIT != 0 ]; then
        PS1+="[${Red}${EXIT}${RCol}]"      # Add red if exit code non 0
    else
        PS1+="[0]"
    fi
    PS1+="▶ "
    #PS1+="${RCol}@${BBlu}\h ${Pur}\W${BYel}$ ${RCol}"
}

#export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[1;38;5;220m\]\u@\h\[\033[00m\] \[\033[1;38;5;10m\]\w\[\033[00m\]\[\033[1;38;5;159m\] $(__git_ps1 " %s")\[\033[00m\] \[\033[0;38;5;222m\]$(virtualenv_prompt)\[\033[0m\]\n[\j]▶ '
