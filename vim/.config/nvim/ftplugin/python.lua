local buf_to_string = function()
    local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    return table.concat(content, "\n")
end

local string_to_buf = function(str)
    -- Trim off trailing newline if any
    if string.sub(str, -1) == '\n' then
        str = string.sub(str, 1, -2)
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(str, "\n"))
end

local function ruff_format()
    local winview = vim.fn.winsaveview()

    -- ruff doesn't have a single command to both format and fix imports
    -- for whatever reason, so we have to run 2.
    -- https://docs.astral.sh/ruff/formatter/#sorting-imports

    -- This fixes imports:
    local check = vim.system(
        { 'ruff', 'check', '--fix-only', '--quiet', '--stdin-filename', vim.fn.expand("%:t"), '-' },
        { text = true, stdin = buf_to_string() }
    ):wait()
    if check.code ~= 0 then return end

    -- This formats the rest:
    local format = vim.system(
        { 'ruff', 'format', '--quiet', '--stdin-filename', vim.fn.expand("%:t"), '-' },
        { text = true, stdin = check.stdout }
    ):wait()
    if format.code ~= 0 then return end

    string_to_buf(format.stdout)

    vim.fn.winrestview(winview)
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    buffer = bufnr,
    callback = ruff_format,
})

vim.keymap.set('n', '<leader>f', ruff_format)

vim.cmd [[
    let g:python_indent = {}
    let g:python_indent.open_paren = 'shiftwidth()'
    let g:python_indent.continue = 'shiftwidth()'
    let g:python_indent.nested_paren = 'shiftwidth()'
    let g:python_indent.disable_parentheses_indenting = v:false
    let g:python_indent.closed_paren_align_last_line = v:false
    let g:python_indent.searchpair_timeout = 150
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal shiftwidth=4
    setlocal textwidth=88
    setlocal colorcolumn=+1
    setlocal smarttab
    setlocal expandtab

    :iab iipdb __import__("ipdb").set_trace()
    :iab ipdbs __import__("ipdb").set_trace()
    :iab pdbs __import__("pdb").set_trace()
    :iab ifmain if __name__ == '__main__'
]]
