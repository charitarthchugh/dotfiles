local execute = vim.api.nvim_command
local fn = vim.fn
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api
local lsp = vim.lsp
-- Compe
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

      -- For `luasnip` user.
      require('luasnip').lsp_expand(args.body)

      -- For `ultisnips` user.
      -- vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
  },
  sources = {
    { name = 'nvim_lsp' },

    -- For vsnip user.
    { name = 'vsnip' },

    -- For luasnip user.
    { name = 'luasnip' },
     -- Tabnine 
    { name = 'cmp_tabnine' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'buffer' },
  }
})
require("nvim-autopairs").setup({
  disable_filetype={"dashboard", "TelescopePrompt"}
})
require("nvim-autopairs.completion.cmp").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
  auto_select = true, -- automatically select the first item
  insert = false, -- use insert confirm behavior instead of replace
  map_char = { -- modifies the function or method delimiter by filetypes
    all = '(',
    tex = '{'
  },
  ignored_next_char = "[%w%.]"
})
-- Snippet Support
local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
-- Colorscheme and Statusline
--Lua:
g.material_style = "deep ocean"
require("material").setup({
  italics = {
    comments = true,
    strings=false,
    functions=true,
    variables=true
  }
})
require('lualine').setup {
  options = {
    theme = 'material-nvim'
  }
}
cmd([[colorscheme material]])

opt.termguicolors = true;
-- Dashboard
g.dashboard_default_executive ='telescope';
--LSP
require('lspinstall').setup(); -- important

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end

setup_servers()
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
fn.sign_define('LightBulbSign', { text = "", texthl = "", linehl="", numhl="" })

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
g.neoformat_enabled_python = {'autopep8', 'black', 'docformatter'}
g.indentLine_fileTypeExclude = {'dashboard'}
-- NvimTree

g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
g.nvim_tree_allow_resize = 1
g.nvim_tree_auto_close = 0 -- closes tree when it's the last window
g.nvim_tree_auto_ignore_ft = { "dashboard" } -- don't open tree on specific fiypes.
g.nvim_tree_auto_open = 0
g.nvim_tree_disable_netrw = 1
g.nvim_tree_follow = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_gitignore = 1
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_hijack_netrw = 0
g.nvim_tree_indent_markers = 1
g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
g.nvim_tree_quit_on_open = 0 -- closes tree when file's opened
g.nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" }
g.nvim_tree_side = "left"
g.nvim_tree_tab_open = 0
g.nvim_tree_update_cwd = 1
g.nvim_tree_width = 25
g.nvim_tree_lsp_diagnostics = 0

g.nvim_tree_show_icons = {
   folders = 1,
   -- folder_arrows= 1
   files = 1,
   git = 1,
}

g.nvim_tree_icons = {
   default = "",
   symlink = "",
   git = {
      deleted = "",
      ignored = "◌",
      renamed = "➜",
      staged = "✓",
      unmerged = "",
      unstaged = "✗",
      untracked = "★",
   },
   folder = {
      -- disable indent_markers option to get arrows working or if you want both arrows and indent then just add the arrow icons in front            ofthe default and opened folders below!
      -- arrow_open = "",
      -- arrow_closed = "",
      default = "",
      empty = "", -- 
      empty_open = "",
      open = "",
      symlink = "",
      symlink_open = "",
   },
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
require("lspconfig").latex.setup({
   capabilities = capabilities
})
require("lspconfig").yaml.setup({
   capabilities = capabilities
})
require("lspconfig").vim.setup({
   capabilities = capabilities
})
require("lspconfig").python.setup({
   capabilities = capabilities
})
require("lspconfig").lua.setup({
   capabilities = capabilities
})
require("lspconfig").json.setup({
   capabilities = capabilities
})