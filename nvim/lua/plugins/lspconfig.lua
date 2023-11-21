return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",             -- for capabilities setting
      "folke/which-key.nvim",             -- for easier key-binding
      "williamboman/mason-lspconfig.nvim" -- for automatic installation
    },
    config = function()
      local lspconfig = require("lspconfig")

      -- The nvim-cmp almost supports LSP's capabilities
      -- so you should advertise it to LSP servers.
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- c/cpp
      lspconfig.clangd.setup {
        cmd = {
          "clangd",
          "--compile-commands-dir=build",
          "--all-scopes-completion",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--function-arg-placeholders=0",
          "--header-insertion=iwyu",
          "-j=4",
          "--pch-storage=memory",
          "--enable-config",
          "--offset-encoding=utf-16",
        },
        capabilities = capabilities,
        on_attach = function()
          vim.keymap.set("n", "<Leader>sw", "<cmd>ClangdSwitchSourceHeader<cr>",
            { desc = "Switch source/header" })
        end
      }
      -- lua with neovim runtime support
      lspconfig.lua_ls.setup({
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
              Lua = {
                runtime = {
                  version = 'LuaJIT'
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                  }
                }
              }
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end,
      })
      -- bash
      lspconfig.bashls.setup {
        filetypes = { "sh", "zsh" },
        capabilities = capabilities,
      }
      lspconfig.pyright.setup { capabilities = capabilities }  -- python
      lspconfig.neocmake.setup { capabilities = capabilities } -- cmake
      lspconfig.jsonls.setup { capabilities = capabilities }   -- json
      lspconfig.yamlls.setup { capabilities = capabilities }   -- yaml
      lspconfig.marksman.setup { capabilities = capabilities } -- markdown

      -- rounded border on :LspInfo
      require("lspconfig.ui.windows").default_options.border = "rounded"

      -- Customization and appearance -----------------------------------------
      -- change gutter diagnostic symbols
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config({
        virtual_text = {
          source = "if_many",
        },
        float = {
          source = "always",
          border = "rounded",
        },
        severity_sort = true,
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })

      -- Show diagnostics under the cursor when holding position
      -- https://neovim.discourse.group/t/how-to-show-diagnostics-on-hover/3830/3
      vim.api.nvim_create_autocmd('CursorHold', {
        group = vim.api.nvim_create_augroup("lsp_diagnostics_hold", {}),
        callback = function(ev)
          -- Function to check if a floating dialog exists and if not
          -- then check for diagnostics under the cursor
          for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
              return
            end
          end
          -- THIS IS FOR BUILTIN LSP
          vim.diagnostic.open_float({
            scope = "cursor",
            focusable = false,
            relative = "cursor",
            close_events = {
              "CursorMoved",
              "CursorMovedI",
              "BufHidden",
              "InsertCharPre",
              "WinLeave",
            },
          })
        end,
      })

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable inline virtual-text hints if available
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(ev.buf, true)
          end

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          require("which-key").register({
            K = { vim.lsp.buf.hover, "Hover" },
            ["<C-k>"] = { vim.lsp.buf.signature_help, "Signature help" },
            ["<leader>rn"] = { vim.lsp.buf.rename, "Rename symbol" },
            g = {
              d = { vim.lsp.buf.definition, "Goto definition" },
              D = { vim.lsp.buf.declaration, "Goto declaration" },
              i = { vim.lsp.buf.implementation, "Goto implementation" },
              r = { vim.lsp.buf.references, "Goto references" },
            },
          }, {
            buffer = ev.buf,
          })
        end,
      })
    end,
    init = function()
      -- https://github.com/neovim/neovim/issues/23725
      local ok, wf = pcall(require, "vim.lsp._watchfiles")
      if ok then
        -- disable lsp watcher. Too slow on linux
        wf._watchfunc = function()
          return function() end
        end
      end
    end,
  },

  -- 函数签名提示
  -- NOTE: 目前由 Noice 提供
  {
    enabled = false,
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      hint_prefix = " ",
      hint_inline = function() return vim.fn.has("nvim-0.10") == 1 end,
      transparency = 20,
    },
  },

  -- Code action 预览
  {
    "aznhe21/actions-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("actions-preview").setup {
        telescope = require("telescope.themes").get_cursor({ previewer = false }),
      }
    end,
    keys = {
      {
        mode = { "n", "v" },
        "<Leader>ac",
        "<cmd>lua require('actions-preview').code_actions()<cr>",
        desc = "Code action preview",
      },
    },
  },
}
