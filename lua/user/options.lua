vim.cmd("colorscheme carbonfox")
vim.cmd("set completeopt+=noselect")

vim.opt.number = true
vim.opt.relativenumber = true
vim.wo.winfixwidth = true
vim.wo.wrap = false
vim.o.clipboard = "unnamedplus"
vim.o.fillchars = "eob: "
vim.o.tabstop = 4
vim.opt.swapfile = false
vim.opt.showmode = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false
vim.opt.foldcolumn = "0"
vim.opt.showcmd = false
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions,"
vim.o.showtabline = 2
vim.opt.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.opt.spelllang = { "en_us" }
vim.opt.spell = true

-- $NEET opens the practice list the way $MYVIMRC opens this config:
-- `:e $NE<Tab>` completes it, and nothing else in the environment starts NE.
--
-- Stored expanded rather than as a literal "~". :edit would cope either way,
-- but vim.env is exported to child processes, and a tilde inside a variable is
-- NOT expanded by the shell -- so the absolute form is what makes `:!wc -l
-- $NEET` and the same reference inside :terminal work. expand() also keeps the
-- repo portable to brovo, where HOME is /home/aditya.
--
-- The list lives in the Syncthing tree beside the solutions, so ticking one off
-- reaches the other machines -- and, as with the solutions, editing it on two
-- at once earns a *.sync-conflict-* file rather than a merge.
vim.env.NEET = vim.fn.expand("~/Documents/Notes/BUCK_TFUP/neetcode_150.txt")

-- :qnlist opens the list from anywhere, which `:e $NEET` cannot. leetcode.nvim
-- pins its menu, question and description windows with winfixbuf, and :edit
-- swaps the buffer *in the current window* -- exactly what that forbids, so
-- from inside the plugin you get E1513. Making a new window is unaffected.
--
-- The command itself has to be :Qnlist, because vim rejects a user command that
-- does not start with a capital (E183). The abbreviation below is what lets the
-- lowercase spelling work, and it is guarded on the whole command line matching
-- so it cannot fire in the middle of a path or an argument.
--
-- Worth knowing while that UI has focus: this is not special to the list. ]b,
-- [b, Telescope and Neo-tree all open into the current window too, so they hit
-- the same wall until you are out of a pinned window.
vim.api.nvim_create_user_command("Qnlist", function()
	-- Try the plain edit and fall back, rather than reading winfixbuf and
	-- deciding up front. Same result in the common case, but it does not depend
	-- on the pin being on *this* window: the plugin uses several, and anything
	-- else that refuses the switch gets the same escape hatch for free.
	local target = vim.fn.fnameescape(vim.env.NEET)
	if not pcall(vim.cmd, "edit " .. target) then
		vim.cmd("tabedit " .. target)
	end
end, { desc = "Open the NeetCode 150 list" })

vim.cmd([[cnoreabbrev <expr> qnlist (getcmdtype() == ":" && getcmdline() ==# "qnlist") ? "Qnlist" : "qnlist"]])

-- statusline transparency like before
vim.cmd("hi statusline guibg=NONE guifg=NONE")
vim.cmd("hi statuslineNC guibg=NONE guifg=NONE")
