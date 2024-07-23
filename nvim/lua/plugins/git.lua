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
      require("which-key").add({
        -- Navigation
        { "[g", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev hunk" },
        { "]g", "<cmd>Gitsigns next_hunk<CR>", desc = "Next hunk" },
        -- Actions
        { "<Leader>g", group = "git" },
        { "<Leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk", mode = { "n", "v" } },
        { "<Leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk", mode = { "n", "v" } },
        { "<Leader>gS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
        { "<Leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo stage hunk" },
        { "<Leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },
        { "<Leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
        { "<Leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle blame" },
        { "<Leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" },
        { "<Leader>gD", '<cmd>lua require"gitsigns".diffthis("~")<cr>', desc = "Diff head" },
        { "<Leader>gt", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Toggle deleted" },
        -- Motions
        { "ih", ":<C-U>Gitsigns select_hunk<cr>", desc = "Select hunk", mode = { "o", "x" } },
      })
    end,
  },
  -- :DiffviewOpen/Close/...
  {
    "sindrets/diffview.nvim",
    dependencies = { "folke/which-key.nvim" }, -- for easier key-binding
    event = "VeryLazy",
    config = function()
      require("which-key").add({
        { "<Leader>gv", group = "diffview" },
        { "<Leader>gvv", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
        { "<Leader>gvc", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
        { "<Leader>gvt", "<cmd>DiffviewToggleFiles<cr>", desc = "DiffviewToggleFiles" },
        { "<Leader>gvr", "<cmd>DiffviewRefresh<cr>", desc = "DiffviewRefresh" },
        { "<Leader>gvf", "<cmd>DiffviewFocusFiles<cr>", desc = "DiffviewFocusFiles" },
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
