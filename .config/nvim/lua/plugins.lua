vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])
return require('packer').startup(
  function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Compe
  use {"hrsh7th/nvim-cmp", 
   requires = {    
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-buffer",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp"
    },
  }
  use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}

  use 'marko-cerovac/material.nvim'
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }
  --LSP
  use {'neovim/nvim-lspconfig'}
  use {'kabouzeid/nvim-lspinstall', requires = 'neovim/nvim-lspconfig'}
  use {'kosayoda/nvim-lightbulb'}
  -- Startup
  use {'glepnir/dashboard-nvim', requires={'nvim-telescope/telescope.nvim', 'nvim-lua/popup.nvim','nvim-lua/plenary.nvim'}}
  -- Highlighting
  use 'sheerun/vim-polyglot'
  use 'scrooloose/syntastic'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }
use {'Pocco81/AutoSave.nvim', config= function ()
  require("autosave").setup()
end}
use {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup {}
  end
}
use {
  "ahmedkhalf/lsp-rooter.nvim",
  config = function()
    require("lsp-rooter").setup {
    }
  end
}
use {"npxbr/glow.nvim", run = ":GlowInstall"}
use {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate'
}
use 'sbdchd/neoformat'
use {
  'ojroques/nvim-lspfuzzy',
  requires = {
    {'junegunn/fzf'},
    {'junegunn/fzf.vim'}, 
  },
  config= function ()
    require('lspfuzzy').setup {}
  end
}
use 'kdheepak/lazygit.nvim'
use "lukas-reineke/indent-blankline.nvim"
use {
  'kyazdani42/nvim-tree.lua',
  requires = 'kyazdani42/nvim-web-devicons'
}
use "wlangstroth/vim-racket"
use "tpope/vim-unimpaired"
end)