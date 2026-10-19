return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	config = function()
		require("markview").setup({
			preview = {
				enable = false,
			},
		})

		vim.keymap.set("n", "<leader>M", "<Cmd>Markview Toggle<CR>", { desc = "Markview: toggle globally" })
	end,
}
