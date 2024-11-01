" vim:fdm=marker
call plug#begin()

" Straightforward stuff (no custom config) {{{
" ================================================================
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
"Plug 'scrooloose/nerdcommenter'
"Plug 'inside/vim-search-pulse'
"Plug 'airblade/vim-rooter'
Plug 'dag/vim-fish'
Plug 'knubie/vim-kitty-navigator', {'do': 'cp ./*.py ~/.config/kitty/'}
" }}}

" vim-test {{{
" ================================================================
Plug 'vim-test/vim-test'
nnoremap <leader>t :TestNearest<cr>

let test#python#runner = 'pytest'

function! CopyStrategy(cmd)
    let l:cmd = substitute(a:cmd, '^poetry run ', '', '') . ' --no-cov --reuse-db -s'
    let @+ = l:cmd
    echo l:cmd
endfunction
let g:test#custom_strategies = {'copy': function('CopyStrategy')}
let g:test#strategy = 'copy'

"}}}
" delimitMate {{{
" ================================================================
Plug 'Raimondi/delimitMate'

let delimitMate_expand_cr = 1
"}}}
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
nnoremap <leader>gt :tab Git<space>

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
" Airline {{{
" ================================================================
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline_theme='powerlineish'
let g:airline_symbols_ascii = 1

" https://github.com/vim-airline/vim-airline/issues/1716
let g:airline#extensions#whitespace#skip_indent_check_ft = {'go': ['mixed-indent-file']}

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
let g:ale_completion_enabled = 1 " must be set before ALE is loaded
Plug 'dense-analysis/ale'

let g:ale_virtualtext_cursor = 0 " disable annoying inline diagnostic text
" let g:ale_hover_cursor = 1

" ALE sometimes interferes with my jj imap. Let's see if this helps:
" https://github.com/dense-analysis/ale/issues/1941
let g:ale_lint_on_text_changed = 'never'

nnoremap gd :ALEGoToDefinition<cr>
nnoremap gr :ALEFindReferences<cr>
nnoremap gr :ALEFindReferences<cr>
nnoremap <leader><leader>r :ALERename<cr>
nnoremap K :ALEHover<cr>

let g:ale_linters_explicit = 1
let g:ale_linters = {
            \'python': ['ruff', 'pyright'],
            \'go': ['gopls'],
            \'elm': ['make'],
            \'qml': ['qmllint'],
            \'sh': ['shellcheck'],
            \'fish': ['fish'],
            \'nim': ['nimcheck'],
            \'javascript': ['tsserver'],
            \'typescript': ['tsserver'],
            \'d': ['dls'],
            \'c': ['cc'],
            \'zig': ['zls'],
            \}
let g:ale_python_flake8_options = '--append-config ~/.flake8'

" For python, we need to run both `ruff check --fix` (to rearrange imports)
" and `ruff format` (to format code):
" https://docs.astral.sh/ruff/formatter/#sorting-imports
let g:ale_fixers = {
            \'python': ['ruff', 'ruff_format'],
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
            \'sql': ['pgformatter'],
            \'typescript': ['prettier'],
            \'java': ['clang-format'],
            \'zig': ['zigfmt'],
            \}

nnoremap <leader>f :ALEFix<cr>

let g:ale_c_clangformat_options = '--style=google'
let g:ale_python_isort_options = '--profile black'
let g:ale_sql_pgformatter_options = '--no-extra-line'

" }}}
" YouCompleteMe {{{
" ================================================================
"Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --go-completer --clangd-completer --ts-completer' }
"
"nnoremap gd :YcmCompleter GoTo<cr>
"nnoremap gr :YcmCompleter GoToReferences<cr>
"
"let g:ycm_show_diagnostics_ui = 0
"let g:ycm_enable_diagnostic_signs = 0
"let g:ycm_enable_diagnostic_highlighting = 0
"let g:ycm_auto_hover = ''
"let g:ycm_autoclose_preview_window_after_insertion = 1
"
""autocmd BufEnter *.go let b:ycm_enable_semantic_highlighting = 1
"
"nnoremap K :YcmCompleter GetDoc<cr>
"nnoremap <leader>gf <Plug>(YCMFindSymbolInWorkspace)
"nnoremap <leader><leader>r :YcmCompleter RefactorRename<space>
""}}}
" zig.vim {{{
" ================================================================
Plug 'ziglang/zig.vim'
let g:zig_fmt_autosave = 0
"}}}

" Initialize plugin system
call plug#end()

" `colorscheme` must come after plugin initialization to be available.
" Currently I'm using a stock colorscheme though.
syntax enable
colorscheme lunaperche
set background=dark
" darker background
"hi Normal ctermbg=16
" more distinguisable active line number:
hi LineNr ctermfg=grey cterm=bold
hi LineNrAbove ctermfg=darkgrey
hi LineNrBelow ctermfg=darkgrey
" Prevent incorrectly inverted cursor when highlighting matching parens:
hi MatchParen ctermbg=227 ctermfg=0
" Some themes (lunaperche) make comments too bright, so let's fix it:
hi Comment ctermfg=darkgrey
