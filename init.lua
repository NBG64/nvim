-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set mouse=")
--vim.o.colorcolumn = "80,120"
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
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path }
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
  --vim.cmd('colorscheme minischeme') 
  --vim.cmd('colorscheme minicyan')
  --vim.cmd('colorscheme miniwinter')
  --vim.cmd('colorscheme minispring')
  --vim.cmd('colorscheme minisummer')
  --vim.cmd('colorscheme miniautumn')
  --vim.cmd('colorscheme randomhue')
  --vim.o.background ='light'
end)
now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)
now(function() require('mini.statusline').setup({use_icons= false}) end)
now(function() require('mini.comment').setup() end)
now(function() require('mini.pick').setup() end)
now(function() require('mini.indentscope').setup() end)
now(function() require('mini.pairs').setup() end)
now(function() require('mini.completion').setup() end)
now(function() require('mini.sessions').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.surround').setup() end)
now(function() require('mini.hues').setup({background='#fcfcfc', foreground='#36454F', n_hues=8, accent='cyan',saturation= 'mediumhigh'}) end)
--now(function() require('mini.hues').setup({background='#daf0ff', foreground='#36454F', saturation= 'medium'}) end)
--external plugins
add('tpope/vim-fugitive')

add('NotAShelf/direnv.nvim')
require("direnv").setup({
    autoload_direnv = true,
})

add('williamboman/mason.nvim')
require('mason').setup()

add('williamboman/mason-lspconfig.nvim')
require('mason-lspconfig').setup({
    ensure_installed = {'lua_ls', 'gopls', 'clangd', 'rust_analyzer', 'ansiblels', 'powershell_es', 'zls', 'ols'},
    automatic_installation = false,
    automatic_setup = false,
    automatic_enable = false,
    handlers = nil,
})

add('neovim/nvim-lspconfig')
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {

      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'

          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {

        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }

    })
  end,
  settings = {
    Lua = {}

  }
})
vim.lsp.config('ruff', {
  init_options = {
    settings = {
        logLevel = 'debug',
    }
  }
})
vim.lsp.enable({'ruff', 'ty', 'lua_ls', 'gopls', 'clangd', 'rust_analyzer', 'ansiblels', 'powershell_es', 'zls', 'ols'})

add('stevearc/conform.nvim')
require("conform").setup({
    formatters_by_ft = {
        python = {

          -- To fix auto-fixable lint errors.
          "ruff_fix",
          -- To run the Ruff formatter.
          "ruff_format",
          -- To organize the imports.
          "ruff_organize_imports",
        },
    },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

add('mfussenegger/nvim-lint')
require("lint").linters_by_ft = {
  python = { "ruff" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {

  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
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
vim.keymap.set("n", "<Leader>tt", ":term<CR>")
vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]], { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>',{ noremap = true, silent = true })
