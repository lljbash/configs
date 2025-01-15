return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "folke/which-key.nvim" },
    config = function()
      local dap = require("dap")
      local wk = require("which-key")

      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e31403" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#4b4b18" })
      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "DapBreakpoint",
      })
      vim.fn.sign_define(
        "DapLogPoint",
        { text = "", texthl = "DapLogPoint", linehl = "", numhl = "DapLogPoint" }
      )
      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "DapStopped",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "DapBreakpoint",
      })

      wk.add({
        { "<Leader>d", group = "Debug" },
        { "<Leader>db", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
        {
          "<Leader>dr",
          function()
            if dap.session() then
              dap.restart()
            else
              dap.continue()
            end
          end,
          desc = "Start session",
        },
        { "<Leader>ds", dap.step_into, desc = "Step into" },
        { "<Leader>dn", dap.step_over, desc = "Step over" },
        { "<Leader>do", dap.step_out, desc = "Step out" },
        { "<Leader>dc", dap.continue, desc = "Continue" },
        {
          "<Leader>dq",
          function()
            if dap.session() then
              dap.disconnect()
              dap.close()
            end
          end,
          desc = "Quit session",
        },
      })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
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
    config = function()
      require("dap-python").setup("uv")
      local configs = require("dap").configurations.python
      -- these configs are copied from nvim-dap-python, but with justMyCode = false
      local new_configs = vim.deepcopy(configs)
      for _, new_conf in ipairs(new_configs) do
        new_conf.name = new_conf.name.." (justMyCode = false)"
        new_conf.justMyCode = false
        table.insert(configs, new_conf)
      end
    end,
  },
}
