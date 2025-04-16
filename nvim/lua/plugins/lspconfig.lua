return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "saghen/blink.cmp", -- for capabilities setting
      "folke/which-key.nvim", -- for easier key-binding
      "williamboman/mason-tool-installer.nvim", -- for automatic installation
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      vim.lsp.enable("clangd")
      vim.lsp.enable("basedpyright")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("typos_lsp")
      vim.lsp.enable("bashls")
      vim.lsp.enable("neocmake")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("yamlls")
      vim.lsp.enable("marksman")

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("clangd", {
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
        root_markers = {
          "build/compile_commands.json",
          "compile_commands.json",
          ".clangd",
          ".clang-tidy",
          ".clang-format",
          "compile_flags.txt",
          "configure.ac",
        },
      })

      vim.lsp.config("basedpyright", {
        on_init = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "strict",
            },
          },
        },
      })

      -- lua with neovim runtime support
      vim.lsp.config("lua_ls", {
        on_init = function(client)
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              },
            },
          })
        end,
        settings = { Lua = {} },
      })

      vim.lsp.config("typos_lsp", { init_options = { diagnosticSeverity = "Hint" } })

      vim.lsp.config("bashls", { filetypes = { "bash", "sh", "zsh" } })

      -- Customization and appearance -----------------------------------------
      vim.diagnostic.config({
        virtual_text = {
          source = "if_many",
        },
        float = {
          source = true,
          border = "rounded",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          },
        },
        severity_sort = true,
      })

      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, { desc = "Prev diagnostic" })
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, { desc = "Next diagnostic" })

      -- Show diagnostics under the cursor when holding position
      -- https://neovim.discourse.group/t/how-to-show-diagnostics-on-hover/3830/3
      vim.api.nvim_create_autocmd("CursorHold", {
        group = vim.api.nvim_create_augroup("lsp_diagnostics_hold", {}),
        callback = function(_)
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

      -- remove annoying gr* default mappings since nvim-0.11.0
      -- https://neovim.io/doc/user/lsp.html#lsp-defaults
      vim.keymap.del("n", "grn")
      vim.keymap.del("n", "gra")
      vim.keymap.del("n", "grr")
      vim.keymap.del("n", "gri")
      vim.keymap.del("n", "gO")
      vim.keymap.del("i", "<C-S>")

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end

          -- Enable inline virtual-text hints if available
          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local function rounded(fn)
            return function()
              fn({ border = "rounded" })
            end
          end
          -- https://github.com/gbrlsnchs/telescope-lsp-handlers.nvim/issues/10
          local telb = require("telescope.builtin")
          require("which-key").add({
            buffer = ev.buf,
            { "K", rounded(vim.lsp.buf.hover), desc = "Hover" },
            { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature help" },
            { "<leader>r", vim.lsp.buf.rename, desc = "Rename symbol" },
            { "gd", telb.lsp_definitions, desc = "Goto definition" },
            -- { "gD", vim.lsp.buf.declaration, desc = "Goto declaration" },
            { "gi", telb.lsp_implementations, desc = "Goto implementation" },
            { "gr", telb.lsp_references, desc = "Goto references" },
            { "go", telb.lsp_outgoing_calls, desc = "Outgoing calls" },
            { "gh", telb.lsp_incoming_calls, desc = "Incoming calls" },
          })
          if client.name == "clangd" then
            vim.keymap.set("n", "<Leader>sw", "<cmd>ClangdSwitchSourceHeader<cr>", {
              buffer = ev.buf,
              desc = "Switch source/header",
            })
          end
        end,
      })
    end,
  },

  -- rust
  {
    "mrcjkb/rustaceanvim",
    filetype = "rust",
  },

  -- 函数签名提示
  -- NOTE: 目前由 Noice 提供
  {
    enabled = false,
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {
      hint_prefix = " ",
      hint_inline = function()
        return vim.fn.has("nvim-0.10") == 1
      end,
      transparency = 20,
    },
  },

  -- Code action 提示
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      sign = { enabled = false },
      virtual_text = {
        enabled = true,
        text = "󱐋",
      },
      autocmd = { enabled = true },
    },
  },

  -- Code action 预览
  {
    "aznhe21/actions-preview.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = function()
      return {
        highlight_command = {
          require("actions-preview.highlight").delta(),
          require("actions-preview.highlight").diff_so_fancy(),
          require("actions-preview.highlight").diff_highlight(),
        },
        telescope = require("telescope.themes").get_dropdown({}),
      }
    end,
    keys = {
      {
        mode = { "n", "v" },
        "<Leader>a",
        function()
          require("actions-preview").code_actions()
        end,
        desc = "Code actions",
      },
    },
  },
}
