local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use 'marko-cerovac/material.nvim'
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }
  --LSP
  use {'neovim/nvim-lspconfig'}
  use {'williamboman/nvim-lsp-installer', requires = 'neovim/nvim-lspconfig'}
  use {'kosayoda/nvim-lightbulb'}
  -- Startup
  use {'glepnir/dashboard-nvim', requires={'nvim-telescope/telescope.nvim', 'nvim-lua/popup.nvim','nvim-lua/plenary.nvim'}}
  -- Highlighting
  use 'sheerun/vim-polyglot'
  use 'scrooloose/syntastic'
  use 'windwp/nvim-autopairs'
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Git
  use "lewis6991/gitsigns.nvim"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
