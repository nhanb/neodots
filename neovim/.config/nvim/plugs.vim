" vim:fdm=marker
call plug#begin('~/.local/share/nvim/plugged')

" Straightforward stuff (no custom config) {{{
" ================================================================
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdcommenter'
Plug 'mitsuhiko/vim-python-combined'
Plug 'Z1MM32M4N/vim-superman'
Plug 'pearofducks/ansible-vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'chrisbra/csv.vim'
Plug 'zah/nim.vim'
Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'
Plug 'Soares/base16.nvim'
" }}}

" local vimrc {{{
" ================================================================
Plug 'MarcWeber/vim-addon-local-vimrc'
let g:local_vimrc = {'names':['.lvimrc'],'hash_fun':'LVRHashOfFile'}
"}}}
" Fugitive - Ultimate git wrapper for vim {{{
" ================================================================
Plug 'tpope/vim-fugitive'

nnoremap <leader>gg :Git<space>
nnoremap <leader>gm :Gmove<space>
nnoremap <leader>gcc :Gcommit<cr>
nnoremap <leader>gca :Git commit --amend<cr>
nnoremap <leader>gd :Gvdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gb :Gblame<cr>

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
    set grepprg=rg\ --vimgrep\ --hidden\ --no-heading\ --no-messages

    " Fuzzy file searching
    let g:ctrlp_user_command = 'rg --no-messages --files --no-ignore-vcs --hidden --follow --ignore-file ~/dotfiles/rgignore %s'
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
" Lightline {{{
" ================================================================
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'

let g:lightline = {
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'gitbranch': 'gitbranch#name'
            \ },
            \ }
" }}}
" YouCompleteMe - Awesome completion {{{
" ================================================================

Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
" Don't ask every time
let g:ycm_confirm_extra_conf = 0
let g:ycm_register_as_syntastic_checker = 0
let g:ycm_filetype_blacklist = {
            \ 'notes' : 1,
            \ 'text' : 1,
            \}

" Jump to definition, else declaration (YouCompleteMe stuff)
nnoremap <f3> :YcmCompleter<space>GoToDefinitionElseDeclaration<cr>
nnoremap <c-g> :YcmCompleter<space>GoToReferences<cr>
"}}}

" Initialize plugin system
call plug#end()

" `colorscheme` must come after plugin initialization to be available
syntax enable
set termguicolors
set background=dark
colorscheme oceanicnext
