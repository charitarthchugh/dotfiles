local execute = vim.api.nvim_command
local fn = vim.fn
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api
local lsp = vim.lsp
-- LSP
local lsp_installer = require 'nvim-lsp-installer'
lsp_servers = {
"bashls",
"html",
"eslint",
"jsonls",
"grammarly",
"ltex",
'sunneko_lua',
"pyright",
"xml",
"yaml",
-- "remark_ls",
"tsserver"
}
for _, name in pairs(lsp_servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found then
    if not server:is_installed() then
      print("Installing " .. name)
      server:install()
    end
  end
end
lsp_installer.on_server_ready(function(server)
  local opts = {}
  server:setup(opts) 
end)
-- Cmp
local lspkind = require('lspkind')
local cmp = require('cmp')
cmp.setup({
  formatting = {
    format = lspkind.cmp_format(),
  },  
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
    -- { name = 'treesitter'},
    -- For vsnip user.
    { name = 'vsnip' },

    -- For luasnip user.
    { name = 'luasnip' },
     -- Tabnine 
    { name = 'cmp_tabnine' },
    { name = 'cmp_git'},
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'buffer' },
  }
})
local npairs = require("nvim-autopairs")
npairs.setup({
  disable_filetype= { "dashboard", "TelescopePrompt"},
  check_ts = true,
  ignored_next_char = "[%w%.]"
})
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
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
g.syntastic_enable_racket_racket_checker = 1
-- Colorscheme and Statusline
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
g.neoformat_enabled_python = {'black', 'docformatter'}
g.indentLine_fileTypeExclude = {'dashboard'}
-- NvimTree
-- g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
require'nvim-tree'.setup({
  auto_close = true,
  open_on_tab = true,
  diagnostics = {
    enable = true
  },
  ignore__ft_on_setup = {"dashboard"}
})


cmd[[
  nnoremap <C-n> :NvimTreeToggle<CR>
]]
cmd[[
  nnoremap <leader>r :NvimTreeRefresh<CR>
]]
cmd[[
  nnoremap <leader>n :NvimTreeFindFile<CR>
]]
require("autosave").setup({
  on_off_commands = true,
  events = {"InsertLeave"}
})
require('bufferline').setup({
  diagnostics = "nvim_lsp",
  offsets = {
    {
      filetype = "NvimTree",
      text = function()
        return fn.getcwd()
      end,
      highlight = "Directory",
      text_align = "left"
    }
  }
  -- offsets = {filetype = "NvimTree", text = "File Explorer" | function , text_align = "left" | "center" | "right"},
})
-- Custom Mapping
cmd[[
  nnoremap <silent>[b :BufferLineCycleNext<CR>
  nnoremap <silent>b] :BufferLineCyclePrev<CR>
  nnoremap <silent><C-1> <Cmd>BufferLineGoToBuffer 1<CR>
  nnoremap <silent><C-2> <Cmd>BufferLineGoToBuffer 2<CR>
  nnoremap <silent><C-3> <Cmd>BufferLineGoToBuffer 3<CR>
  nnoremap <silent><C-4> <Cmd>BufferLineGoToBuffer 4<CR>
  nnoremap <silent><C-5> <Cmd>BufferLineGoToBuffer 5<CR>
  nnoremap <silent><C-6> <Cmd>BufferLineGoToBuffer 6<CR>
  nnoremap <silent><C-7> <Cmd>BufferLineGoToBuffer 7<CR>
  nnoremap <silent><C-8> <Cmd>BufferLineGoToBuffer 8<CR>
  nnoremap <silent><C-9> <Cmd>BufferLineGoToBuffer 9<CR>
]]
cmd[[
autocmd InsertLeave * execute ':Neoformat'
]]
cmd[[
autocmd BufWritePre *.py execute ':Black'
]]
cmd[[
tnoremap <Esc> <C-\><C-n>
]]
