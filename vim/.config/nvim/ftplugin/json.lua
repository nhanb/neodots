local function prettier_format()
    local winview = vim.fn.winsaveview()
    vim.cmd('silent %!prettier --stdin-filepath foo.json --tab-width 4')
    vim.fn.winrestview(winview)
end

vim.keymap.set('n', '<leader>f', prettier_format)
