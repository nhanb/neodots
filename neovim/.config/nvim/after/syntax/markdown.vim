" Don't highlight single underscore as error:
" https://github.com/tpope/vim-markdown/issues/21#issuecomment-283846940
" This is simply copied from tpope's syntax file but with `_` removed from the
" pattern.
syn match markdownError "\w\@<=\w\@="
