set -Ux VIRTUAL_ENV_DISABLE_PROMPT 1
set -Ux PYENV_VIRTUALENV_DISABLE_PROMPT 1

set PATH "$HOME/.pyenv/bin" $PATH
source (pyenv init - | psub)
source (pyenv virtualenv-init - | psub)

# Activate virtualenv with the same name as current dir
function actpyenv
    pyenv activate (basename $PWD)
end

# Make pyenv virtualenv using current directory as name.
# Takes 1 arg: python version, which will be installed if necessary.
function mkpyenv
    if [ (count $argv) != 1 ]
        echo 'Must provide only 1 argument for python version'
        return 1
    end
    set py_version $argv

    # Install python version if it's not already there:
    pyenv versions | cut -d / -f 1 | uniq | grep "$py_version\$"
    if [ $status != 0 ]
        pyenv install "$py_version"
    else
        echo "Python version $py_version already installed."
    end

    echo "Creating virtualenv $venv_name"
    set venv_name (basename "$PWD")
    pyenv virtualenv "$py_version" "$venv_name"
end
