return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "LiadOz/nvim-dap-repl-highlights", opts = {} }
    },
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash",
        "doxygen",
        "markdown_inline",
        "regex",
        "dap_repl", -- from nvim-dap-repl-highlights
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        disable = {
          "cmake",
          "git_rebase",
          "gitcommit",
        },
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
    init = function()
      -- Use treesitter to fold code
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldlevel = 99 -- Open all folds by default
    end
  },

  -- Debug treesitter
  {
    "nvim-treesitter/playground",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- Virtual text context for neovim treesitter
  {
    "andersevenrud/nvim_context_vt",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      prefix = "",
      highlight = "LspInlayHint",
      min_rows_ft = {
        python = 50,
      }
    },
  }
}
