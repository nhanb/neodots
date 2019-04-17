# python stuff
alias py3="python3"
alias py="python"
alias ipy3="ipython3"
alias ipy="ipython"

# git
alias g="git"
alias gac="git add . && git commit"
alias gacm="git add . && git commit -m"
alias gaca="git add . && git commit --amend"
alias glg="git log"
alias glo="git log --oneline"
alias gl="git pull"
alias gf="git fetch"
alias gp="git push"
alias gr="git rebase"
alias gst="git status"
alias gd="git diff"
alias gdc="git diff --cached"
alias gco="git checkout"
alias gb="git branch"
alias gm="git merge"

# make sure no weird TERM for ssh sessions
alias ssh='TERM=screen-256color ssh'

# mkdir then cd into it
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# xfce-specific:
alias nocaps='/usr/bin/setxkbmap -option "ctrl:nocaps"' # turn capslock => ctrl

# load tmuxp session
alias tm='tmuxp load'

# test 256 colors
function colortest () {
    awk 'BEGIN{
        s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
        for (colnum = 0; colnum<77; colnum++) {
            r = 255-(colnum*255/76);
            g = (colnum*510/76);
            b = (colnum*255/76);
            if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,colnum+1,1);
        }
        printf "\n";
    }'
}

function formattest () {
    echo -e "\e[1mbold\e[0m"
    echo -e "\e[3mitalic\e[0m"
    echo -e "\e[4munderline\e[0m"
    echo -e "\e[9mstrikethrough\e[0m"
}

# There's no built in way to use multiple docker hub accounts because reasons
# https://stackoverflow.com/q/47262489
function docker-switch () {
    echo -e "Switching to \e[1m~/.docker/config.$1.json\e[0m"
    cp "$HOME/.docker/config.$1.json" "$HOME/.docker/config.json"
}
alias ds=docker-switch

# Helpers to open shells in running docker containers managed by docker-compose:
psh () {
    this_dir=$(basename "$PWD")
    parent_dir=`basename $(dirname "$PWD")`
    container_name="${parent_dir}_${this_dir}_1"
    docker exec -it "$container_name" sh -l
}

vman() {
    vim -c "SuperMan $*"
    if [ "$?" != "0" ]; then
        echo "No manual entry for $*"
    fi
}
