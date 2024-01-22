--- 使用 which-key 维护所有按键映射
return {
  {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local wk = require("which-key")
      wk.setup {}
      wk.register({
        ["<Leader>"] = {
          w = { "<cmd>w<cr>", "Save buffer" },
          W = { "<cmd>wa<cr>", "Save all" },
          Q = { "<cmd>q!<cr>", "Force quit" },
          ["."] = {
            name = "cwd",
            ["<cr>"] = { "<cmd>lcd %:p:h<cr><cmd>pwd<cr>", "Set cwd to buffer" },
            ["."] = { "<cmd>lcd ..<cr><cmd>pwd<cr>", "cd .." },
          }
        },
      })
    end,
  },
  {
    "afreakk/unimpaired-which-key.nvim",
    dependencies = {
      "tpope/vim-unimpaired",
      "folke/which-key.nvim",
    },
    config = function()
      local wk = require("which-key")
      local uwk = require("unimpaired-which-key")
      wk.register(uwk.normal_mode)
      wk.register(uwk.normal_and_visual_mode, { mode = { "n", "v" } })
    end,
  },
}
