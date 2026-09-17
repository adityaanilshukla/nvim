local ok, nts = pcall(require, "nvim-treesitter")
if not ok then return end

nts.setup()

-- Parsers to keep installed. Edit this list and run :TSUpdate (or restart) to sync.
-- (html is needed by leetcode.nvim to render question descriptions.)
local parsers = {
  "bash", "c", "cpp", "go", "html", "java", "javascript", "json",
  "lua", "markdown", "markdown_inline", "python", "query", "regex",
  "rust", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}
-- Block startup only on first run (when parsers are missing) so Neovim's
-- built-in ftplugins for markdown/help/lua/query don't error before the
-- parsers exist. install() is a no-op for already-installed parsers.
local installed = nts.get_installed()
local missing = vim.tbl_filter(function(p) return not vim.list_contains(installed, p) end, parsers)
local handle = nts.install(parsers)
if #missing > 0 then
  vim.notify(("nvim-treesitter: installing %d parsers..."):format(#missing), vim.log.levels.INFO)
  handle:wait(300000)
end

-- Enable highlighting (and indent, where supported) per filetype. pcall handles
-- buffers whose parser is still installing or whose filetype has none.
--
-- The indentexpr is only set where nothing else claimed one. nvim-treesitter's
-- indentation is experimental by its own documentation, and where Neovim ships
-- a hand-written indent script the shipped one is better. Python is the case
-- that proved it: after a `return`, treesitter indents the next line to column
-- 0 instead of dedenting one level to the enclosing block, so leaving an `if`
-- body threw the cursor to the start of the line.
--
--   after "        return False"      stock nvim: 8      treesitter: 0
--
-- This autocmd is registered after the runtime's own FileType autocmds, so by
-- the time it runs a shipped indent script has already set indentexpr and the
-- check below sees it. Filetypes with no indent script still get treesitter,
-- which is the half of this that was worth having.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if not pcall(vim.treesitter.start, args.buf) then return end
    if vim.bo[args.buf].indentexpr ~= "" then return end
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
