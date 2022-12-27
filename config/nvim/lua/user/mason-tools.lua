local mason_ok, mason = pcall(require, "mason")
local mason_tools_installer_ok, mason_tools_installer = pcall(require, "mason-tool-installer") 
if not mason_ok then
  return
end
if not mason_tools_installer_ok then
  return
end

local tools = {
  "debugpy",
  "black",
  "chrome-debug-adapter",
  "codespell",
  "firefox-debug-adapter",
  "dockerfile-language-server",
  "gitlint",
  "isort",
  "prettier",
  "pylint",
  "pyright",
  "shfmt",
  "stylua",
  "yamllint",
  "markdownlint",
  "node-debug2-adapter",
}

mason_tools_installer.setup({
  ensure_installed = tools,
  auto_update = true
})
