return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    -- textobjects (semantic movements):
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- Auto-close/rename tag in HTML/TSX:
    "windwp/nvim-ts-autotag",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "vim", "vimdoc", "query",
        "bash", "markdown", "markdown_inline",
        "json", "yaml", "toml",
        "javascript", "typescript", "tsx",
        "html", "css", "scss",
        "regex", "dockerfile", "gitignore", "c", "cpp"
      },
      auto_install = true,
      sync_install = false,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
        disable = { "python", "yaml" },
      },

      autotag = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
    })
  end,
}

