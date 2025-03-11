return {
  -- 基于 LSP/treesitter 的 symbol outline
  {
    "stevearc/aerial.nvim",
    dependencies = { "folke/which-key.nvim" }, -- for easier key-binding
    event = "VeryLazy",
    config = function()
      local aerial = require("aerial")
      aerial.setup({
        backends = { "lsp", "treesitter", "markdown", "man" },
        -- filter_kind = false, -- display all symbols
        filter_kind = {
          "Class",
          "Constructor",
          "Enum",
          "Function",
          "Interface",
          "Module",
          "Method",
          "Namespace",
          "Struct",
        },
        autojump = true,
        nav = {
          win_opts = {
            winhl = "NormalFloat:Normal,FloatBorder:TelescopeBorder",
            cursorline = true,
            winblend = 0,
          },
          autojump = false,
          preview = false,
          keymaps = {
            ["<CR>"] = "actions.jump",
            ["<2-LeftMouse>"] = "actions.jump",
            ["<C-v>"] = "actions.jump_vsplit",
            ["<C-s>"] = "actions.jump_split",
            h = "actions.left",
            l = "actions.right",
            ["<C-c>"] = "actions.close",
            ["<Left>"] = "actions.left",
            ["<Right>"] = "actions.right",
            q = "actions.close",
            ["<ESC>"] = "actions.close",
          },
        },
        lsp = {
          priority = {
            marksman = -1,
          },
        },
      })

      -- hide cursor when entering aerial
      local augroup = vim.api.nvim_create_augroup("aerial", {})
      vim.api.nvim_create_autocmd({ "WinEnter", "WinNew" }, {
        group = augroup,
        callback = function(opts)
          local ft = vim.bo[opts.buf].filetype
          if ft == "aerial" or ft == "aerial-nav" then
            vim.cmd("hi Cursor blend=100")
          end
        end,
      })
      vim.api.nvim_create_autocmd("WinLeave", {
        group = augroup,
        callback = function(opts)
          local ft = vim.bo[opts.buf].filetype
          if ft == "aerial" or ft == "aerial-nav" then
            vim.cmd("hi Cursor blend=0")
          end
        end,
      })

      -- close aerial when closing window (compatible with auto-session)
      vim.api.nvim_create_autocmd("QuitPre", {
        group = augroup,
        callback = function(opts)
          local ft = vim.bo[opts.buf].filetype
          if ft ~= "aerial" or ft ~= "aerial-nav" then
            vim.cmd("AerialClose")
          end
        end,
      })

      -- keybindings
      require("which-key").add({
        { "<Leader>o", aerial.toggle, desc = "Open/focus symbol outline" },
        { "gs", aerial.nav_toggle, desc = "Symbol navigation" },
        { "[s", aerial.prev, desc = "Previous symbol" },
        { "]s", aerial.next, desc = "Next symbol" },
        { "<Space>s", "<cmd>Telescope aerial<cr>", desc = "Symbols" },
      })
    end,
  },
}
