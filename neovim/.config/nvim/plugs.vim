" vim:fdm=marker
call plug#begin('~/.local/share/nvim/plugged')

" Straightforward stuff (no custom config) {{{
" ================================================================
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'scrooloose/nerdcommenter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'inside/vim-search-pulse'
Plug 'airblade/vim-rooter'
Plug 'dag/vim-fish'
Plug 'peterhoeg/vim-qml'
" }}}

" local vimrc {{{
" ================================================================
Plug 'MarcWeber/vim-addon-local-vimrc'
let g:local_vimrc = {'names':['.lvimrc'],'hash_fun':'LVRHashOfFile'}
"}}}
" Fugitive - Ultimate git wrapper for vim {{{
" ================================================================
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
"let g:fugitive_gitlab_domains = ['https://git.parcelperform.com']

nnoremap <leader>gg :Git<space>
nnoremap <leader>gm :Gmove<space>
nnoremap <leader>gcc :Gcommit<cr>
nnoremap <leader>gca :Git commit --amend<cr>
nnoremap <leader>gd :Gvdiff<cr>
nnoremap <leader>gs :Git status<cr>
nnoremap <leader>gb :Git blame<cr>
nnoremap <leader>gh :GBrowse<cr>

" Stage current file
nnoremap <leader>ga :Gwrite<cr>
nnoremap <leader>gw :Gwrite<cr>

" Revert current file to last commit
nnoremap <leader>gr :Gread<cr>

" Open git log in a new buffer
nnoremap <leader>gll :Gtabedit! log<cr>
nnoremap <leader>glo :Gtabedit! log --pretty=oneline<cr>
nnoremap <leader>glg :Gtabedit! log --graph<cr>
nnoremap <leader>glp :Gtabedit! log -p<cr>

" Open git diff in a new buffer
nnoremap <leader>gff :Gtabedit! diff<cr>
nnoremap <leader>gfc :Gtabedit! diff --cached<cr>

" Open current file in master
nnoremap <leader>got :Gtabedit master:%<cr>
nnoremap <leader>gos :Gsplit master:%<cr>
nnoremap <leader>gov :Gvsplit master:%<cr>

" Less intrusive push/pull - requires vim-dispatch plugin
nnoremap <leader>gps :Dispatch git push<cr>
nnoremap <leader>gpl :Dispatch git pull<cr>

" Map .. to going back when exploring git tree objects
autocmd User fugitive
            \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
            \   nnoremap <buffer> .. :edit %:h<CR> |
            \ endif

" Auto delete inactive fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
" }}}
" CtrlP {{{
" ================================================================
Plug 'ctrlpvim/ctrlp.vim'

nnoremap <leader>o :CtrlPMixed<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>r :CtrlPMRU<cr>

if executable('rg')
    " RipGrep - faster than Ag
    set grepprg=rg\ --vimgrep\ --hidden\ --no-heading\ --no-messages\ --ignore-file\ ~/neodots/rgignore

    " Fuzzy file searching
    let g:ctrlp_user_command = 'rg --no-messages --files --no-ignore-vcs --hidden --follow --ignore-file ~/neodots/rgignore %s'
    let g:ctrlp_use_caching = 0

    " Content searching
    command -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
    nnoremap <Leader>ge :Rg<Space>
    nnoremap <Leader>a :Rg<Space>

elseif executable('ag')
    " The Silver Searcher - snippet snatched from Thoughtbot
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0

    " simple grep-like command
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap <leader>ge :Ag<space>
endif
"}}}
" Tagbar {{{
" ================================================================
Plug 'majutsushi/tagbar'

" F5 toggles tagbar
nnoremap <f5> :TagbarToggle<cr>
" }}}
" NERDTree {{{
" ================================================================
Plug 'scrooloose/nerdtree'

" Auto quit NERDTree if it's the only buffer left
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
function! s:CloseIfOnlyNerdTreeLeft()
    if exists("t:NERDTreeBufName")
        if bufwinnr(t:NERDTreeBufName) != -1
            if winnr("$") == 1
                q
            endif
        endif
    endif
endfunction

" Ignore irrelevant files in NERDTree
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$', '\.o$',
            \'\.so$', '\.egg$', '^\.git$', '\.gem$',  '\.rbc$', '\~$',
            \ '^__pycache__$']

nnoremap <leader>d :NERDTreeToggle<cr>:NERDTreeRefresh<cr>
nnoremap <leader>e :NERDTreeFind<cr>:NERDTreeRefresh<cr>

let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "M",
    \ "Staged"    : "S",
    \ "Untracked" : "U",
    \ "Renamed"   : "R",
    \ "Unmerged"  : "=",
    \ "Deleted"   : "X",
    \ "Dirty"     : "D",
    \ "Clean"     : "C",
    \ 'Ignored'   : 'I',
    \ "Unknown"   : "?"
    \ }

let NERDTreeShowHidden=1

" https://github.com/preservim/nerdtree/issues/1321#issuecomment-1234980190
" Also I think I prefer this look anyway
let g:NERDTreeMinimalMenu=1

" Show git signs too because why not?
Plug 'Xuyuanp/nerdtree-git-plugin'
" }}}
" Airline {{{
" ================================================================
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline_theme='powerlineish'
let g:airline_symbols_ascii = 1
" }}}
" emmet-vim {{{
" ================================================================
Plug 'mattn/emmet-vim'
let g:user_emmet_settings = {
            \  'variables': {'lang': 'en', 'charset': 'utf-8'},
            \  'html': {
            \    'snippets': {
            \      'html:5': "<!DOCTYPE html>\n"
            \              ."<html lang=\"${lang}\">\n"
            \              ."  <head>\n"
            \              ."    <meta charset=\"${charset}\" />\n"
            \              ."    <title></title>\n"
            \              ."    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />\n"
            \              ."  </head>\n"
            \              ."  <body>${child}</body>\n"
            \              ."</html>",
            \    },
            \  },
            \}
"}}}
" ALE {{{
" ================================================================
" I use ALE for linting and autoformat, including autoformat-on-save.
" Although YouCompleteMe has a Format feature, it's limited:
" not letting me use goimports was a dealbreaker.
let g:ale_completion_enabled = 0 " must be set before ALE is loaded
Plug 'dense-analysis/ale'

" disable annoying inline diagnostic text on neovim:
let g:ale_virtualtext_cursor = 0

let g:ale_linters_explicit = 1
let g:ale_linters = {
            \'python': ['flake8'],
            \'elm': ['make'],
            \'qml': ['qmllint'],
            \'sh': ['shellcheck'],
            \'fish': ['fish'],
            \'nim': ['nimcheck'],
            \'javascript': ['jshint'],
            \'d': ['dls'],
            \'c': ['cc'],
            \}
let g:ale_python_flake8_options = '--append-config ~/.flake8'

let g:ale_fixers = {
            \'python': ['isort', 'black'],
            \'go': ['goimports'],
            \'rust': ['rustfmt'],
            \'elm': ['elm-format'],
            \'qml': ['qmlfmt'],
            \'html': ['prettier'],
            \'javascript': ['prettier'],
            \'sh': ['shfmt'],
            \'nim': [],
            \'c': ['clang-format'],
            \'css': ['prettier'],
            \'d': ['dfmt'],
            \'json': ['prettier'],
            \'vim': ['remove_trailing_lines', 'trim_whitespace'],
            \}

" For filetypes with configured fixer(s), bind ALEFix to <leader>f
for [key, value] in items(g:ale_fixers)
    if value != []
        execute 'autocmd FileType '.key.' nnoremap <buffer> <leader>f :ALEFix<cr>'
    endif
endfor

" }}}
" base16 {{{
" ================================================================
Plug 'Soares/base16.nvim'
" Make comments not italic (on crostini italics are sometimes cut off)
" Also make them grey to make them less prominent, now that they're
" no longer italic.
let g:base16_color_overrides = {'Comment': 'fg=similar1 NONE'}
"}}}
" YouCompleteMe {{{
" ================================================================
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --go-completer' }

nnoremap gd :YcmCompleter GoTo<cr>
nnoremap gr :YcmCompleter GoToReferences<cr>

" TODO: YCM doesn't support gopls rename yet. I'll have to do some manual work.

"}}}

" Initialize plugin system
call plug#end()

function! FormatPostgres(buffer) abort
    return {
    \   'command': 'pgpp -m 30 --comma-at-eoln --preserve-comments -e',
    \}
endfunction
execute ale#fix#registry#Add('pgpp', 'FormatPostgres', ['sql'], 'PGLast pgpp for postgres SQL')

" `colorscheme` must come after plugin initialization to be available
syntax enable
set termguicolors
set background=dark
colorscheme oceanicnext
highlight Pmenu guibg='#444444'
highlight ColorColumn guibg='#222222'
