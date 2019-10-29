" vim:fdm=marker
call plug#begin('~/.local/share/nvim/plugged')

" Straightforward stuff (no custom config) {{{
" ================================================================
Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-textobj-line'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdcommenter'
Plug 'mitsuhiko/vim-python-combined'
Plug 'Z1MM32M4N/vim-superman'
Plug 'pearofducks/ansible-vim'
Plug 'chrisbra/csv.vim'
Plug 'cespare/vim-toml'
Plug 'Soares/base16.nvim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'justinmk/vim-sneak'
Plug 'inside/vim-search-pulse'
Plug 'ElmCast/elm-vim'
Plug 'peterhoeg/vim-qml'
Plug 'nucleic/enaml', { 'rtp': 'tools/vim' }
Plug 'airblade/vim-rooter'
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
let g:fugitive_gitlab_domains = ['https://git.parcelperform.com']

nnoremap <leader>gg :Git<space>
nnoremap <leader>gm :Gmove<space>
nnoremap <leader>gcc :Gcommit<cr>
nnoremap <leader>gca :Git commit --amend<cr>
nnoremap <leader>gd :Gvdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gh :Gbrowse<cr>

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
" delimitMate - Auto bracket {{{
" ================================================================
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr = 1
"}}}
" Tagbar {{{
" ================================================================
Plug 'majutsushi/tagbar'

" F5 toggles tagbar
nnoremap <f5> :TagbarToggle<cr>
" }}}
" vim-indent-guides {{{
" ================================================================
Plug 'nathanaelkane/vim-indent-guides'

" Indentation guidlines
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 4
"}}}
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

nnoremap <leader>d <esc>:NERDTree<cr>
nnoremap <leader>e :NERDTreeToggle<cr>
nnoremap <leader>f :NERDTreeFind<cr>

let NERDTreeShowHidden=1

" Show git signs too because why not?
Plug 'Xuyuanp/nerdtree-git-plugin'
" }}}
" Gitv - Requires fugitive - "command line gitk" {{{
" ================================================================
Plug 'gregsexton/gitv'

" Their default <c-whatever> keybindings clash with mine => disable them
let g:Gitv_DoNotMapCtrlKey = 1

nmap <leader>gv :Gitv --all<cr>
nmap <leader>gV :Gitv! --all<cr>
vmap <leader>gV :Gitv! --all<cr>
" }}}
" Airline {{{
" ================================================================
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline_theme='powerlineish'
" }}}
" Ale with LSP support {{{
" ================================================================
" ale_completion_enabled must be set before loading ale
let g:ale_completion_enabled = 1
Plug 'w0rp/ale'

" Let Ale look for virtualenv in ~/.pyenv/versions/<current_project_dir_name>
autocmd BufNewFile,BufRead ~/parcel/*.py,~/pj/*.py
            \ let b:ale_virtualenv_dir_names = [
            \     '.pyenv/versions/' .
            \     split(ale#python#FindProjectRoot(bufnr('%')), '/')[-1]
            \ ]

let g:ale_python_pyls_config = {
            \   'pyls': {
            \     'configurationSources': ['flake8'],
            \     'plugins': {
            \       'pycodestyle': {
            \         'enabled': v:false
            \       }
            \     }
            \   }
            \ }
nnoremap gd :ALEGoToDefinition<cr>
" I prefer flake8's linter over flake8-over-pyls because for whatever dumb
" reason the latter's error underlining is less clean, but in order for ale to
" support goto definition, the linter must be pyls. Bummer.
let g:ale_linters = {
            \'python': ['pyls'],
            \'rust': ['rls'],
            \'elm': ['make'],
            \'qml': ['qmllint'],
            \'sh': ['shellcheck'],
            \'markdown': [],
            \}
" Pyls does support code formatting using black but then I'll need to install
" an extra pyls-black pip package. Why bother with that when ale's direct
" support for black works just fine?
let g:ale_fixers = {
            \'python': ['black', 'isort'],
            \'rust': ['rustfmt'],
            \'elm': ['elm-format'],
            \'qml': ['qmlfmt'],
            \'html': ['prettier'],
            \'javascript': ['prettier'],
            \'sh': ['shfmt'],
            \}
" As much as I loooove autoformat-on-save,
" it's a no-go for projects at work (for now...?)
"let g:ale_fix_on_save = 1
nnoremap <leader>lf :ALEFix<cr>

" Enable tab completion in addition to <C-n> / <C-p>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Avoid overly eager autocomplete:
" https://github.com/w0rp/ale/issues/1700#issuecomment-405554860
set completeopt=menu,menuone,preview,noselect,noinsert

" Completion tweaks
let g:ale_completion_delay = 0
" }}}

" Initialize plugin system
call plug#end()

" `colorscheme` must come after plugin initialization to be available
syntax enable
set termguicolors
set background=dark
colorscheme oceanicnext
highlight Pmenu guibg='#444444'
highlight ColorColumn guibg='#222222'
