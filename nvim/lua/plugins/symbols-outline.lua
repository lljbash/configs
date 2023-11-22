-- 基于 LSP/treesitter 的 symbol outline
return {
  {
    "stevearc/aerial.nvim",
    keys = {
      {
        mode = { "n" },
        "<Leader>o",
        "<cmd>AerialOpen<cr>",
        desc = "Open/focus symbol outline",
      },
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      filter_kind = false, -- display all symbols
      autojump = true,
    },
  },
}
