# git
alias g="git"
alias gac="git add . && git commit"
alias gacm="git add . && git commit -m"
alias gaca="git add . && git commit --amend"
alias glg="git log"
alias gl="git pull"
alias gf="git fetch"
alias gp="git push"
alias gr="git rebase"
alias gst="git status"
alias gd="git diff"
alias gdc="git diff --cached"

# mkdir then cd into it
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }
