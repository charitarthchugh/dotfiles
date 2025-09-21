return {
  -- add gruvbox
  {
    "Mofiqul/adwaita.nvim",
    config = function()
      -- vim.g.adwaita_darker = true
      vim.g.adwaita_transparent = true
    end,
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "adwaita",
    },
  },
}
