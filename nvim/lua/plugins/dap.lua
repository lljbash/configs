return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "folke/which-key.nvim" },
    config = function()
      local dap = require("dap")
      local wk = require("which-key")

      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e31403' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' })
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#4b4b18' })
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition', {
        text = '',
        texthl = 'DapBreakpoint',
        linehl = '',
        numhl =
        'DapBreakpoint'
      })
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = '', numhl = 'DapLogPoint' })
      vim.fn.sign_define('DapStopped', {
        text = '',
        texthl = 'DapStopped',
        linehl = 'DapStoppedLine',
        numhl =
        'DapStopped'
      })
      vim.fn.sign_define('DapBreakpointRejected', {
        text = '',
        texthl = 'DapBreakpoint',
        linehl = '',
        numhl =
        'DapBreakpoint'
      })

      wk.register({
        ["<Leader>d"] = {
          name = "Debug",
          b = { dap.toggle_breakpoint, "Toggle breakpoint" },
          r = { function()
            if dap.session() then
              dap.restart()
            else
              dap.continue()
            end
          end, "Start session" },
          s = { dap.step_into, "Step into" },
          n = { dap.step_over, "Step over" },
          o = { dap.step_out, "Step out" },
          c = { dap.continue, "Continue" },
          q = { function()
            if dap.session() then
              dap.disconnect()
              dap.close()
            end
          end, "Quit session" },
        },
      })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    main = "dapui",
    opts = {},
    keys = {
      { "<Leader>dd", "<cmd>lua require'dapui'.toggle()<cr>", desc = "Toggle DAP UI" },
    },
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    build =
    ":! [ \\! -d ~/.virtualenvs/debugpy ] && mkdir ~/.virtualenvs && cd ~/.virtualenvs && python -m venv debugpy && debugpy/bin/python -m pip install debugpy",
    config = function()
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
      local configs = require("dap").configurations.python
      -- these configs are copied from nvim-dap-python, but with justMyCode = false
      table.insert(configs, {
        type = "python",
        request = "launch",
        name = "Launch file (justMyCode = false)",
        program = "${file}",
        justMyCode = false,
      })
      table.insert(configs, {
        type = "python",
        request = "launch",
        name = "Launch file with arguments (justMyCode = false)",
        program = "${file}",
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " +")
        end,
        justMyCode = false,
      })
      table.insert(configs, {
        type = "python",
        request = "attach",
        name = "Attach remote (justMyCode = false)",
        connect = function()
          local host = vim.fn.input("Host [127.0.0.1]: ")
          host = host ~= "" and host or "127.0.0.1"
          local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
          return { host = host, port = port }
        end,
        justMyCode = false,
      })
    end,
  },
}
