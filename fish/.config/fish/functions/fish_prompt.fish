# See what's customizable here
# https://github.com/fish-shell/fish-shell/blob/master/share/functions/fish_git_prompt.fish

# don't shorten dir name
set fish_prompt_pwd_dir_length 0

# show git status - keep it vanilla though
set __fish_git_prompt_show_informative_status
set __fish_git_prompt_showcolorhints
set __fish_git_prompt_showupstream "auto"


function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    # User & Host
    set_color --bold yellow
    echo -n (whoami)
    echo -n '@'
    echo -n (prompt_hostname)
    set_color normal

    echo -n ' '

    # PWD
    set_color --bold green
    echo -n (prompt_pwd)
    set_color normal

    __fish_git_prompt

    # Virtualenv
    if set -q VIRTUAL_ENV
        set_color magenta
        echo -n -s " [" (basename "$VIRTUAL_ENV") "]"
        set_color normal
    end

    echo

    if not test $last_status -eq 0
        set_color red
        echo -n "$last_status "
    end

    set_color normal
    echo -n '$ '
end
