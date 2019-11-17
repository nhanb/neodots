# disable greeting line on startup
set fish_greeting

# neovim all the things
abbr -a -g vim nvim
abbr -a -g vi nvim
set -Ux EDITOR nvim
set -Ux GIT_EDITOR nvim
set -Ux VISUAL nvim

# python stuff
abbr -a -g py3 python3
abbr -a -g py python
abbr -a -g bpy bpython
abbr -a -g pup pip install --upgrade pip

# git
abbr -a -g g git
abbr -a -g gac 'git add -A && git commit'
abbr -a -g gacm 'git add . && git commit -m'
abbr -a -g gaca 'git add . && git commit --amend'
abbr -a -g glg git log
abbr -a -g glo git log --oneline
abbr -a -g gl git pull
abbr -a -g gf git fetch
abbr -a -g gp git push
abbr -a -g gr git rebase
abbr -a -g gst git status
abbr -a -g gd git diff
abbr -a -g gdc git diff --cached
abbr -a -g gco git checkout
abbr -a -g gb git branch
abbr -a -g gm git merge

# load tmuxp session
abbr -a -g tm 'tmuxp load'

# make sure no weird TERM for ssh sessions
abbr -a -g ssh env TERM=screen-256color ssh

# mkdir then cd into it
function mkcd
    mkdir -pv $argv
    cd $argv
end

# test term formatting features
function formattest
    echo -e "\e[1mbold\e[0m"
    echo -e "\e[3mitalic\e[0m"
    echo -e "\e[4munderline\e[0m"
    echo -e "\e[9mstrikethrough\e[0m"
end

# Helpers to open shells in running docker containers managed by docker-compose:
function psu
    set this_dir (basename "$PWD")
    set parent_dir (basename (dirname $PWD))
    set container_name "$parent_dir"_"$this_dir"_1
    docker exec -it "$container_name" su
end

# PATH stuff
set PATH \
    "$HOME/binaries" \
    "$HOME/.nimble/bin" \
    "$HOME/.node_modules/bin" \
    $PATH
set npm_config_prefix "$HOME/.node_modules"

# Pyenv is a bit more involved
if test -d ~/.pyenv
    source ~/neodots/fish/pyenv.fish
end
