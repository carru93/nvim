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
				map("n", "<leader>H", vim.lsp.buf.hover, "LSP: Signature help")
				map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")

				-- Disabilita la formattazione via LSP: useremo conform.nvim
				if client.name == "vtsls" or client.name == "ts_ls" or client.name == "eslint" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end
			end

			local vue_language_server_path = nil
			do
				local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
				local candidate = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"

				if (vim.uv or vim.loop).fs_stat(candidate) then
					vue_language_server_path = candidate
				end
			end

			local vtsls_plugins = {}
			if vue_language_server_path then
				table.insert(vtsls_plugins, {
					name = "@vue/typescript-plugin",
					location = vue_language_server_path,
					languages = { "vue" },
					configNamespace = "typescript",
					enableForWorkspaceTypeScriptVersions = true,
				})
			end

			vim.lsp.config("vtsls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
				settings = {
					javascript = {
						format = { enable = false },
						suggestionActions = { enabled = false },
						diagnostics = { ignoredCodes = { 80001, 80006 } },
					},
					typescript = {
						suggestionActions = { enabled = false },
					},
					vtsls = {
						tsserver = {
							globalPlugins = vtsls_plugins,
						},
					},
				},
				root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
			})

			vim.lsp.config("vue_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				init_options = {
					vue = { hybridMode = true },
				},
			})

			vim.lsp.enable({ "vtsls", "vue_ls" })

			-- ESLint LSP: per diagnostics e code actions (non formattazione)
			vim.lsp.config("eslint", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					format = false,
					workingDirectory = { mode = "auto" },
					codeAction = { showDocumentation = { enable = true } },
				},
			})
			vim.lsp.enable("eslint")

			vim.lsp.config("gopls", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.enable("gopls")

			vim.lsp.config(
				"clangd",
				{ cmd = { "clangd", "--background-index" }, capabilities = capabilities, on_attach = on_attach }
			)
			vim.lsp.enable("clangd")

			vim.lsp.config("pyright", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
			})
			vim.lsp.enable("pyright")

			vim.lsp.config("ruff", {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					client.server_capabilities.hoverProvider = false
					on_attach(client, bufnr)
					vim.keymap.set(
						"n",
						"<leader>co",
						vim.lsp.buf.code_action,
						{ buffer = bufnr, desc = "Organize Imports" }
					)
				end,
			})
			vim.lsp.enable("ruff")
		end,
	},

	-- Installer automatico
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"vtsls",
					"eslint-lsp",
					"gopls",
					"clangd",
					"pyright",
					"ruff",
					"vue-language-server",
					"eslint_d",
					"prettierd",
					"stylua",
				},
				run_on_start = true,
			})
		end,
	},
}
