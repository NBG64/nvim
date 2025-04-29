-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.o.colorcolumn = "80,120"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.g.mapleader= " "
vim.diagnostic.config({
    signs = true,
    virtual_text = true,
})

local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now = MiniDeps.add, MiniDeps.now

-- Safely execute immediately
now(function()
  vim.o.termguicolors = true
  vim.cmd('colorscheme minischeme') --vim.cmd('colorscheme minicyan')
  --vim.o.background ='light'
end)
now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.comment').setup() end)
now(function() require('mini.pick').setup() end)
now(function() require('mini.indentscope').setup() end)
now(function() require('mini.pairs').setup() end)
now(function() require('mini.completion').setup() end)
now(function() require('mini.sessions').setup() end)

--external plugins
add('williamboman/mason.nvim')
require('mason').setup()

add('williamboman/mason-lspconfig.nvim')
require('mason-lspconfig').setup({
    ensure_installed = {'lua_ls', 'gopls', 'clangd', 'rust_analyzer', 'pyright'},
    automatic_installation = false

})

add('neovim/nvim-lspconfig')
vim.lsp.enable({'lua_ls', 'gopls', 'clangd', 'rust_analyzer', 'pyright'})
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {
              'vim',
              'require'
            },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
    },
})

--keymaps
--Mini Maps
vim.keymap.set("n", "<Leader>ff", MiniPick.builtin.files)
vim.keymap.set("n", "<Leader>fg", MiniPick.builtin.grep_live)
vim.keymap.set("n", "<Leader>fb", MiniPick.builtin.buffers)
vim.keymap.set("n", "<Leader>ls", MiniSessions.select)

--Lsp Maps
vim.keymap.set("n", "<Leader>gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<Leader>gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "<Leader>gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "<Leader>gr", vim.lsp.buf.references)

--Other
vim.keymap.set("n", "<Leader>cb", ":bufdo bwipeout<CR>")
