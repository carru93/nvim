return {
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- super fuzzy
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"folke/trouble.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			local conf = require("telescope.config").values
			local finders = require("telescope.finders")
			local make_entry = require("telescope.make_entry")
			local pickers = require("telescope.pickers")
			local sorters = require("telescope.sorters")
			local trouble = require("trouble.sources.telescope")

			local function glob_escape(text)
				return (text:gsub("([%*%?%[%]%{%}!\\])", "\\%1"))
			end

			local function split_prompt_and_path_filter(prompt)
				local separator = " -- "
				local index = prompt:find(separator, 1, true)
				if not index then
					return prompt, nil
				end

				local search = vim.trim(prompt:sub(1, index - 1))
				local path_filter = vim.trim(prompt:sub(index + #separator))
				return search, path_filter ~= "" and path_filter or nil
			end

			local function path_contains_globs(filter)
				local escaped = glob_escape(vim.trim(filter))
				if escaped == "" then
					return nil
				end

				return {
					"**/*" .. escaped .. "*",
					"**/*" .. escaped .. "*/**",
				}
			end

			local function live_grep_with_path_filter()
				pickers
					.new({}, {
						prompt_title = "Live Grep",
						finder = finders.new_job(function(prompt)
							if not prompt or prompt == "" then
								return nil
							end

							local search_prompt, path_filter = split_prompt_and_path_filter(prompt)
							search_prompt = vim.trim(search_prompt)

							if search_prompt == "" then
								return nil
							end

							local args = vim.deepcopy(conf.vimgrep_arguments)
							if path_filter then
								for _, glob in ipairs(path_contains_globs(path_filter)) do
									args[#args + 1] = "--iglob=" .. glob
								end
							end

							return vim.list_extend(args, { "--", search_prompt })
						end, make_entry.gen_from_vimgrep({}), nil, nil),
						previewer = conf.grep_previewer({}),
						sorter = sorters.highlighter_only({}),
						attach_mappings = function(_, map)
							map("i", "<C-space>", actions.to_fuzzy_refine)
							return true
						end,
					})
					:find()
			end

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-h>"] = "which_key",
							["<C-t>"] = trouble.open,
						},
						n = {
							["<C-t>"] = trouble.open,
						},
					},
				},
				pickers = {
					buffers = {
						sort_mru = true,
						ignore_current_buffer = true,
						mappings = {
							i = {
								["<C-d>"] = actions.delete_buffer, -- delete in insert mode
							},
							n = {
								["<C-d>"] = actions.delete_buffer, -- delete anche in normal mode
								["dd"] = actions.delete_buffer, -- mantieni anche 'dd' se ti piace
							},
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", live_grep_with_path_filter, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>st", builtin.git_files, { desc = "[S]earch Gi[t]" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>rr", builtin.lsp_references, { desc = "LSP: references" })
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			focus = true,
			win = { position = "left", size = 0.25 },
			group = true,
		},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
		},
	},
}
