return {
  {
    "gbprod/yanky.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
      "tpope/vim-unimpaired", -- override [p, ]p
    },
    config = function()
      local yanky = require("yanky")
      local history = require("yanky.history")
      yanky.setup {
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
      }
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
      vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
      vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
      vim.keymap.set({ "n", "x" }, "<leader>y", "\"+<Plug>(YankyYank)", { desc = "Yank to system clipboard" })
      vim.keymap.set({ "n", "x" }, "<leader>p", function()
        require("yanky.textobj").last_put()
      end, { desc = "Put last put text" })
      for type, type_text in pairs({
        p = "PutAfter",
        P = "PutBefore",
        gp = "GPutAfter",
        gP = "GPutBefore",
        ["]p"] = "PutIndentAfter",
        ["[p"] = "PutIndentBefore",
      }) do
        for mode, is_visual in pairs({
          n = false,
          x = true,
        }) do
          vim.keymap.set(mode, type, function()
            local reg = history.first()
            vim.fn.setreg('"', reg.regcontents, reg.regtype)
            yanky.put(type, is_visual)
          end, { desc = type_text })
        end
      end

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
