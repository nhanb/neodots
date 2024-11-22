local function ruff_format()
    -- ruff doesn't have a single command to both format and fix imports
    -- for whatever reason, so we have to run 2.
    -- https://docs.astral.sh/ruff/formatter/#sorting-imports
    vim.cmd('silent %!ruff check --fix-only --quiet -')
    vim.cmd('silent %!ruff format --quiet -')
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    buffer = bufnr,
    callback = ruff_format,
})

vim.keymap.set('n', '<leader>f', ruff_format)
