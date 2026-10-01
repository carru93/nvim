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
		vim.keymap.set("n", "<leader>ga", function()
			gitsigns.stage_buffer(function()
				-- neo-tree's git_status source only auto-refreshes on `User FugitiveChanged`,
				-- so tell it explicitly that the index changed.
				vim.schedule(function()
					local ok, events = pcall(require, "neo-tree.events")
					if ok then
						events.fire_event(events.GIT_EVENT)
					end
				end)
			end)
		end, { desc = "Gitsigns: [G]it [A]dd whole file + refresh git sidebar" })
		vim.keymap.set("n", "<leader>gu", require("gitsigns").reset_hunk, { desc = "Gitsigns: reset hunk" })
		vim.keymap.set("v", "<leader>gu", function()
			require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Gitsigns: reset selected hunk" })
		vim.keymap.set("n", "<leader>gU", require("gitsigns").reset_buffer, { desc = "Gitsigns: reset whole buffer" })
	end,
}
