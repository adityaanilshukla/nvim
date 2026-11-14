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

-- Homebrew's llvm is keg-only, so clang-tidy isn't on PATH on macOS.
local brew_clang_tidy = "/opt/homebrew/opt/llvm/bin/clang-tidy"
if vim.fn.executable("clang-tidy") == 0 and vim.fn.executable(brew_clang_tidy) == 1 then
	lint.linters.clangtidy.cmd = brew_clang_tidy
end

-- Without a project .clang-tidy, llvm's default is clang-diagnostic-* alone,
-- which clang-tidy treats as "no checks enabled". This is appended to any
-- project config rather than replacing it.
table.insert(lint.linters.clangtidy.args, "--checks=clang-analyzer-*")

-- Checkstyle writes file:/path URIs, but nvim-lint's SARIF parser only
-- recognises file:///path, so every result was dropped as another file's.
local sarif = lint.linters.checkstyle.parser
lint.linters.checkstyle.parser = function(output, ...)
	return sarif((output:gsub('"file:/([^/])', '"file:///%1')), ...)
end

-- Skip linters that aren't installed, so a missing binary doesn't throw on
-- every BufEnter. <leader>L below still runs them all, and says what's missing.
local function installed(linter)
	local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
	return vim.fn.executable(cmd) == 1
end

-- Run on write/insert-leave, and on buffer enter
local aug = vim.api.nvim_create_augroup("NvimLint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
	group = aug,
	callback = function()
		lint.try_lint(nil, { filter = installed })
	end,
})

-- Optional keymap for on-demand lint
vim.keymap.set("n", "<leader>L", function() require("lint").try_lint() end,
	{ desc = "nvim-lint: Lint buffer" })
