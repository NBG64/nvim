vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set mouse=")
vim.o.colorcolumn = "80,120"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.g.mapleader= " "
vim.diagnostic.config({
    signs = true,
    virtual_text = true,
})

vim.pack.add({
	'https://github.com/nvim-mini/mini.notify',
	'https://github.com/nvim-mini/mini.statusline',
	'https://github.com/nvim-mini/mini.pick',
	'https://github.com/nvim-mini/mini.indentscope',
	'https://github.com/nvim-mini/mini.pairs',
	'https://github.com/nvim-mini/mini.completion',
	'https://github.com/nvim-mini/mini.sessions',
	'https://github.com/nvim-mini/mini.tabline',
	'https://github.com/nvim-mini/mini.surround',
	'https://github.com/rose-pine/neovim',
	'https://github.com/tpope/vim-fugitive',
	'https://github.com/NotAShelf/direnv.nvim',
	'https://github.com/mason-org/mason.nvim',
	'https://github.com/mason-org/mason-lspconfig.nvim',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/stevearc/conform.nvim',
	'https://github.com/mfussenegger/nvim-lint',

})

require('mini.notify').setup()
vim.notify = require('mini.notify').make_notify()
require('mini.statusline').setup({use_icons= false})
require('mini.pick').setup()
require('mini.indentscope').setup()
require('mini.pairs').setup()
require('mini.completion').setup()
require('mini.sessions').setup()
require('mini.tabline').setup()
require('mini.surround').setup()
require("rose-pine").setup({
    styles = {
        bold = false,
        italic = false
    }
})
vim.cmd('colorscheme rose-pine-dawn')
require("direnv").setup({
    autoload_direnv = true,
})
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {'htmx', 'html', 'cssls', 'templ', 'ruff', 'ty', 'lua_ls', 'gopls', 'clangd', 'rust_analyzer', 'ansiblels', 'powershell_es', 'zls', 'ols'},
    automatic_installation = false,
    automatic_setup = false,
    automatic_enable = false,
    handlers = nil,
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {
          'vim',
          'require'
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,

      },
    },
  },
})

vim.lsp.config('ruff', {
  init_options = {
    settings = {
        logLevel = 'debug',
    }
  }
})

vim.lsp.enable({'html', 'cssls', 'tsgo', 'templ', 'ruff', 'ty', 'gopls', 'clangd', 'rust_analyzer', 'ansiblels', 'powershell_es', 'zls', 'ols'})

require("conform").setup({
    formatters_by_ft = {
        go ={ "gofmt" },
        zig={"zigfmt"},
        c = { "clang_format" },
        cpp = { "clang_format" },
        odin={"odinfmt"}
        rust={"rustfmt"},
        html={"prettier"},
        css={"prettier"},
        js={"prettier"},
        python = {
          "ruff_fix",
          "ruff_format",
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

require("lint").linters_by_ft = {
  python = { "ruff" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

vim.keymap.set("n", "<Leader>ff", MiniPick.builtin.files)
vim.keymap.set("n", "<Leader>fg", MiniPick.builtin.grep_live)
vim.keymap.set("n", "<Leader>fb", MiniPick.builtin.buffers)
vim.keymap.set("n", "<Leader>ls", MiniSessions.select)
vim.keymap.set("n", "<Leader>gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<Leader>gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "<Leader>gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "<Leader>gr", vim.lsp.buf.references)
vim.keymap.set("n", "<Leader>cb", ":bufdo bwipeout<CR>")
vim.keymap.set("n", "<Leader>tt", ":term<CR>")
vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>',{ noremap = true, silent = true })
