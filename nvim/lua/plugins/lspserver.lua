return {
  -- 使用 Mason 管理 LSP 等工具
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  -- 自动安装 Mason 管理的工具
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- LSP
        "clangd",
        "lua-language-server",
        "bash-language-server",
        "pyright",
        "neocmakelsp",
        "json-lsp",
        "yaml-language-server",
        "marksman",
        "shellcheck",
        "typos-lsp",
        -- Formatter
        "clang-format",
        "stylua",
        "black",
        "isort",
        "cmakelang",
        "shfmt",
        "prettier",
      },
    },
  },
}
