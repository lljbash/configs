--- 外观美化插件
return {
  -- 主题配色
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 100,
    config = function()
      vim.cmd([[
        let g:sonokai_style = "shusia"
        let g:sonokai_disable_italic_comment = 0
        let g:sonokai_enable_italic = 1
        colorscheme sonokai
      ]])
    end,
  },

  -- tab bar
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
      "folke/which-key.nvim", -- for convenient keymap
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    config = function()
      require("barbar").setup({})
      require("which-key").add({
        { "<A-,>", "<cmd>BufferPrevious<cr>", desc = "Previous buffer" },
        { "<A-.>", "<cmd>BufferNext<cr>", desc = "Next buffer" },
        { "<A-0>", "<cmd>BufferLast<cr>", desc = "Goto last buffer" },
        { "<A-1>", "<cmd>BufferGoto 1<cr>", desc = "Goto buffer 1" },
        { "<A-2>", "<cmd>BufferGoto 2<cr>", desc = "Goto buffer 2" },
        { "<A-3>", "<cmd>BufferGoto 3<cr>", desc = "Goto buffer 3" },
        { "<A-4>", "<cmd>BufferGoto 4<cr>", desc = "Goto buffer 4" },
        { "<A-5>", "<cmd>BufferGoto 5<cr>", desc = "Goto buffer 5" },
        { "<A-6>", "<cmd>BufferGoto 6<cr>", desc = "Goto buffer 6" },
        { "<A-7>", "<cmd>BufferGoto 7<cr>", desc = "Goto buffer 7" },
        { "<A-8>", "<cmd>BufferGoto 8<cr>", desc = "Goto buffer 8" },
        { "<A-9>", "<cmd>BufferGoto 9<cr>", desc = "Goto buffer 9" },
        { "<A-<>", "<cmd>BufferMovePrevious<cr>", desc = "Move buffer left" },
        { "<A->>", "<cmd>BufferMoveNext<cr>", desc = "Move buffer right" },
        { "<A-b>", group = "Sort tabbar" },
        { "<A-b>b", "<cmd>BufferOrderByBufferNumber<cr>", desc = "By buffer number" },
        { "<A-b>d", "<cmd>BufferOrderByDirectory<cr>", desc = "By directory" },
        { "<A-b>l", "<cmd>BufferOrderByLanguage<cr>", desc = "By language" },
        { "<A-b>n", "<cmd>BufferOrderByName<cr>", desc = "By name" },
        { "<A-b>w", "<cmd>BufferOrderByWindowNumber<cr>", desc = "By window number" },
        { "<A-n>", "<cmd>BufferPin<cr>", desc = "Pin buffer" },
        { "<A-q>", "<cmd>BufferWipeout<cr>", desc = "Wipeout buffer" },
        { "<A-t>", "<cmd>BufferRestore<cr>", desc = "Restore buffer" },
        { "<A-w>", "<cmd>BufferClose<cr>", desc = "Close buffer" },
        { "<Leader>b", "<cmd>BufferPick<cr>", desc = "Pick buffer" },
      })
    end,
    version = "^1.0.0", -- optional: only update when a new 1.x version is released
  },

  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 99,
    dependencies = {
      { "nvim-tree/nvim-web-devicons", opts = {} },
      "sainnhe/sonokai",
      "stevearc/aerial.nvim",
      "AndreM222/copilot-lualine",
      "folke/noice.nvim",
    },
    config = function()
      --- @param min_width number
      local function width_not_less_than(min_width)
        return function()
          return vim.fn.winwidth(0) >= min_width
        end
      end

      ---shortens path by turning apple/orange -> a/orange
      ---@param max_len integer maximum length of the full filename string
      local function shorten_path(max_len)
        local sep = package.config:sub(1, 1)
        return function(path)
          local len = #path
          if len <= max_len then
            return path
          end
          local segments = vim.split(path, sep)
          for idx = 1, #segments - 1 do
            if len <= max_len then
              break
            end
            local segment = segments[idx]
            local shortened = segment:sub(1, vim.startswith(segment, ".") and 2 or 1)
            segments[idx] = shortened
            len = len - (#segment - #shortened)
          end
          return table.concat(segments, sep)
        end
      end

      require("lualine").setup({
        options = {
          theme = "sonokai",
        },
        sections = {
          lualine_a = {
            "mode",
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              end -- not recording
              return "@" .. reg
            end,
          },
          lualine_b = {
            { "branch", cond = width_not_less_than(140) },
            { "diff", cond = width_not_less_than(140) },
            {
              "diagnostics",
              on_click = function()
                vim.cmd("Telescope diagnostics")
              end,
            },
          },
          lualine_c = {
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              "filename",
              newfile_status = true,
              path = 1,
              separator = "%#lualine_c_aerial_LLNonText_normal#⟩%#lualine_c_normal#",
              fmt = shorten_path(40),
              on_click = function()
                require("telescope").extensions.file_browser.file_browser({
                  path = vim.fn.expand("%:p:h"),
                  select_buffer = true,
                })
              end,
            },
            {
              "aerial",
              on_click = function()
                vim.cmd("Telescope aerial")
              end,
            },
          },
          lualine_x = {
            { "copilot", cond = width_not_less_than(160), show_colors = true },
            { "encoding", cond = width_not_less_than(160) },
            { "fileformat", cond = width_not_less_than(160) },
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- 缩进提示
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "▍",
      },
      scope = {
        show_start = false,
        show_end = false,
      },
    },
    init = function()
      vim.opt.list = true
      vim.opt.listchars:append({ trail = "·" })
    end,
  },

  -- UI replacement for messages, cmdline and popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    priority = 90,
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          stages = "fade",
          timeout = 5000,
        },
      },
      "nvim-telescope/telescope.nvim", -- telescope integration
    },
    config = function()
      require("noice").setup({
        cmdline = {
          view = "cmdline",
          format = {
            input = { view = "cmdline_popup" },
          },
        },
        messages = {
          view = "mini",
        },
        popupmenu = { enabled = false },
        commands = {
          history = {
            filter = {
              any = {
                { event = "notify" },
                { error = true },
                { warning = true },
                { event = "msg_show" },
                { event = "lsp", kind = "message" },
              },
            },
          },
        },
        lsp = {
          hover = { enabled = false },
          signature = { enabled = false },
        },
        views = { mini = { timeout = 5000 } },
        routes = {
          {
            view = "notify",
            filter = {
              event = "msg_show",
              kind = {
                "shell_out",
                "shell_err",
                "shell_ret",
              },
            },
            opts = { title = "Shell" },
          },
          {
            view = "mini",
            filter = {
              event = "msg_show",
              kind = {
                "bufwrite",
                "undo",
                "verbose",
                "wildlist",
              },
            },
          },
        },
      })
      -- telescope integration
      require("telescope").load_extension("noice")
      -- NOTE: 使用 <Space>e 查看历史通知
      vim.keymap.set(
        "n",
        "<Space>e",
        "<cmd>Telescope noice theme=dropdown<cr>",
        { desc = "Noice history" }
      )
    end,
  },
}
