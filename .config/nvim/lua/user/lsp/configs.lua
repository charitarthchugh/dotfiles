local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
	return
end

local mason = require("mason")
mason.setup({
  ui={
    border = "rounded"
  }
})

local servers = { "jsonls", "sumneko_lua", "bashls", "html", "eslint", "tsserver", "yamlls","clangd", "pyright", "grammarly", "ltex", "lemminx"}

mason_lspconfig.setup {
	ensure_installed = servers,
  automatic_installation = true
}
local lspconfig = require("lspconfig")
for _, server in pairs(servers) do
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
	if has_custom_opts then
	 	opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
	end
	lspconfig[server].setup(opts)
end
