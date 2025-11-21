return {
	-- Gestione binari
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			local lspconfig = require("lspconfig")

			-- Capabilities (compatibile con nvim-cmp se lo aggiungerai)
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_cmp, cmp_caps = pcall(require, "cmp_nvim_lsp")
			if ok_cmp then
				capabilities = cmp_caps.default_capabilities(capabilities)
			end

			-- Attacchi comuni (keymap base e disabilitare formatting per evitare conflitti)
			local on_attach = function(client, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- LSP base mappings (aggiungine a piacere)
				map("n", "gd", vim.lsp.buf.definition, "LSP: Go to Definition")
				map("n", "gr", vim.lsp.buf.references, "LSP: References")
				map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
				map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")

				-- Disabilita la formattazione via LSP: useremo conform.nvim
				if client.name == "vtsls" or client.name == "tsserver" or client.name == "eslint" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end
			end

			-- vtsls (JS/TS) - alternativa moderna a tsserver
			lspconfig.vtsls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				-- settings opzionali:
				settings = {
					-- Tipiche preferenze TS/JS (metti le tue se vuoi)
					javascript = {
						format = { enable = false },
						suggestionActions = { enabled = false },
						diagnostics = { ignoredCodes = { 80001, 80006 } },
					},
					typescript = {
						suggestionActions = { enabled = false },
					},
				},
				-- Evita di attivarlo in progetti Deno
				root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
			})

			-- ESLint LSP: per diagnostics e code actions (non formattazione)
			lspconfig.eslint.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					workingDirectory = { mode = "auto" },
					codeAction = { showDocumentation = { enable = true } },
				},
			})

			-- Go
			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- C/C++
			lspconfig.clangd.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,
	},

	-- Installer automatico per i binari esterni
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSP
					"vtsls",
					"eslint-lsp",
					"gopls",
					"clangd",
					-- Formatter & tools
					"eslint_d",
					"prettierd",
					"stylua",
					"clang-format",
					"goimports",
					"gofumpt",
				},
				run_on_start = true,
			})
		end,
	},
}
