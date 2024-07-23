-- 光标快速跳转
return {
  {
    "phaazon/hop.nvim",
    event = "VeryLazy",
    dependencies = { "folke/which-key.nvim" }, -- for easier key-binding
    config = function()
      local hop = require("hop")
      local hint = require("hop.hint")
      local wk = require("which-key")
      hop.setup({})
      wk.add({
        -- Sneak-like motions
        {
          { "s", hop.hint_char2, desc = "Hop sneak" },
          { "z", hop.hint_char2, desc = "Hop sneak", mode = { "x", "o" } },
        },
        -- Replace common line motions
        {
          mode = { "n", "x", "o" },
          { "f", function()
            hop.hint_char1({
              direction = hint.HintDirection.AFTER_CURSOR,
              current_line_only = true,
            })
          end, desc = "Hop f" },
          { "F", function()
            hop.hint_char1({
              direction = hint.HintDirection.BEFORE_CURSOR,
              current_line_only = true,
            })
          end, desc = "Hop F" },
          { "t", function()
            hop.hint_char1({
              direction = hint.HintDirection.AFTER_CURSOR,
              current_line_only = true,
              hint_offset = -1,
            })
          end, desc = "Hop t" },
          { "T", function()
            hop.hint_char1({
              direction = hint.HintDirection.BEFORE_CURSOR,
              current_line_only = true,
              hint_offset = -1,
            })
          end, desc = "Hop T" },
        },
        -- Other motions with <Leader><Leader>
        {
          mode = { "n", "x", "o" },
          { "<Leader><Leader>", group = "Hop" },
          { "<Leader><Leader>a", hop.hint_anywhere, desc = "Hop anywhere" },
          { "<Leader><Leader>f", hop.hint_char1, desc = "Hop char1" },
          { "<Leader><Leader>0", hop.hint_lines, desc = "Hop lines" },
          { "<Leader><Leader>_", hop.hint_lines_skip_whitespace, desc = "Hop lines start" },
          { "<Leader><Leader>/", hop.hint_patterns, desc = "Hop patterns" },
          { "<Leader><Leader>w", hop.hint_words, desc = "Hop words" },
          { "<Leader><Leader>j", function()
            hop.hint_vertical({ hint.HintDirection.AFTER_CURSOR })
          end, desc = "Hop vertical down" },
          { "<Leader><Leader>k", function()
            hop.hint_vertical({ hint.HintDirection.BEFORE_CURSOR })
          end, desc = "Hop vertical down" },
        },
      })
    end,
  },
}
