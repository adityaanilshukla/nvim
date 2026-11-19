local ok, autosession = pcall(require, "auto-session")
if not ok then
	return
end

autosession.setup({
	log_level = "error",
	auto_restore_last_session = false,
	enabled = true,
	auto_save = true,
	auto_restore = true,
	suppressed_dirs = { "~/" },
})
