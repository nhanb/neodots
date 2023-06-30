" Make sure fcitx IM is deactivated when leaving insert mode.
" The IM state is remembered so when user hops back into insert mode, it's
" reactivated if appropriate.
"
" fcitx5-remote returns 1 when IM is inactive (English), 2 when active (VN)
" -c deactivates => sets English
" -o activates => sets Vietnamese

const s:english = "1"
const s:vietnamese = "2"
let s:insertModeState = s:english

function SwitchIMOnLeave()
    let s:insertModeState = systemlist("fcitx5-remote")[0]
    silent !fcitx5-remote -c
endfunction

function SwitchIMOnEnter()
    if s:insertModeState == s:vietnamese
        silent !fcitx5-remote -o
    endif
endfunction

autocmd InsertLeave * call SwitchIMOnLeave()
autocmd InsertEnter * call SwitchIMOnEnter()
