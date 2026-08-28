-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle terminal (snacks.nvim, ships with LazyVim). Overrides the default <leader>/ grep.
-- ponytail: reuses snacks terminal instead of adding toggleterm; add that plugin only if you need its extras
vim.keymap.set("n", "<leader>/", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
