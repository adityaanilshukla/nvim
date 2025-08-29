-- vim.g.tex_flavor = "latex"
-- vim.g.vimtex_view_method = "zathura"
-- vim.g.temtex_quickfix_mode = 0
-- vim.g.conceallevel = 1
-- vim.g.tex_conceal = "abdmg"

-- HAL recommendation
-- VimTeX core
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_mappings_enabled = 1
vim.g.vimtex_syntax_enabled = 1
vim.g.vimtex_complete_enabled = 1

-- latexmk: continuous + fast + synctex
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
	build_dir = "build",
	options = {
		"-pdf",
		"-interaction=nonstopmode",
		"-synctex=1",
		"-file-line-error",
		"-halt-on-error",
		"-shell-escape",
	},
	continuous = 1,
}

-- Zathura inverse search via nvr
vim.g.vimtex_view_general_viewer = "zathura"
vim.g.vimtex_view_general_options =
	[[--synctex-forward @line:@col:@tex --synctex-editor-command "nvr --remote-silent +%{line} %{input}"]]
