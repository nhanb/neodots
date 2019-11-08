My attempt at a saner set of dotfiles using [GNU Stow][1].

Usage:

```sh
$ cd ~
$ git clone <neodots-git-url>
$ cd neodots
$ ./setup.sh
```

# Neovim

This setup assumes pynvim is installed, which is trivial on Arch Linux:

```sh
sudo pacman -S python-pynvim \
       flake8 python-black python-isort  # for Ale
```

YouCompleteMe provides semantic autocomplete & goto while Ale provides linting
and autoformat. I tried to use Ale + language servers for everything in the
past but that didn't work out too well.

## Starting a typical python project:

```sh
mkcd -p ~/pj/my_project  # mkdir & cd into it
mkpyenv 3.7.5  # create pyenv virtualenv named after current dir

# Then install deps into virtualenv to help YCM with autocomplete and
# go-to-definition. Only need to do this once every time deps are changed.
actpyenv
poetry install  # you're using poetry right?
source deactivate
# No need to keep virtualenv activated since I've configured YCM to look for
# virtualenvs based on current file's path. Check neovim/.config/nvim/plugs.vim
# for details.
```

[1]: https://www.gnu.org/software/stow/
