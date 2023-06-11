set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -x PYENV_VIRTUALENV_DISABLE_PROMPT 1

set VENVS_DIR "$HOME/.venvs"

# Activate virtualenv with the same name as current dir
# Using a function instead of abbr because the latter isn't usable in scripts.
function pyact
    . $VENVS_DIR/(basename $PWD)/bin/activate.fish
end

# Make pyenv virtualenv using current directory as name.
# Takes 1 arg: python version, which will be installed if necessary.
function pymk
    if [ (count $argv) != 1 ]
        echo 'Must provide only 1 argument for python version'
        return 1
    end

    set py_version $argv
    set venv_name (basename "$PWD")
    set venv_dir "$VENVS_DIR/$venv_name"

    # Install python version if it's not already there:
    pyenv versions | cut -d / -f 1 | uniq | grep "$py_version\$"
    if [ $status != 0 ]
        pyenv install "$py_version" || return 1
    else
        echo "Python version $py_version already installed."
    end

    echo "Creating virtualenv $venv_name"
    "$HOME/.pyenv/versions/$py_version/bin/python" -m venv "$venv_dir"
end
