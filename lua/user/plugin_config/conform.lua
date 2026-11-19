local ok, conform = pcall(require, "conform")
if not ok then
	return
end

-- The formatter list, kept as a plain table so it stays easy to read. It is
-- wrapped below rather than passed straight to setup().
local by_ft = {
	lua = { "stylua" },
	python = { "isort", "black" },
	sh = { "shfmt" },
	bash = { "shfmt" },
	zsh = { "shfmt" },
	javascript = { "prettier" },
	typescript = { "prettier" },
	javascriptreact = { "prettier" },
	java = { "google-java-format" },
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
}

-- Skip formatters that are not installed rather than failing at format time.
-- nvim-lint already does this for linters; conform has no equivalent setting,
-- but formatters_by_ft accepts a function per filetype and get_formatter_info
-- reports availability, so the filter can live here.
--
-- Deliberately resolved per buffer at format time rather than once at startup:
-- installing a formatter mid-session then works without restarting Neovim, and
-- this config is shared with a Linux machine where a different subset is
-- present. When everything for a filetype is missing the list comes back
-- empty and format_on_save's lsp_fallback takes over, which is the same
-- outcome as having no formatter configured.
--
-- :ConformInfo lists what resolved for the current buffer, and why not.
local formatters_by_ft = {}
for ft, names in pairs(by_ft) do
	formatters_by_ft[ft] = function(bufnr)
		return vim.tbl_filter(function(name)
			return conform.get_formatter_info(name, bufnr).available
		end, names)
	end
end

conform.setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		local max = 200 * 1024
		local okfs, st = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
		if okfs and st and st.size > max then
			return nil
		end
		return { timeout_ms = 1500, lsp_fallback = true }
	end,
	formatters_by_ft = formatters_by_ft,
	formatters = {
		shfmt = { prepend_args = { "-i", "2", "-ci" } },
		clang_format = { prepend_args = { "--style=File" } },
	},
})

-- The format mappings live here rather than in keymaps.lua so they can require
-- conform lazily and say so plainly when it is missing, instead of throwing.
-- Keeping them beside the setup they depend on is also what stops a second copy
-- drifting into keymaps.lua again.
local function fmt()
	local okc, c = pcall(require, "conform")
	if okc then
		c.format({ async = true, lsp_fallback = true })
	else
		vim.notify("Conform not available", vim.log.levels.WARN)
	end
end
vim.keymap.set("n", "<leader>F", fmt, { desc = "Conform: Format buffer" })
vim.keymap.set("n", "<leader>lf", fmt, { desc = "Conform: Format buffer" })

-- Optional: let `gq` use Conform
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
