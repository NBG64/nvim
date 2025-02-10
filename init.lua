-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.g.mapleader= " "

vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
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
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately
now(function()
  vim.o.termguicolors = true
  vim.cmd('colorscheme minicyan' )
  --vim.o.background ='light'
end)
now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)
now(function() require('mini.icons').setup({style = 'ascii'}) end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.bracketed').setup() end)
now(function() require('mini.comment').setup() end)
now(function() require('mini.pick').setup() end)
now(function() require('mini.indentscope').setup() end)
now(function() require('mini.move').setup() end)
now(function() require('mini.pairs').setup() end)
now(function() require('mini.completion').setup() end)
--now(function() require('mini.visits').setup() end)
--now(function() require('mini.files').setup() end)
-- Safely execute later
--later(function() require('mini.surround').setup() end)

--external plugins
local add = MiniDeps.add
add('williamboman/mason.nvim')
require('mason').setup()
add('williamboman/mason-lspconfig.nvim')
require('mason-lspconfig').setup({
    ensure_installed = {'lua_ls', 'clangd', 'rust_analyzer'},
    automatic_installation = false
})
add('neovim/nvim-lspconfig')
local custom_on_attach = function(client, buf_id)
    -- Set up 'mini.completion' LSP part of completion
    vim.bo[buf_id].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    -- Mappings are created globally with `<Leader>l` prefix (for simplicity)
end

local lspconfig = require('lspconfig')
  lspconfig.clangd.setup({on_attach = custom_on_attach})
  lspconfig.rust_analyzer.setup({on_attach = custom_on_attach})
  --lspconfig.gopls.setup({on_attach = custom_on_attach})
  --lspconfig.pylsp.setup({on_attach = custom_on_attach})
  lspconfig.lua_ls.setup {
    on_attach = custom_on_attach,
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
    }
