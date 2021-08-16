
local execute = vim.api.nvim_command
local fn = vim.fn
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api
local lsp = vim.lsp
-- Compe
require('compe').setup {
    enabled = true;
    min_length = 1;
    autocomplete = true;
    source = {
      path = true;
      buffer = true;
      calc = true;
      nvim_lsp = true;
      nvim_lua = true;
      vsnip = true;
      tabnine = true;
      treesitter=true;
    };
  }
local t = function(str)
   return api.nvim_replace_termcodes(str, true, true, true)
end
local check_back_space = function()
  local col = fn.col('.') - 1
  return col == 0 or fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
if fn.pumvisible() == 1 then
  return t "<C-n>"
elseif fn['vsnip#available'](1) == 1 then
  return t "<Plug>(vsnip-expand-or-jump)"
elseif check_back_space() then
  return t "<Tab>"
else
  return fn['compe#complete']()
end
end
_G.s_tab_complete = function()
if fn.pumvisible() == 1 then
  return t "<C-p>"
elseif fn['vsnip#jumpable'](-1) == 1 then
  return t "<Plug>(vsnip-jump-prev)"
else
  -- If <S-Tab> is not working in your terminal, change it to <C-h>
  return t "<S-Tab>"
end
end

api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true});
api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true});
api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true});
api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true});
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
g.material_italic_comments = true
g.material_italic_keywords = true
g.material_italic_functions = true
g.material_italic_variables = false
require('lualine').setup {
  options = {
    theme = 'material-nvim'
  }
}
require('material').set()

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
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
g.neoformat_enabled_python = {'autopep8', 'black', 'docformatter'}
g.indentLine_fileTypeExclude = {'dashboard'}