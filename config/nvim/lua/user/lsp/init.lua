local lspconfig_status_ok, _ = pcall(require, "lspconfig")
local mason_staus_ok, _ = pcall(require, "mason")
if not lspconfig_status_ok then
  return
end
if not mason_staus_ok then
  return
end

require "user.lsp.configs"
require("user.lsp.handlers").setup()
require "user.lsp.null-ls"
