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
        -- "clangd",  -- NOTE: use conda clangd due to GLIBC issue
        "lua-language-server",
        "bash-language-server",
        "pyright",
        "neocmakelsp",
        "json-lsp",
        "yaml-language-server",
        "marksman",
        -- "typos-lsp", -- NOTE: build from source due to GLIBC issue
        -- Formatter
        "clang-format",
        "black",
        "cmakelang",
        "prettier",
      },
    },
  },
}
