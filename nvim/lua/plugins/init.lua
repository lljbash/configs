--- NOTE: 本文件主要包含开箱即用的插件，配置复杂的插件有独立脚本
return {
  -- 一些好用的默认配置
  "tpope/vim-sensible",

  -- readline keybindings in insert mode and command line
  "tpope/vim-rsi",

  -- 打标签：mx  跳转：'x  最后一次更改：'.  来回跳：''
  "kshenoy/vim-signature",

  -- 高亮光标所在位置对应的符号
  "RRethy/vim-illuminate",

  -- transparent pasting,
  "ConradIrwin/vim-bracketed-paste",

  -- Vim sugar for the UNIX shell commands that need it the most
  -- :Remove :Delete :Move :Chmod :Mkdir ...
  "tpope/vim-eunuch",

  -- 快捷编辑环绕 cs/ds/ys/...
  { "kylechui/nvim-surround", opts = {} },

  -- 注释插件 gcc/gbc/gco/gcO/gciw/...
  { "numToStr/Comment.nvim", opts = {} },

  -- 支持鼠标点击的 statuscolumn
  { "luukvbaal/statuscol.nvim", opts = {}, branch = "0.10" },

  -- 项目特殊配置
  {
    "embear/vim-localvimrc",
    lazy = false,
    init = function()
      vim.cmd([[
        let g:localvimrc_persistent = 1
      ]])
    end
  },

  -- <CR> 快捷选择范围
  {
    "sustech-data/wildfire.nvim",
    keys = {"<CR>"},
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },

  -- 多光标
  {
    "smoka7/multicursors.nvim",
    dependencies = { "smoka7/hydra.nvim" },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>m",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },
}
