return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        mode = "n",
        "<leader>f",
        "<cmd>lua require('conform').format()<CR>",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        cuda = { "clang-format" },
        cmake = { "cmake_format" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        graphql = { "prettier" },
        markdown = { "prettier" },
        vue = { "prettier" },
        astro = { "prettier" },
        yaml = { "prettier" },
        ["_"] = { "trim_whitespace", "trim_newlines" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },
}
