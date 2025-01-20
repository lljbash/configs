return {
  {
    "gbprod/yanky.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
      "tpope/vim-unimpaired", -- override [p, ]p
    },
    config = function()
      local yanky = require("yanky")
      yanky.setup({
        ring = {
          storage = "sqlite",
          storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db",
        },
        system_clipboard = {
          sync_with_ring = false,
        },
        textobj = {
          enabled = true,
        },
        preserve_cursor_position = {
          enabled = false,
        },
      })
      vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
      vim.keymap.set(
        { "n", "x" },
        "<leader>y",
        '"+<Plug>(YankyYank)',
        { desc = "Yank to system clipboard" }
      )
      vim.keymap.set({ "o", "x" }, "iP", function()
        require("yanky.textobj").last_put()
      end, { desc = "Last put text" })

      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

      vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

      vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
      vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
      vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
      vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

      vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
      vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
      vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
      vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

      vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
      vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")

      --- only for shada storage
      -- vim.keymap.set({ "n", "x" }, "p", "<cmd>rshada<cr><Plug>(YankyPutAfter)")
      -- vim.keymap.set({ "n", "x" }, "P", "<cmd>rshada<cr><Plug>(YankyPutBefore)")
      -- vim.keymap.set({ "n", "x" }, "gp", "<cmd>rshada<cr><Plug>(YankyGPutAfter)")
      -- vim.keymap.set({ "n", "x" }, "gP", "<cmd>rshada<cr><Plug>(YankyGPutBefore)")
      -- vim.api.nvim_create_autocmd("TextYankPost", {
      --   group = vim.api.nvim_create_augroup("sync_after_yank", {}),
      --   callback = function(ev)
      --     vim.cmd("silent! wshada")
      --   end,
      -- })
    end,
  },
}
