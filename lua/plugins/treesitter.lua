return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({ -- nvim-treesitter-config if branch != master
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"query",
					"bash",
					"markdown",
					"markdown_inline",
					"json",
					"yaml",
					"toml",
					"javascript",
					"typescript",
					"tsx",
					"html",
					"css",
					"scss",
					"regex",
					"dockerfile",
					"gitignore",
					"c",
					"cpp",
					"ninja",
					"rst",
					"vue",
					"python",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true, disable = { "python", "yaml" } },
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
