return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap-python",
	},
	event = "VeryLazy",
	config = function()
		require("venv-selector").setup({
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
			},
		})
	end,
	keys = {
		{ "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
	},
}
