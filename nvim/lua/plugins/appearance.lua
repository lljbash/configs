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
    },
    opts = {
      options = {
        theme = "sonokai",
      },
    },
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
