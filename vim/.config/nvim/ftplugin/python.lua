local function ruff_format()
    local winview = vim.fn.winsaveview()

    -- ruff doesn't have a single command to both format and fix imports
    -- for whatever reason, so we have to run 2.
    -- https://docs.astral.sh/ruff/formatter/#sorting-imports
    vim.cmd('silent %!ruff check --fix-only --quiet -')
    vim.cmd('silent %!ruff format --quiet -')

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
]]
