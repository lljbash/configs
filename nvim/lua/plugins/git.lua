return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    dependencies = { "folke/which-key.nvim" }, -- for easier key-binding
    config = function()
      require("gitsigns").setup({
        preview_config = {
          border = "rounded",
        },
      })
      require("which-key").register({
        -- Navigation
        ["[c"] = { "<cmd>Gitsigns prev_hunk<CR>", "Prev hunk" },
        ["]c"] = { "<cmd>Gitsigns next_hunk<CR>", "Next hunk" },
        -- Actions
        ["<Leader>g"] = {
          name = "gitsigns",
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
}
