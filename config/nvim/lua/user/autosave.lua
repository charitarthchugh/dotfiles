local autosave_status_ok, autosave = pcall(require, "autosave")
if not autosave_status_ok then
  return
end

autosave.setup({
  enabled=true,
})
