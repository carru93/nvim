require("config.lazy")
require("config.filetypes")

-- Enable nerd fonts
vim.g.have_nerd_font = true

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse in all modes
vim.opt.mouse = "a"

-- Do not show status because it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and neovim
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Other search stuff
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.opt.confirm = true

-- Set timeout to have enough time to complete key bindings
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Set colorscheme
vim.cmd.colorscheme("catppuccin-frappe")

-- Indenting
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Should line wrap?
vim.opt.wrap = false

-- Undo access long ago mods
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true

-- Update time
vim.opt.updatetime = 50

-- Move bunch of text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in place on J
vim.keymap.set("n", "J", "mzJ'z")

-- Keep cursor in center on move
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Try not to lose clipboard
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("v", "<leader>d", '"_dP')
vim.keymap.set("n", "<leader>d", '"_dP')

-- Folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldcolumn = "1"
vim.o.foldlevel = 1
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Navigate diagnostic
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "LSP: Show diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "LSP: Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "LSP: Next diagnostic" })

-- Diagnostic icons
local sign_text = {
	[vim.diagnostic.severity.ERROR] = " ",
	[vim.diagnostic.severity.WARN] = " ",
	[vim.diagnostic.severity.INFO] = " ",
	[vim.diagnostic.severity.HINT] = " ",
}
vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 2 },
	signs = { text = sign_text },
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many", header = "", prefix = "" },
})

-- Toggle manual folding method for performance on big files
vim.keymap.set("n", "<leader>m", function()
	if vim.o.foldmethod == "indent" then
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.notify("Fold method set to Treesitter (expr)", vim.log.levels.INFO)
	else
		vim.opt.foldmethod = "indent"
		vim.opt.foldexpr = nil
		vim.notify("Fold method set to Indent", vim.log.levels.INFO)
	end
end, { desc = "Toggle foldmethod between treesitter and indent" })
