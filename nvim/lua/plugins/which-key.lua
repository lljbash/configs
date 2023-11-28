--- 使用 which-key 维护所有按键映射
return {
  {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local wk = require("which-key")
      wk.setup{}
      wk.register({
        ["<Leader>"] = {
          w = { "<cmd>w<cr>", "Save buffer" },
          W = { "<cmd>wa<cr>", "Save all" },
          q = { "<cmd>bw<cr>", "Wipe buffer" },
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
}