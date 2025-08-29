-- Tell UltiSnips to also search in "snips"
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips", vim.fn.stdpath("config") .. "/UltiSnips" }
