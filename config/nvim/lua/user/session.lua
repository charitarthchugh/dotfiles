local session_status_ok, session = pcall(require, "auto-session")
if not session_status_ok then
	return
end
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
session.setup({
  log_level = "error",
  auto_restore_enabled = false,
  auto_save_enabled = true
})
