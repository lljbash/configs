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

      -- Sneak-like motions
      wk.register({
        s = { hop.hint_char2, "Hop sneak" },
        z = { hop.hint_char2, "Hop sneak", mode = { "x", "o" } },
      })

      -- Replace common line motions
      wk.register({
        f = { function()
          hop.hint_char1({
            direction = hint.HintDirection.AFTER_CURSOR,
            current_line_only = true,
          })
        end, "Hop f" },
        F = { function()
          hop.hint_char1({
            direction = hint.HintDirection.BEFORE_CURSOR,
            current_line_only = true,
          })
        end, "Hop F" },
        t = { function()
          hop.hint_char1({
            direction = hint.HintDirection.AFTER_CURSOR,
            current_line_only = true,
            hint_offset = -1,
          })
        end, "Hop t" },
        T = { function()
          hop.hint_char1({
            direction = hint.HintDirection.BEFORE_CURSOR,
            current_line_only = true,
            hint_offset = -1,
          })
        end, "Hop T" },
      }, { mode = { "n", "x", "o" } })

      -- Other motions with <Leader><Leader>
      wk.register({
        name = "Hop",
        a = { hop.hint_anywhere, "Hop anywhere" },
        f = { hop.hint_char1, "Hop char1" },
        ["0"] = { hop.hint_lines, "Hop lines" },
        ["_"] = { hop.hint_lines_skip_whitespace, "Hop lines start" },
        ["/"] = { hop.hint_patterns, "Hop patterns" },
        w = { hop.hint_words, "Hop words" },
        j = { function()
          hop.hint_vertical({ hint.HintDirection.AFTER_CURSOR })
        end, "Hop vertical down" },
        k = { function()
          hop.hint_vertical({ hint.HintDirection.BEFORE_CURSOR })
        end, "Hop vertical down" },
      }, { prefix = "<Leader><Leader>", mode = { "n", "x", "o" } })
    end,
  },
}
