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
		format_on_save = function(bufnr)
			-- Disable format on save in HUGO projects
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local path = vim.fn.fnamemodify(bufname, ":p:h")

			local hugo_config = vim.fn.findfile("hugo.toml", path .. ";")
				or vim.fn.findfile("config.toml", path .. ";")
				or vim.fn.findfile("hugo.yaml", path .. ";")
				or vim.fn.findfile("config.yaml", path .. ";")
				or vim.fn.finddir("archetypes", path .. ";")

			if hugo_config ~= "" then
				return nil
			end

			return {
				lsp_fallback = false, -- non usare lsp formatting; vogliamo SOLO i formatter esterni
				timeout_ms = 2000,
			}
		end,
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
			python = { "isort", "ruff_format", "ruff_fix" },
			vue = { "prettierd" },
			css = { "prettierd" },
		},
	},
}
