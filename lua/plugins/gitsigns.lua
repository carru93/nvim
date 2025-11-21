return {
	-- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	},
	config = function()
		local gitsigns = require("gitsigns")
		vim.keymap.set("n", "<leader>gl", gitsigns.toggle_linehl, { desc = "Gitsigns: toggle line highlight" })
		vim.keymap.set("n", "<leader>gn", gitsigns.next_hunk, { desc = "Gitsigns: go to next hunk" })
		vim.keymap.set("n", "<leader>gN", gitsigns.prev_hunk, { desc = "Gitsigns: go to prev hunk" })
		vim.keymap.set(
			"n",
			"<leader>gb",
			gitsigns.toggle_current_line_blame,
			{ desc = "Gitsigns: toggle current line blame" }
		)
		vim.keymap.set("n", "<leader>gd", gitsigns.preview_hunk_inline, { desc = "Gitsigns: preview hunk line" })
		vim.keymap.set("n", "<leader>gu", require("gitsigns").reset_hunk, { desc = "Gitsigns: reset hunk" })
		vim.keymap.set("v", "<leader>gu", function()
			require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Gitsigns: reset selected hunk" })
		vim.keymap.set("n", "<leader>gU", require("gitsigns").reset_buffer, { desc = "Gitsigns: reset whole buffer" })
	end,
}
