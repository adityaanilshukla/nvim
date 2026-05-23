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
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
