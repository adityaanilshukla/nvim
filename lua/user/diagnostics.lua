-- lua/user/diagnostics.lua
-- Inline diagnostics (“ghost text”) + hover popups + toggles

-- Keep the letter signs you’re seeing now
for t, s in pairs({ Error = "E", Warn = "W", Info = "I", Hint = "H" }) do
	local hl = "DiagnosticSign" .. t
	vim.fn.sign_define(hl, { text = s, texthl = hl, numhl = "" })
end

-- Format ghost text as: message [CODE] (source)
local function vt_format(d)
	local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code)
	if code and d.source then
		return string.format("%s [%s] (%s)", d.message, code, d.source)
	elseif code then
		return string.format("%s [%s]", d.message, code)
	elseif d.source then
		return string.format("%s (%s)", d.message, d.source)
	end
	return d.message
end

vim.diagnostic.config({
	virtual_text = { prefix = "▎", spacing = 1, source = "if_many", format = vt_format },
	underline = true,
	signs = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many", focusable = false },
})

-- Cursor-hold popup with the full diagnostic under the cursor
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("DiagFloat", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, { scope = "cursor", border = "rounded", focusable = false })
	end,
})

-- === DIAGNOSTIC TOGGLES (drop-in) ===

-- Always define letter signs; we'll re-apply when signs are re-enabled
local function define_diag_signs()
	for t, s in pairs({ Error = "E", Warn = "W", Info = "I", Hint = "H" }) do
		local hl = "DiagnosticSign" .. t
		vim.fn.sign_define(hl, { text = s, texthl = hl, numhl = "" })
	end
end
define_diag_signs()

-- ghost text formatter
local function vt_format(d)
	local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code)
	if code and d.source then
		return string.format("%s [%s] (%s)", d.message, code, d.source)
	end
	if code then
		return string.format("%s [%s]", d.message, code)
	end
	if d.source then
		return string.format("%s (%s)", d.message, d.source)
	end
	return d.message
end

-- current state
local DIAG = { vt = true, signs = true }

local function apply_diag()
	vim.diagnostic.config({
		virtual_text = DIAG.vt and { prefix = "▎", spacing = 1, source = "if_many", format = vt_format } or false,
		underline = true,
		signs = DIAG.signs,
		update_in_insert = false,
		severity_sort = true,
		float = { border = "rounded", source = "if_many", focusable = false },
	})
	if DIAG.signs then
		define_diag_signs()
	end -- ensure W/I/H/E letters come back
end
apply_diag()

-- Toggle ONLY ghost text
vim.keymap.set("n", "<leader>ud", function()
	DIAG.vt = not DIAG.vt
	apply_diag()
	vim.notify("Ghost text: " .. (DIAG.vt and "ON" or "OFF"))
end, { desc = "Diagnostics: toggle ghost text" })

-- Toggle ONLY sign letters
vim.keymap.set("n", "<leader>uD", function()
	DIAG.signs = not DIAG.signs
	apply_diag()
	vim.notify("Diag signs (W/I/H/E): " .. (DIAG.signs and "ON" or "OFF"))
end, { desc = "Diagnostics: toggle sign letters" })

-- Cursor-hold popup (kept)
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("DiagFloat", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, { scope = "cursor", border = "rounded", focusable = false })
	end,
})

-- Inlay hint toggle that works on stable & nightly; also clears when disabling
local ih = vim.lsp.inlay_hint
if ih then
	local function ih_is_enabled(buf)
		return (pcall(ih.is_enabled, { bufnr = buf })) and ih.is_enabled({ bufnr = buf })
			or (pcall(ih.is_enabled, buf) and ih.is_enabled(buf))
			or false
	end
	local function ih_enable(buf, val)
		if pcall(ih.enable, val, { bufnr = buf }) then
			return
		end
		if pcall(ih.enable, { bufnr = buf }, val) then
			return
		end
		if pcall(ih.enable, buf, val) then
			return
		end
		pcall(ih, buf, val)
	end
	vim.keymap.set("n", "<leader>uh", function()
		local buf = vim.api.nvim_get_current_buf()
		local new = not ih_is_enabled(buf)
		ih_enable(buf, new)
		if not new and ih.clear then
			pcall(ih.clear, buf)
		end
		vim.notify("Inlay hints: " .. (new and "ON" or "OFF"))
	end, { desc = "Toggle inlay hints" })
end
