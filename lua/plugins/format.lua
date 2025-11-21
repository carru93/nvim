return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = {
			lsp_fallback = false, -- non usare lsp formatting; vogliamo SOLO i formatter esterni
			timeout_ms = 2000,
		},
		-- Catene per filetype
		formatters_by_ft = {
			javascript = { "eslint_d", "prettierd" },
			javascriptreact = { "eslint_d", "prettierd" },
			typescript = { "eslint_d", "prettierd" },
			typescriptreact = { "eslint_d", "prettierd" },
			html = { "prettierd" },
			["html.handlebars"] = { "prettierd", "prettier_glimmer" },
			handlebars = { "prettierd", "prettier_glimmer" }, -- ← .hbs qui
			json = { "prettierd" },
			jsonc = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			lua = { "stylua" },
		},
	},
}
