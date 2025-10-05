-- Set up nvim-cmp.
local cmp = require 'cmp'


cmp.setup({
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
    }, {
        { name = 'buffer' },
    }),
    preselect = cmp.PreselectMode.None,
})


-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- I prefer to use signature helpers instead of snippets - they're less intrusive.
capabilities.textDocument.completion.completionItem.snippetSupport = false

vim.lsp.enable('pyright')
vim.lsp.config('pyright', {
    capabilities = (function()
        local caps = vim.lsp.protocol.make_client_capabilities()
        caps.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
        capabilities.textDocument.completion.completionItem.snippetSupport = false
        return caps
    end)(),
})

vim.lsp.enable('zls');
vim.lsp.config('zls', {
    capabilities = capabilities,
    on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil -- turn off semantic tokens
    end,
})

vim.lsp.enable('lua_ls');
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
        Lua = {
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'bufnr',
                },
            },
        },
    },
})

vim.lsp.enable('clangd')
vim.lsp.config('clangd', {
    capabilities = capabilities,
})

vim.lsp.enable('ts_ls')
vim.lsp.config('ts_ls', {
    filetypes = {
        "javascript",
        "typescript",
    },
})

-- Go-to-definition, go-to-references
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader><leader>r', vim.lsp.buf.rename)

-- Enable format-on-save for languages with supporting language servers.
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.lua", "*.zig" },
    callback = function()
        vim.lsp.buf.format { async = false }
    end
})

-- Format on save for other languages without language servers:

local function buf_get_full_text(bufnr)
    local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true), "\n")
    if vim.api.nvim_buf_get_option(bufnr, "eol") then
        text = text .. "\n"
    end
    return text
end

local function format_whole_file(cmd)
    local bufnr = vim.fn.bufnr("%")
    local input = buf_get_full_text(bufnr)
    local output = vim.fn.system(cmd, input)
    if vim.v.shell_error ~= 0 then
        print(output)
        return
    end
    if output ~= input then
        local new_lines = vim.fn.split(output, "\n")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
    end
end

local function prettier_format()
    local filepath = vim.fn.shellescape(vim.fn.expand('%:p'))
    local cmd = "prettier --ignore-path '' --stdin-filepath " .. filepath
    format_whole_file(cmd)
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.json", "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css" },
    callback = prettier_format
})


-- nvim-lint
require('lint').linters_by_ft = {
    python = { 'ruff' },
}
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
