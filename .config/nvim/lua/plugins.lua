vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])
return require('packer').startup(
  function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Compe
  use "hrsh7th/nvim-compe" --completion
  use {'tzachar/compe-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-compe'}
  -- Colorscheme, statusline
-- If you are using Packer
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
use {'ms-jpq/chadtree', branch="chad", run="python3 -m chadtree deps"}
end)