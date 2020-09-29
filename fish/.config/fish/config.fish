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
abbr -a -g ipy ipython
abbr -a -g bpy bpython
abbr -a -g pup pip install --upgrade pip
abbr -a -g pr poetry run
abbr -a -g prp poetry run python

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

# docker *dun dun dunnnnn*
abbr -a -g dc docker-compose

# C stuff
abbr -a -g gdbb gdb --batch --ex run --ex bt --ex q --args

# load tmuxp session
abbr -a -g tm 'tmuxp load'

# misc stuff
abbr -a -g time time -p

# project-specific
abbr -a -g mn caophim-manage

# mkdir then cd into it
function mkcd
    mkdir -pv $argv
    cd $argv
end

# test term formatting features
function testformat
    echo -e "\e[1mbold\e[0m"
    echo -e "\e[3mitalic\e[0m"
    echo -e "\e[4munderline\e[0m"
    echo -e "\e[9mstrikethrough\e[0m"
end

function testip
    echo "Using ipify.org"
    echo (curl -s api.ipify.org)
    echo (curl -s api6.ipify.org)
end

# Helpers to open shells in running docker containers managed by docker-compose:
function psu
    set this_dir (basename "$PWD")
    set parent_dir (basename (dirname $PWD))
    set container_name "$parent_dir"_"$this_dir"_1
    docker exec -it "$container_name" su
end

# PATH stuff
set extra_paths \
    "$HOME/binaries" \
    "$HOME/scripts" \
    "$HOME/.local/bin" \
    "$HOME/.nimble/bin" \
    "$HOME/.node_modules/bin" \
    "$HOME/google-cloud-sdk/bin"
for extra_path in $extra_paths
    if not contains $extra_path $PATH
        set PATH $extra_path $PATH
    end
end

set npm_config_prefix "$HOME/.node_modules"

# Pyenv is a bit more involved
if test -d ~/.pyenv
    source ~/neodots/fish/pyenv.fish
end

# Private work-related tools
set PRIVATE_DOTFILES "$HOME/Dropbox/privdots"
if test -d $PRIVATE_DOTFILES
    for privfile in $PRIVATE_DOTFILES/*.fish
        source $privfile
    end
end

# Default imports for python
set -Ux PYTHONSTARTUP "$HOME/.pythonrc.py"

# Qt/Kirigami stuff
set QT_QUICK_CONTROLS_MOBILE 0
set QT_QUICK_CONTROLS_STYLE org.kde.desktop

# quickly decode jwt
# sudo pacman -S python-pyjwt
abbr -a -g jwt pyjwt decode --no-verify

# Pytaku
abbr -a -g pm pytaku-manage
