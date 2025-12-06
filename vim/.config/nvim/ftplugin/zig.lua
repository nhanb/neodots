vim.cmd [[
    setlocal tw=80
    :iab istd const std = @import("std");
    :iab ipri const print = std.debug.print;

    " <c-cr> to insert ; at end of line and then enter
    imap <c-cr> <cr><esc>jA;<esc>kcc
]]
