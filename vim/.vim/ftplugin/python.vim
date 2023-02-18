setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=88
setlocal colorcolumn=+1
setlocal smarttab
setlocal expandtab

" don't wrap long lines in insert mode
set formatoptions-=t

:iab iipdb __import__("ipdb").set_trace()
:iab ipdbs __import__("ipdb").set_trace()
:iab pdbs __import__("ipdb").set_trace()

:iab ifmain if __name__ == '__main__'

function! GetNearestPytestString()
    let currenttag = substitute(tagbar#currenttag("%s", "", "f"), '\.', '::', '')
    let currenttag = substitute(currenttag, '()', '', '')
    let currentfile = expand("%")
    if currenttag == ''
        return currentfile
    else
        return currentfile .. '::' .. currenttag
    endif
endfunction
nnoremap <buffer> <leader>t :let @+ = GetNearestPytestString()<cr>
