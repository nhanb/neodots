export VIRTUAL_ENV_DISABLE_PROMPT=1
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Activate virtualenv with the same name as current dir
function actpyenv () {
    pyenv activate "${PWD##*/}"
}

# Make pyenv virtualenv using current directory as name.
# Takes 1 arg: python version, which will be installed if necessary.
function mkpyenv () {
    if [[ $# -ne 1 ]] ; then
        echo 'Must provide only 1 argument for python version'
        return 1
    fi
    py_version="$1"

    # Install python version if it's not already there:
    if ! pyenv versions | cut -d / -f 1 | uniq | grep "${py_version}\$"; then
        pyenv install "$py_version"
    else
        echo "Python version ${py_version} already installed."
    fi

    echo "Creating virtualenv ${venv_name}"
    venv_name=$(basename "$PWD")
    pyenv virtualenv "$py_version" "$venv_name"
}
