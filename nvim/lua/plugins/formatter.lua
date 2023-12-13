local clangformat = function()
  return {
    exe = "clang-format",
    args = {
      "-style=file",
      "-assume-filename",
      vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
    },
    stdin = true,
    try_node_modules = true,
    cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
  }
end

local prettier = function()
  return {
    exe = "prettier",
    args = {
      "--config-precedence",
      "prefer-file",
      "--stdin-filepath",
      vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
    },
    stdin = true,
    try_node_modules = true,
  }
end

return {
  {
    "mhartington/formatter.nvim",
    cmd = { "Format", "FormatWrite", "FormatLock", "FormatWriteLock" },
    keys = {
      {
        mode = "n",
        "<leader>f",
        "<cmd>FormatLock<cr>",
        desc = "Format buffer",
      },
      {
        mode = "n",
        "<leader>F",
        "<cmd>FormatWriteLock<cr>",
        desc = "Format and write",
      },
    },
    opts = {
      filetype = {
        c = { clangformat },
        cpp = { clangformat },
        cuda = { clangformat },
        python = {
          function()
            return {
              exe = "black",
              args = {},
              stdin = false,
            }
          end,
        },
        cmake = {
          function()
            return {
              exe = "cmake-format",
              args = { "--in-place" },
              stdin = false,
            }
          end,
        },
        lua = {
          function()
            vim.lsp.buf.format()
          end,
        },
        typescriptreact = { prettier },
        javascriptreact = { prettier },
        javascript = { prettier },
        typescript = { prettier },
        json = { prettier },
        jsonc = { prettier },
        html = { prettier },
        css = { prettier },
        scss = { prettier },
        graphql = { prettier },
        markdown = { prettier },
        vue = { prettier },
        astro = { prettier },
        yaml = { prettier },
      },
    },
  },
}
