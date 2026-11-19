-- Snippets live in UltiSnips/ inside this config (tex.snippets today).
-- That directory is not on UltiSnips' default search path, so it is named
-- explicitly below, alongside the default name so plugin-shipped snippets
-- still load.
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips", vim.fn.stdpath("config") .. "/UltiSnips" }
