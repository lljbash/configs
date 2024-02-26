-- 超级列表查找器
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "gbprod/yanky.nvim",                     -- for yank history
      "gbrlsnchs/telescope-lsp-handlers.nvim", -- hijack lsp commands
      "folke/which-key.nvim",                  -- for easier key-binding
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")

      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = "which_key",
              ["<esc>"] = actions.close,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
              ["<RightMouse>"] = actions.close,
              ["<LeftMouse>"] = actions.select_default,
              ["<ScrollWheelDown>"] = actions.move_selection_next,
              ["<ScrollWheelUp>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          fd = {
            theme = "ivy",
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
          buffers = { theme = "ivy", sort_lastused = true, ignore_current_buffer = true },
          live_grep = { theme = "dropdown" },
          grep_string = { theme = "dropdown" },
          oldfiles = { theme = "ivy" },
          commands = { theme = "ivy" },
          command_history = { theme = "ivy" },
          jumplist = { theme = "dropdown" },
          current_buffer_fuzzy_find = { theme = "dropdown" },
          diagnostics = { theme = "dropdown" },
        },
        extensions = {
          ["ui-select"] = {
            themes.get_dropdown {}
          },
          lsp_handlers = {
            disable = {
              ['textDocument/codeAction'] = true,
            },
            location = {
              telescope = themes.get_ivy({}),
              no_results_message = 'No references found',
            },
            symbol = {
              telescope = themes.get_ivy({}),
              no_results_message = 'No symbols found',
            },
            call_hierarchy = {
              telescope = themes.get_ivy({}),
              no_results_message = 'No calls found',
            },
          },
          file_browser = {
            theme = "ivy",
            hidden = { file_browser = true, folder_browser = true },
            respect_gitignore = false,
            hijack_netrw = false,
          },
        }
      }

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("file_browser")
      telescope.load_extension("yank_history")
      telescope.load_extension("lsp_handlers")

      require("which-key").register({
        ["<Space>"] = {
          name = "Telescope",
          ["<Space>"] = { builtin.builtin, "Builtin lists" },
          n = { builtin.fd, "Find files" },
          b = { builtin.buffers, "Buffers" },
          g = { builtin.live_grep, "Live grep" },
          ["*"] = { builtin.grep_string, "Grep string" },
          o = { builtin.oldfiles, "Open recent files" },
          c = { builtin.commands, "Commands" },
          C = { builtin.command_history, "Command history" },
          j = { builtin.jumplist, "Jump list" },
          ["/"] = { builtin.current_buffer_fuzzy_find, "Current buffer fuzzy find" },
          a = { builtin.diagnostics, "Diagnostics" },
          m = {
            function()
              telescope.extensions.file_browser.file_browser {
                path=vim.fn.expand("%:p:h"),
                select_buffer=true,
              }
            end,
            "File browser",
          },
          y = {
            function()
              --- not needed since yanky.nvim now uses sqlite as storage
              -- vim.cmd(":rshada")
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
