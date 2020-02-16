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

## Starting a typical python project:

```sh
mkcd -p ~/pj/my_project  # mkdir & cd into it
mkpyenv 3.7.5  # create pyenv virtualenv named after current dir

# install pyls into said virtualenv:
actpyenv
poetry init  # you're using poetry right?
poetry add -D python-language-server
source deactivate
# No need to keep virtualenv activated since I've configured ALE to look for
# virtualenvs based on current file's path. Check neovim/.config/nvim/plugs.vim
# for details.
```

[1]: https://www.gnu.org/software/stow/
