--- 自动补全相关

-- snippets
local luasnip_plug = {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}

-- dictionary
local dictionary_plug = {
  "uga-rosa/cmp-dictionary",
  opts = {
    exact = 2,
    first_case_insensitive = true,
  },
  init = function()
    vim.opt.dictionary = vim.fn.stdpath("config") .. "/dict/10k.dict"
  end,
}

return {
  -- 代码自动补全
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "onsails/lspkind.nvim", -- for menu icons
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "rasulomaroff/cmp-bufname",
      "FelipeLema/cmp-async-path",
      { "saadparwaiz1/cmp_luasnip", dependencies = { luasnip_plug } },
      "hrsh7th/cmp-calc",
      "andersevenrud/cmp-tmux",
      dictionary_plug,
      "hrsh7th/cmp-nvim-lua",
      "rcarriga/cmp-dap",
    },
    name = "cmp",
    config = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      cmp.setup({
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
              or require("cmp_dap").is_dap_buffer()
        end,
        sources = {
          { name = "nvim_lsp" },
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            },
          },
          { name = "bufname" },
          { name = "async_path" },
          { name = "luasnip" },
          { name = "calc" },
          { name = "tmux" },
          { name = "dictionary", keyword_length = 2 },
          { name = "nvim_lua" },
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 60,
            ellipsis_char = "...",
            menu = ({
              nvim_lsp = "",
              nvim_lsp_signature_help = "",
              buffer = "󰦨",
              bufname = "",
              calc = "",
              tmux = "",
              dictionary = "󰓆",
              nvim_lua = "",
            })
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- that way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),
        }),
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
  },

  -- 命令自动补全
  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", opts = {} },
    },
    build = function()
      vim.cmd("UpdateRemotePlugins")
    end,
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })
      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.python_file_finder_pipeline({
            file_command = function(ctx, arg)
              if string.find(arg, ".") ~= nil then
                return { "fd", "-tf", "-H" }
              else
                return { "fd", "-tf" }
              end
            end,
            dir_command = { "fd", "-td" },
          }),
          {
            wilder.check(function(ctx, x) return x == "" end),
            wilder.history()
          },
          { -- 条件开启历史记录匹配
            wilder.check(function(ctx, x) return x:find("%s", 1, true) == 1 end),
            wilder.subpipeline(function(ctx, x)
              return {
                wilder.history(),
                function(ctx, h) return wilder.python_fuzzy_filt(ctx, {}, h, x) end,
              }
            end)
          },
          wilder.cmdline_pipeline({
            -- sets the language to use, "vim" and "python" are supported
            language = "python",
            -- 0 turns off fuzzy matching
            -- 1 turns on fuzzy matching
            -- 2 partial fuzzy matching (match does not have to begin with the same first letter)
            fuzzy = 1,
          }),
          wilder.python_search_pipeline({
            -- can be set to wilder#python_fuzzy_delimiter_pattern() for stricter fuzzy matching
            pattern = wilder.python_fuzzy_delimiter_pattern(),
            -- omit to get results in the order they appear in the buffer
            sorter = wilder.python_difflib_sorter(),
            -- can be set to "re2" for performance, requires pyre2 to be installed
            -- see :h wilder#python_search() for more details
            engine = "re",
          })
        ),
      })
      wilder.set_option("renderer", wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          highlights = {
            border = "Normal", -- highlight to use for the border
          },
          -- "single", "double", "rounded" or "solid"
          -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
          border = "rounded",
          pumblend = 20, -- transparency of the popupmenu
          highlighter = wilder.basic_highlighter(),
          left = { " ", wilder.popupmenu_devicons() },
          right = { " ", wilder.popupmenu_scrollbar() },
        })
      ))
    end,
  },
}
