return {
  {
    -- Plugin for GitHub Copilot integration
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-J>",
          accept_word = "<C-H>",
          accept_line = "<C-L>",
        },
      },
      filetypes = {
        ["*"] = true,
      },
    },
  },

  {
    -- Plugin for Copilot Chat integration
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",
      { "nvim-lua/plenary.nvim", branch = "master" },
      "folke/which-key.nvim",
    },
    build = "make tiktoken",
    config = function()
      local cc = require("CopilotChat")
      cc.setup {}
      local wk = require("which-key")
      wk.add({
        mode = { "n", "v" },
        { "<leader>c", group = "CopilotChat" },
        {
          "<leader>cc",
          cc.toggle,
          desc = "Toggle"
        },
        {
          "<leader>cq",
          function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
              cc.ask(input, { selection = require("CopilotChat.select").buffer })
            end
          end,
          desc = "Quick chat"
        },
        {
          "<leader>cp",
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
          end,
          desc = "Prompt actions"
        },
      })
    end,
  },
}
