local ok_dap, dap = pcall(require, "dap")
local ok_ui, dapui = pcall(require, "dapui")
if not (ok_dap and ok_ui) then
	if not ok_dap then
		vim.notify("nvim-dap not available", vim.log.levels.ERROR)
	end
	if not ok_ui then
		vim.notify("nvim-dap-ui not available", vim.log.levels.ERROR)
	end
	return
end

dapui.setup()

-- Open/close UI automatically
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- extra listeners (match your original)
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end

-- Python adapter config (separate file)
pcall(require, "user.dap.python")

-- DAP keymaps localized here so keymaps.lua doesn't need to require('dap')
vim.keymap.set("n", "<F5>", function()
	dap.continue()
end, { desc = "DAP: Continue / Start" })
vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end, { desc = "DAP: Step Over" })
vim.keymap.set("n", "<F11>", function()
	dap.step_into()
end, { desc = "DAP: Step Into" })
vim.keymap.set("n", "<F12>", function()
	dap.step_out()
end, { desc = "DAP: Step Out" })
vim.keymap.set("n", "<Leader>b", function()
	dap.toggle_breakpoint()
end, { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>B", function()
	dap.set_breakpoint()
end, { desc = "DAP: Set Conditional Breakpoint" })
vim.keymap.set("n", "<Leader>dr", function()
	dap.repl.open()
end, { desc = "DAP: Open REPL" })
vim.keymap.set("n", "<Leader>dl", function()
	dap.run_last()
end, { desc = "DAP: Run Last" })
