local trouble_status_ok, trouble = pcall(require, "trouble")
if not trouble_status_ok then
	return
end

trouble.setup({
	use_diagnostic_signs = false,
})
