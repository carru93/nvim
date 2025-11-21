return {
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				-- Start in "on-demand" mode: no automatic ghost text
				auto_trigger = false,
				-- Avoid overlapping with completion popup (nvim-cmp, etc.)
				hide_during_completion = true,
				-- Small debounce so Copilot isn't spammed but feels responsive
				debounce = 75,
				-- Disable builtin keymaps: we define our own below
				keymap = {
					accept = false,
					accept_word = false,
					accept_line = false,
					next = false,
					prev = false,
					dismiss = false,
				},
			},

			-- Disable Copilot pane
			panel = {
				enabled = false,
				auto_refresh = false,
			},

			-- Enable Copilot for all filetypes
			filetypes = { ["*"] = true },
		},

		config = function(_, opts)
			local copilot = require("copilot")
			copilot.setup(opts)

			local suggestion = require("copilot.suggestion")

			----------------------------------------------------------------------
			-- INSERT MODE: inline suggestions navigation & acceptance
			----------------------------------------------------------------------

			-- Ask Copilot for the *next* suggestion (and show it inline)
			vim.keymap.set("i", "<C-n>", function()
				suggestion.next()
			end, { desc = "Copilot: next inline suggestion" })

			-- Go back to previous suggestion (if multiple are available)
			vim.keymap.set("i", "<C-p>", function()
				suggestion.prev()
			end, { desc = "Copilot: previous inline suggestion" })

			-- Accept current suggestion; if none is visible, ask for one
			vim.keymap.set("i", "<C-y>", function()
				if suggestion.is_visible() then
					suggestion.accept()
				else
					-- "VS Code style": pressing <C-y> also requests a suggestion
					suggestion.next()
				end
			end, { desc = "Copilot: accept inline suggestion / trigger" })

			-- Dismiss current suggestion
			vim.keymap.set("i", "<C-]>", function()
				if suggestion.is_visible() then
					suggestion.dismiss()
				end
			end, { desc = "Copilot: dismiss inline suggestion" })

			----------------------------------------------------------------------
			-- NORMAL/INSERT MODE: on-demand trigger & auto_trigger toggle
			----------------------------------------------------------------------

			-- On-demand: ask Copilot for a suggestion at the cursor position
			vim.keymap.set({ "n", "i" }, "<leader>cs", function()
				suggestion.next()
			end, { desc = "Copilot: trigger inline suggestion" })

			-- Toggle auto_trigger (per buffer):
			-- - when off  -> suggestions only when you ask for them
			-- - when on   -> behave more like VS Code (auto ghost text)
			vim.keymap.set({ "n", "i" }, "<leader>cc", function()
				suggestion.toggle_auto_trigger()
				vim.notify("Copilot: toggled auto_trigger for this buffer", vim.log.levels.INFO)
			end, { desc = "Copilot: toggle automatic suggestions" })
		end,
	},
}
