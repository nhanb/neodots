export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_HIDE_IF_PWD_IGNORED=true
export GIT_PS1_SHOWCOLORHINTS=true

# In Arch Linux the git prompt isn't sourced by default,
# so do that if __git_ps1 isn't already defined.
hash __git_ps1 2>/dev/null || \
    [[ -e /usr/share/git/git-prompt.sh ]] && \
    source /usr/share/git/git-prompt.sh

# 256 colors:
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

virtualenv_prompt () {
    if [[ $VIRTUAL_ENV != "" ]]; then
        # Strip out the path and just leave the env name
        echo "[${VIRTUAL_ENV##*/}]"
    fi
}

export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[1;38;5;220m\]\u@\h\[\033[00m\] \[\033[1;38;5;10m\]\w\[\033[00m\]\[\033[1;38;5;159m\] $(__git_ps1 " %s")\[\033[00m\] \[\033[0;38;5;222m\]$(virtualenv_prompt)\[\033[0m\]\n[\j]▶ '
