-- 超级列表查找器
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "gbprod/yanky.nvim",                        -- for yank history
      "gbrlsnchs/telescope-lsp-handlers.nvim",    -- hijack lsp commands
      "folke/which-key.nvim",                     -- for easier key-binding
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")

      telescope.setup{
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = "which_key",
              ["<esc>"] = actions.close,
              ["<C-u>"] = false,
              ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
            },
          },
        },
        pickers = {
          fd = { theme = "dropdown" },
          buffers = { theme = "dropdown" },
          live_grep = { theme = "dropdown" },
          oldfiles = { theme = "dropdown" },
          commands = { theme = "ivy" },
          command_history = { theme = "ivy" },
          jumplist = { theme = "dropdown" },
          current_buffer_fuzzy_find = { theme = "dropdown" },
          diagnostics = { theme = "dropdown" },
        },
        extensions = {
          lsp_handlers = {
            disable = {
              ['textDocument/codeAction'] = true,
            },
            location = {
              telescope = themes.get_dropdown({}),
              no_results_message = 'No references found',
            },
            symbol = {
              telescope = themes.get_dropdown({}),
              no_results_message = 'No symbols found',
            },
            call_hierarchy = {
              telescope = themes.get_dropdown({}),
              no_results_message = 'No calls found',
            },
          },
        }
      }

      telescope.load_extension("fzf")
      telescope.load_extension("yank_history")
      telescope.load_extension("lsp_handlers")

      require("which-key").register({
        ["<Space>"] = {
          name = "Telescope",
          ["<Space>"] = { builtin.builtin, "Builtin lists" },
          n = { builtin.fd, "Find files" },
          b = { builtin.buffers, "Buffers" },
          g = { builtin.live_grep, "Live grep" },
          o = { builtin.oldfiles, "Open recent files" },
          c = { builtin.commands, "Commands" },
          C = { builtin.command_history, "Command history" },
          j = { builtin.jumplist, "Jump list" },
          ["/"] = { builtin.current_buffer_fuzzy_find, "Current buffer fuzzy find" },
          a = { builtin.diagnostics, "Diagnostics" },
          y = {
            function()
              vim.cmd(":rshada")
              telescope.extensions.yank_history.yank_history(
                themes.get_dropdown({})
              )
            end,
            "Yank history",
          },
        },
      })
    end,
  },
}
