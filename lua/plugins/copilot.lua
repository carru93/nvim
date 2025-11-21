return {
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = false,
			},
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_next = "<C-n>",
					jump_prev = "<C-p>",
					accept = "<C-y>",
					refresh = "gr",
				},
				layout = { position = "bottom", ratio = 0.35 },
			},
			filetypes = { ["*"] = true },
		},
		config = function(_, opts)
			require("copilot").setup(opts)

			-- Apri pannello con la lista proposte quando vuoi
			vim.keymap.set("n", "<leader>cc", function()
				require("copilot.panel").open({})
			end, { desc = "Copilot: open panel" })

			-- Chiudi pannello con Esc
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "copilot", -- buffer del pannello
				callback = function(ev)
					local o = { buffer = ev.buf, silent = true, noremap = true }
					vim.keymap.set({ "n", "i" }, "<Esc>", "<Cmd>close<CR>", o)
				end,
			})

			-- Mostra suggerimento inline
			vim.keymap.set({ "n", "i" }, "<leader>cs", function()
				require("copilot.suggestion").next()
			end, { desc = "Copilot: show suggestion" })
		end,
	},
}
