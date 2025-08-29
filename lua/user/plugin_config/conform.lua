local ok, conform = pcall(require, "conform")
if not ok then
	return
end

conform.setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		local max = 200 * 1024
		local okfs, st = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
		if okfs and st and st.size > max then
			return nil
		end
		return { timeout_ms = 1500, lsp_fallback = true }
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		yaml = { "prettier" },
		toml = { "taplo" },
		markdown = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		c = { "clang_format" },
		cpp = { "clang_format" },
		tex = { "latexindent" },
	},
	formatters = {
		shfmt = { prepend_args = { "-i", "2", "-ci" } },
		clang_format = { prepend_args = { "--style=File" } },
	},
})

-- 4) keymaps.lua — make mappings resilient if Conform isn’t loaded yet
local function fmt()
	local okc, c = pcall(require, "conform")
	if okc then
		c.format({ async = true, lsp_fallback = true })
	else
		vim.notify("Conform not available", vim.log.levels.WARN)
	end
end
vim.keymap.set("n", "<leader>F", fmt, { desc = "Conform: Format buffer" })
vim.keymap.set("n", "<leader>lf", fmt, { desc = "Conform: Format buffer" }) -- overrides old LSP format

-- Optional: let `gq` use Conform
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
