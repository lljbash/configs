return {
  {
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
}
