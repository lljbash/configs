return {
  -- 使用 mason 管理 lsp 服务器
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  -- 自动安装 LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        -- "clangd",  -- NOTE: use conda clangd due to GLIBC problem
        "lua_ls",
        "bashls",
        "pyright",
        "neocmake",
        "jsonls",
        "yamlls",
        "marksman",
      },
    },
  },
  -- 自动安装 Formatter
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "clang-format",
        "black",
        "cmakelang",
        "prettier",
      },
    },
  },
}
