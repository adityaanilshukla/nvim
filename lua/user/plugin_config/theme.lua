-- central place to choose theme
local ok, _ = pcall(vim.cmd, "colorscheme carbonfox")
if not ok then
  pcall(vim.cmd, "colorscheme kanagawa")
end

-- statusline transparency like before
vim.cmd("hi statusline guibg=NONE guifg=NONE")
vim.cmd("hi statuslineNC guibg=NONE guifg=NONE")
