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
            local shortened = segment:sub(1, vim.startswith(segment, '.') and 2 or 1)
            segments[idx] = shortened
            len = len - (#segment - #shortened)
          end
          return table.concat(segments, sep)
        end
      end


      require("lualine").setup {
        options = {
          theme = "sonokai",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch", cond = width_not_less_than(140) },
            { "diff",   cond = width_not_less_than(140) },
            {
              "diagnostics",
              on_click = function() vim.cmd("Telescope diagnostics") end,
            }
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
                require("telescope").extensions.file_browser.file_browser {
                  path = vim.fn.expand("%:p:h"),
                  select_buffer = true,
                }
              end,
            },
            {
              "aerial",
              on_click = function() vim.cmd("Telescope aerial") end,
            }
          },
          lualine_x = {
            { "copilot",    cond = width_not_less_than(160), show_colors = true },
            { "encoding",   cond = width_not_less_than(160) },
            { "fileformat", cond = width_not_less_than(160) },
            "filetype"
          },
          lualine_y = { "progress" },
          lualine_z = { "location" }
        },
      }
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
  -- NOTE: 为简洁起见，用 mini 代替 nvim-notify 接管通知
  {
    "folke/noice.nvim",
    lazy = false,
    priority = 90,
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- {
      --   "rcarriga/nvim-notify",
      --   opts = {
      --     stages = "fade",
      --     timeout = 2000,
      --     top_down = false,
      --   },
      -- },
      "nvim-telescope/telescope.nvim", -- telescope integration
    },
    config = function()
      require("noice").setup {
        cmdline = {
          view = "cmdline",
          format = {
            input = { view = "cmdline_popup" },
          },
        },
        -- notify = { enabled = false },
        notify = { view = "mini" },
        lsp = {
          hover = { enabled = false },
        },
        popupmenu = {
          enabled = false,
        },
        views = {
          mini = {
            timeout = 5000,
          },
        },
      }
      -- telescope integration
      require("telescope").load_extension("noice")
      -- NOTE: 使用 <Space>e 查看历史通知
      vim.keymap.set(
        "n", "<Space>e", "<cmd>Telescope noice theme=dropdown<cr>",
        { desc = "Noice history" }
      )
    end
  },
}
