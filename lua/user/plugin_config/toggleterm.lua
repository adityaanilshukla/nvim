local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
	return
end
toggleterm.setup({
	direction = "tab", -- opens in a new tab, full screen
	open_mapping = [[<F7>]],
	close_on_exit = true,
	shade_terminals = true,
})
