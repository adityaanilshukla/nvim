local ok, lint = pcall(require, "lint")
if not ok then return end

lint.linters_by_ft = {
	lua        = { "luacheck" }, -- or "selene" if you use it
	python     = { "ruff" }, -- fast, modern; can replace flake8
	sh         = { "shellcheck" },
	bash       = { "shellcheck" },
	zsh        = { "shellcheck" },
	javascript = { "eslint_d" }, -- use eslint_d for speed
	typescript = { "eslint_d" },
	json       = { "eslint_d" }, -- if you have JSON rules; else remove
	yaml       = { "yamllint" },
	markdown   = {},      -- usually handled by ltex LSP if enabled
	c          = { "clangtidy" },
	cpp        = { "clangtidy" },
	java       = { "checkstyle" },
}

-- Run on write/insert-leave, and on buffer enter
local aug = vim.api.nvim_create_augroup("NvimLint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
	group = aug,
	callback = function()
		-- Only lint if a linter exists for the filetype
		if lint.linters_by_ft[vim.bo.filetype] then
			lint.try_lint()
		end
	end,
})

-- Optional keymap for on-demand lint
vim.keymap.set("n", "<leader>L", function() require("lint").try_lint() end,
	{ desc = "nvim-lint: Lint buffer" })
