return {
  -- 基础 git 操作，修改标记
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    dependencies = { "folke/which-key.nvim" }, -- for easier key-binding
    config = function()
      require("gitsigns").setup({
        signs = {
          untracked = { text = '┃' },
        },
        preview_config = {
          border = "rounded",
        },
      })
      vim.api.nvim_set_hl(0, "GitSignsUntracked", { link = "LspInlayHint" })
      require("which-key").register({
        -- Navigation
        ["[g"] = { "<cmd>Gitsigns prev_hunk<CR>", "Prev hunk" },
        ["]g"] = { "<cmd>Gitsigns next_hunk<CR>", "Next hunk" },
        -- Actions
        ["<Leader>g"] = {
          name = "git",
          s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk", mode = { "n", "v" } },
          r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk", mode = { "n", "v" } },
          S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage buffer" },
          u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo stage hunk" },
          R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset buffer" },
          p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview hunk" },
          b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle blame" },
          d = { "<cmd>Gitsigns diffthis<cr>", "Diff this" },
          D = { '<cmd>lua require"gitsigns".diffthis("~")<cr>', "Diff head" },
          ["td"] = { "<cmd>Gitsigns toggle_deleted<cr>", "Toggle deleted" },
        },
        -- Motions
        ["ih"] = { ":<C-U>Gitsigns select_hunk<cr>", "Select hunk", mode = { "x", "o" } },
      })
    end,
  },
  -- Github 操作
  {
    enabled = false,
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-web-devicons",
      "folke/which-key.nvim", -- for easier key-binding
    },
    opts = {},
    cmd = { "Octo" },
  },
}
