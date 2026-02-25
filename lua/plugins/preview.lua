return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	config = function()
		vim.keymap.set("n", "<leader>M", "<Cmd>Markview Toggle<CR>", { desc = "Markview: toggle globally" })
	end,
}
