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
    set_color --bold ff0
    echo -n (whoami)
    echo -n '@'
    echo -n (prompt_hostname)
    set_color normal

    echo -n ' '

    # PWD
    set_color --bold 0f0
    echo -n (prompt_pwd)
    set_color normal

    __fish_git_prompt

    # Virtualenv
    if set -q VIRTUAL_ENV
        set_color ffa500
        echo -n -s " [" (basename "$VIRTUAL_ENV") "]"
        set_color normal
    end

    # Last command's execution time
    if test $CMD_DURATION
        # Show duration of the last command in seconds
        set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.2fs", $1 / $2}')
        set_color --bold 666
        echo -n " $duration"
        set_color normal
    end

    echo

    # Show "fg" if there's a backgrounded job that can be restored with `fg`
    if jobs -q
        set_color --bold 0ff
        echo -n "fg "
        set_color normal
    end

    # Error code of last command
    if not test $last_status -eq 0
        set_color --bold f44
        echo -n "$last_status "
        set_color normal
    end

    set_color --bold fff
    echo -n '$ '
    set_color normal
end
