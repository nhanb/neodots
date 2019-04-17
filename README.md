My attempt at a saner set of dotfiles using [GNU Stow][1].

Usage:

```bash
$ cd ~
$ git clone <neodots-git-url>
$ cd neodots
$ stow bash
$ stow neovim
$ # etc etc
```

# Neovim

My setup assumes pynvim is installed in its own dedicated virtualenv.
Something like this should work:

```bash
pyenv virtualenv 3.7.3 neovim3
pyenv activate neovim3
pip install pynvim
# rinse & repeat for neovim2
```

IDE-like features for python are all provided by Ale:

- Linting, go to definition: backed by pyls
- Code formatting: backed by black

```bash
pyenv virtualenv 3.7.3 my_project
pyenv activate my_project
poetry add --dev python-language-server flake8
# you DO use a package manager that can actually resolve dependencies, right?
```

This covers:

- `:Format` command powered by `black`
- Linting by flake8
- Goto definition
- Semantic completion

[1]: https://www.gnu.org/software/stow/
