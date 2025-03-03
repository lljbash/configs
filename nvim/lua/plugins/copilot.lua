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
    event = "VeryLazy",
    dependencies = {
      "zbirenbaum/copilot.lua",
      { "nvim-lua/plenary.nvim", branch = "master" },
      "folke/which-key.nvim",
    },
    build = "make tiktoken",
    config = function()
      local cc = require("CopilotChat")
      local ccp = require("CopilotChat.config.prompts")
      for key, value in pairs(ccp) do
        if type(value) == "string" then
          ccp[key] = value .. "\nSpeak Chinese by default."
        end
      end
      cc.setup({
        system_prompt = ccp.COPILOT_INSTRUCTIONS.system_prompt,
        window = {
          width = 0.45,
        },
      })
      local wk = require("which-key")
      wk.add({
        mode = { "n", "v" },
        { "<leader>c", group = "CopilotChat" },
        {
          "<leader>cc",
          cc.toggle,
          desc = "Toggle",
        },
        {
          "<leader>cq",
          function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
              cc.ask(input, { selection = require("CopilotChat.select").buffer })
            end
          end,
          desc = "Quick chat",
        },
        {
          "<leader>cp",
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
          end,
          desc = "Prompt actions",
        },
      })
    end,
  },
}
