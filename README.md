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
sudo pacman -S python-pynvim
```

IDE-like features for python are all provided by Ale, which shells out to:

- **pyls** for linting and go to definition (which is configured to use
  **flake8** under the hood)
- **black** and **isort** for code formatting

```sh
# casual coding:
sudo pacman -S python-language-server flake8 python-black python-isort

# for proper projects I prefer to pin tooling versions too:
pyenv virtualenv 3.7.3 my_project
pyenv activate my_project
poetry add --dev python-language-server flake8 black isort
```

[1]: https://www.gnu.org/software/stow/
