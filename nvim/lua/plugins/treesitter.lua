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
        "awk",
        "bash",
        "bibtex",
        "c",
        "cmake",
        "commonlisp",
        "cpp",
        "css",
        "csv",
        "cuda",
        "diff",
        "dockerfile",
        "dot",
        "doxygen",
        "fish",
        "fortran",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "html",
        "ini",
        "java",
        "javascript",
        "jq",
        "json",
        "kotlin",
        "latex",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "matlab",
        "objc",
        "objdump",
        "pascal",
        "passwd",
        "perl",
        "php",
        "proto",
        "python",
        "regex",
        "requirements",
        "rst",
        "ruby",
        "rust",
        "scheme",
        "sql",
        "ssh_config",
        "textproto",
        "tsv",
        "vim",
        "vimdoc",
        "query",
        "xml",
        "yaml",
        "dap_repl", -- from nvim-dap-repl-highlights
      },
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = true,
        disable = { "cmake" },
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
}
