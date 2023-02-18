if &shell =~# 'fish$'
    set shell=sh
endif

set tabstop=4 expandtab softtabstop=4
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set history=7777         " remember more commands and search history
set undolevels=7777      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set noerrorbells         " don't beep
set textwidth=79
set colorcolumn=+1       " draw colorcolumn 1 char after max textwidth
let loaded_matchparen = 0 " matching paren highlighting is distracting

" Fixes slow esc from visual mode in vim
set timeoutlen=1000 ttimeoutlen=0

if executable('open')
    let g:opencmd = 'open'
else
    let g:opencmd = 'xdg-open'
endif

" Open http(s) url under cursor with xdg-open
function! OpenURL()
  let l:url = matchstr(expand("<cWORD>"), 'https\=:\/\/[^ >,;()'. "'" .']*')
  if l:url != ""
    let l:url = shellescape(l:url, 1)
    let l:command = "!".g:opencmd." ".l:url
    echo l:command
    silent exec l:command
    redraw!
  else
    echo "No URL found under cursor."
  endif
endfunction
nnoremap gl :call OpenURL()<cr>

" Open jira issue under cursor with xdg-open
function! OpenJira()
  let l:jira_id = toupper(matchstr(expand("<cWORD>"), '\c\(id2\|sre\|csi\)-[0-9]\+'))
  if l:jira_id != ""
    let l:command = "!".g:opencmd." https://inspectorio.atlassian.net/browse/".l:jira_id
    echo l:command
    silent exec l:command
  else
    echo "No Jira ticket found under cursor."
  endif
endfunction
nnoremap gj :call OpenJira()<cr>

" Help vim detect certain file types
autocmd BufNewFile,BufRead poetry.lock set filetype=toml

" Disable py2 provider:
let g:loaded_python_provider = 0

" Set system python as py3 provider.
if has('macunix')
    let g:python3_host_prog = '/opt/local/bin/python'
else
    " This assumes I have installed the Arch Linux `python-pynvim` package.
    let g:python3_host_prog = '/usr/bin/python'
endif

" Keep temporary files in mybackupdir
let mybackupdir=$HOME.'/.vim_backup'
if !isdirectory(mybackupdir)
    " Create directory if not available
    call mkdir(mybackupdir, "p")
endif
let &backupdir=mybackupdir
let &directory=mybackupdir

" Easier block indenting (does not exit visual mode after one shift)
vnoremap < <gv
vnoremap > >gv

" Auto reload file on change
set autoread

" Set relative line numbers but active line has absolute number
set number
set relativenumber

" Always show gutter column so we don't have jumping text when inserting text
set signcolumn=yes

" ================================================================
" HERE COME KEYBINDINGS
" ================================================================

" Change the leader key from \ to ,
let mapleader=","
noremap \ <nop>

" No Ex mode please
nnoremap Q <nop>

" ---- Esc alternatives ----
inoremap jj <esc>
" Save, stay in normal mode
inoremap jk <esc>:w<cr>l
" Save, stay in insert mode
inoremap jh <esc>:w<cr>a

" F2 clears search highlight & search message
nnoremap <silent> <f2> :silent noh<cr>:echo<cr>
nnoremap <silent> <f1> :silent noh<cr>:echo<cr>

"" F3 toggles paste mode
set pastetoggle=<F10>

" F7 Clean ^M characters from Windows files
nnoremap <f7> :%s/<c-v><c-m>//g<cr>

" F8 to do a 'star search' (asterisk) without jumping to next match
nnoremap <F8> :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" Up Down Left Right to adjust current split size
nnoremap <up> <c-w>+
nnoremap <down> <c-w>-
nnoremap <left> <c-w><
nnoremap <right> <c-w>>

" Write file with sudo permission
"nnoremap <leader>wf :w<space>!sudo<space>tee<space>%<cr>

" Moving around splits using Ctrl+h/j/k/l
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Moving around tabs using <leader>n/m
nnoremap <leader>n <esc>:tabprevious<cr>
nnoremap <leader>m <esc>:tabnext<cr>

" Change working dir to the current file's dir
nnoremap <leader>h :cd<space>%:p:h<cr>:pwd<cr>

" Visually select a piece of text then press ~ to change its case. There are
" three types: all lowercase, ALL UPPERCASE, First Letters Uppercase.
function! TwiddleCase(str)
    if a:str ==# toupper(a:str)
        let result = tolower(a:str)
    elseif a:str ==# tolower(a:str)
        let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
    else
        let result = toupper(a:str)
    endif
    return result
endfunction
vnoremap ~ ygv"=TwiddleCase(@")<CR>Pgv

" Moving up/down 1 row instead of 1 line (fix wrap issue)
nnoremap j gj
nnoremap k gk

" Actually nowrap is easier on the eye
set nowrap

" Saner new split position
set splitbelow
set splitright

" Easier splitting
nnoremap <leader>v :vsplit<cr>
nnoremap <leader>s :split<cr>

" Quickly insert current date time
:iab <expr> dts strftime("%Y-%m-%d %H:%M")

" Save with 1 keystroke (why have I never thought about this?)
inoremap <f9> <nop>
inoremap <f9> <esc>:w<cr>
nnoremap <f9> <esc>:w<cr>
vnoremap <f9> <esc>:w<cr>
inoremap <c-f9> <nop>
inoremap <c-f9> <esc>:wq<cr>
nnoremap <c-f9> <esc>:wq<cr>
vnoremap <c-f9> <esc>:wq<cr>

" Format json
nnoremap <leader>jj :%!python3 -m json.tool<cr>
vnoremap <leader>jj !python3 -m json.tool<cr>
nnoremap <leader>js :%!python3 -m json.tool --sort-keys<cr>
vnoremap <leader>js !python3 -m json.tool --sort-keys<cr>

" Search visually selected text
vnoremap // y/<c-r>"<cr>"

" Convenient saving without leaving home row
" http://reefpoints.dockyard.com/2013/09/11/vim-staying-on-home-row-via-map.html
inoremap ;d <esc>:w<cr>
inoremap ;s <c-o>:w<cr>

" Run, Forrest, Run!
nnoremap <leader>q :!chmod +x %<cr><cr>:echo 'File is now executable'<cr>

" Shortcut to center cursor vertically.
nnoremap <space> zz
"nnoremap <leader><space> zt

" Close quickfix
nnoremap <leader>x :cclose<cr>:lclose<cr>:pc<cr>

" Remap Y to 'yank till end of line' to make it consistent with C, D
map Y y$

" Go to previously open file (basically like alt-tab toggle)
nnoremap <leader><tab> <c-^>

" The + clipboard doesn't work on crostini for some reason, so pipe to
" wl-clipboard instead.
if filereadable('/dev/.cros_milestone')
    vnoremap <leader>y y:call system("wl-copy", @")<cr>
    nnoremap <leader>y :silent .w !wl-copy<cr>
    nnoremap <leader>p :read !wl-paste --no-newline<cr>
    " TODO: pasting into a visual selection

" Use '+' register to do system clipboard stuff
elseif has('clipboard')
    vnoremap <leader>y "+y
                \:echo 'Selection yanked to system clipboard'<cr>
    nnoremap <leader>y "+yy
                \:echo '1 line yanked to system clipboard'<cr>
    nnoremap <leader>Y "+y$
                \:echo 'Rest of line yanked to system clipboard'<cr>
    vnoremap <leader>p "+p
    nnoremap <leader>p "+p
    nnoremap <leader>P "+P

    " These go nicely with *gasp* mouse selection
    vnoremap <c-c> "+ygv
    vnoremap <c-v> "+p

else
    function! NoClipboardWarning()
        echohl WarningMsg
        echo 'Cannnot use system clipboard! '.
                    \'Recompile vim with "+clipboard" to solve this.'
        echohl None
    endfunction
    vnoremap <leader>y :call NoClipboardWarning()<cr>
    nnoremap <leader>y :call NoClipboardWarning()<cr>
    nnoremap <leader>Y :call NoClipboardWarning()<cr>
    vnoremap <leader>p :call NoClipboardWarning()<cr>
    nnoremap <leader>p :call NoClipboardWarning()<cr>
    nnoremap <leader>P :call NoClipboardWarning()<cr>
endif

" Make tabs, trailing whitespace, and non-breaking spaces visible
fun! MarkSpecialWhitespaces()
    " Tabs are the norm in golang so don't mark them.
    " \uA0 is a non breaking space, only because if I put a normal space here
    " it'll be a syntax error.
    if &ft ==# 'go'
        exec "setlocal listchars=tab:\uA0\uA0,trail:\uB7,nbsp:~"
    else
        exec "setlocal listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
    endif
    set list
endfun
autocmd BufEnter * call MarkSpecialWhitespaces()

" Hail tpope (again):
" https://github.com/neovim/neovim/blob/ece19b459c082eae05b5c480f6ee91181f002c02/runtime/syntax/markdown.vim#L18-L28
let g:markdown_fenced_languages = ['python', 'sh', 'json', 'javascript',
            \'vim', 'sql', 'yaml', 'rust', 'd', 'toml', 'html']

" Access command history without a Shift
nnoremap q; q:

" Trigger omnifunc
"inoremap <c-j> <c-x><c-o>

" Enable tab completion in addition to <C-n> / <C-p>
inoremap <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" "inside line" motion
" (https://vi.stackexchange.com/questions/6101/is-there-a-text-object-for-current-line)
xnoremap il g_o^
onoremap il :normal vil<CR>

" Poor man's acme: execute current line, append result to current buffer
nnoremap <leader><space> :exec ':read!'.getline('.')<cr>
"inoremap <c-space> <esc>:exec ':read!'.getline('.')<cr>
" Visual mode is a bit more involved:
function! ExecuteSelection()
    """ Puts currently selected text into the @@ register, then `read!` it
    normal! `<v`>y
    exec 'read!' . @@
endfunction
vnoremap <leader><space> :<c-u>call ExecuteSelection()<cr>

nnoremap <leader><leader><space> :exec ':!'.getline('.')<cr>

" ===== Plugins =====
so $HOME/.vim/plugs.vim
