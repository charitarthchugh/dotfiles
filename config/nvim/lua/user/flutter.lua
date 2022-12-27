local status_ok, fluttertools = pcall(require, "flutter-tools")
if not status_ok then
  return
end

fluttertools.setup({
  ui = {
    notification_style = 'plugin'
  },
  decorations = {
    statusline = {
      app_version = true,
      device = true,
    }
  },
  dev_tools = {
    autostart = true
  },
  lsp = {
    color = {
      enabled = true
    }
  }
})
