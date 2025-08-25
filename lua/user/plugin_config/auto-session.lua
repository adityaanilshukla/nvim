local ok, autosession = pcall(require, "auto-session")
if not ok then return end

autosession.setup({
  log_level = "error",
  auto_session_enable_last_session = false,
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_suppress_dirs = { "~/" },
})
