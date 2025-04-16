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
      telescope.load_extension("session-lens")

      require("which-key").add({
        { "<Space>", group = "Telescope" },
        { "<Space><Space>", builtin.builtin, desc = "Builtin lists" },
        { "<Space>n", builtin.fd, desc = "Find files" },
        { "<Space>b", builtin.buffers, desc = "Buffers" },
        { "<Space>g", builtin.live_grep, desc = "Live grep" },
        { "<Space>*", builtin.grep_string, desc = "Grep string" },
        { "<Space>o", builtin.oldfiles, desc = "Open recent files" },
        { "<Space>c", builtin.commands, desc = "Commands" },
        { "<Space>C", builtin.command_history, desc = "Command history" },
        { "<Space>j", builtin.jumplist, desc = "Jump list" },
        { "<Space>/", builtin.current_buffer_fuzzy_find, desc = "Current buffer fuzzy find" },
        { "<Space>a", builtin.diagnostics, desc = "Diagnostics" },
        { "<Space>m", function()
            telescope.extensions.file_browser.file_browser {
              path = vim.fn.expand("%:p:h"),
              select_buffer = true,
            }
          end, desc = "File browser" },
        { "<Space>y", function()
            --- not needed since yanky.nvim now uses sqlite as storage
            -- vim.cmd(":rshada")
            telescope.extensions.yank_history.yank_history(
              themes.get_dropdown({})
            )
          end, desc = "Yank history" },
      })
    end,
  },
}
