# disable greeting line on startup
set fish_greeting

set -x EDITOR vim
set -x GIT_EDITOR vim
set -x VISUAL vim

# normally I wouldn't need this but gokrazy defaults to arm64
# while I'm only tinkering with amd64 (read: normal pc) appliances.
set -x GOARCH amd64

# Exec-ing files in /tmp is forbidden in crostini,
# so this unbreaks `go run`:
#set -x TMPDIR ~/tmp

# python stuff
abbr -a -g py3 python3
abbr -a -g py python
abbr -a -g ipy ipython
abbr -a -g bpy bpython
abbr -a -g pup pip install --upgrade pip
abbr -a -g pr poetry run
abbr -a -g prp poetry run python

# Disable python-keyring.
# Recently python-poetry and python-pgcli started using it,
# throwing up warnings all over the place...
set -x PYTHON_KEYRING_BACKEND keyring.backends.null.Keyring

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

# mygit
abbr -a -g mg ssh mygit
function mgc
    git clone git@mygit:{$argv}.git
end

abbr -a -g ddd doas dd bs=4M status=progress oflag=sync

abbr -a -g dc docker compose

abbr -a -g tm 'tmuxp load'

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
    echo (curl -s4 https://icanhazip.com/)
    echo (curl -s6 https://icanhazip.com/)
end


# PATH stuff
set extra_paths \
    "/opt/local/bin" \
    "$HOME/.local/bin" \
    "$HOME/go/bin" \
    "$HOME/.nimble/bin" \
    "$HOME/.node_modules/bin" \
    "$HOME/.luarocks/bin" \
    "$HOME/google-cloud-sdk/bin" \
    "$HOME/binaries" \
    "$HOME/scripts" \
    # I don't wanna stow the whole surface-go dir yet because it contains
    # wayland stuff, and I've moved back to KDE on xorg for now.
    "$HOME/neodots/surface-go/scripts"
for extra_path in $extra_paths
    if not contains $extra_path $PATH
        set -x PATH $extra_path $PATH
    end
end

set -x npm_config_prefix "$HOME/.node_modules"

# Pyenv is a bit more involved
source ~/neodots/fish/pyenv.fish
abbr -a -g pwhich pyenv which

# Projects
abbr -a -g pm pytaku-manage
abbr -a -g mh manhoa-manage

# Pipenv shit
set -x PIPENV_VENV_IN_PROJECT 1

abbr -a -g vpnvn doas tailscale up --exit-node=vl-tailscale
abbr -a -g vpnoff doas tailscale up --exit-node=''
abbr -a -g vpncheck 'tailscale status | grep "exit node"'

abbr -a -g wcfreq v4l2-ctl -c power_line_frequency=1

abbr -a -g dj ./manage.py
abbr -a -g djr ./manage.py runserver
abbr -a -g djs ./manage.py shell
abbr -a -g djmm ./manage.py makemigrations
abbr -a -g djm ./manage.py migrate

abbr -a -g pyt pytest --reuse-db -s

abbr lwifi 'doas iwctl station wlan0 scan && doas iwctl station wlan0 get-networks | head -n20'
abbr cwifi doas iwctl station wlan0 connect

alias mpv-drc='mpv --af="acompressor=ratio=4,loudnorm"'

if type -q direnv
    direnv hook fish | source
end
