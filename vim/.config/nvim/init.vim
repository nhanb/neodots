" -------- start of kitty recommended settings
" https://sw.kovidgoyal.net/kitty/faq/#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim

" Mouse support
set mouse=a
"set ttymouse=sgr
"set balloonevalterm
" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
execute "set <FocusGained>=\<Esc>[I"
execute "set <FocusLost>=\<Esc>[O"
" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''

" -------- end of kitty recommended settings

if &shell =~# 'fish$'
    set shell=sh
endif

set formatoptions-=t " don't auto-hardwrap
set linebreak " wrap by word instead of char

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
set textwidth=80
set colorcolumn=+1       " draw colorcolumn 1 char after max textwidth

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
autocmd BufNewFile,BufRead *.envrc set filetype=sh
autocmd BufNewFile,BufRead *.j2 setfiletype jinja

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

" F1 shows LSP diagnostic floating window
nnoremap <f1> :lua vim.diagnostic.open_float()<cr>

" F2 clears search highlight & search message
nnoremap <silent> <f2> :silent noh<cr>:echo<cr>

" F7 Clean ^M characters from Windows files
nnoremap <f7> :%s/<c-v><c-m>//g<cr>

" F8 to do a 'star search' (asterisk) without jumping to next match
nnoremap <F8> :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" F12 to save with 1 keystroke
inoremap <f12> <nop>
inoremap <f12> <esc>:w<cr>
nnoremap <f12> <esc>:w<cr>
vnoremap <f12> <esc>:w<cr>
inoremap <c-f12> <nop>
inoremap <c-f12> <esc>:wq<cr>
nnoremap <c-f12> <esc>:wq<cr>
vnoremap <c-f12> <esc>:wq<cr>



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

" Map to netrw mode too
autocmd filetype netrw noremap <buffer> <c-j> <c-w>j
autocmd filetype netrw noremap <buffer> <c-h> <c-w>h
autocmd filetype netrw noremap <buffer> <c-k> <c-w>k
autocmd filetype netrw noremap <buffer> <c-l> <c-w>l

" More netrw mappings
nnoremap <leader>d :e .<cr>
nnoremap <leader>e :Ex<cr>

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

" Shortcut to center cursor vertically.
nnoremap <space> zz
"nnoremap <leader><space> zt

" Close quickfix
nnoremap <leader>x :cclose<cr>:lclose<cr>:pc<cr>

" Remap Y to 'yank till end of line' to make it consistent with C, D
map Y y$

" Go to previously open file (basically like alt-tab toggle)
nnoremap <leader><tab> <c-^>

" Restart language server so e.g. new python files' imports are recognized
nnoremap <f5> :LspRestart<cr>

"" Use '+' register to do system clipboard stuff
if has('clipboard')
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
        echo 'Cannot use system clipboard! '.
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
            \'vim', 'sql', 'yaml', 'rust', 'd', 'toml', 'html', 'zig']

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
" Run command but show result without pasting:
nnoremap <leader><leader><space> :exec ':!'.getline('.')<cr>

" Make * not jump to next match
nnoremap * :keepjumps normal! mi*`i<CR>

" ===== Plugins =====
so $HOME/.vim/plugs.vim
