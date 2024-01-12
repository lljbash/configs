return {
  {
    "voldikss/vim-floaterm",
    init = function()
      vim.g.floaterm_shell         = "zsh"
      vim.g.floaterm_title         = "─ floaterm ($1|$2) "
      vim.g.floaterm_width         = 0.6
      vim.g.floaterm_height        = 0.8
      vim.g.floaterm_position      = "right"
      vim.g.floaterm_borderchars   = "─│─│╭╮╯╰";
      vim.g.floaterm_opener        = "vsplit"
      vim.g.floaterm_keymap_new    = "<F6>"
      vim.g.floaterm_keymap_prev   = "<F7>"
      vim.g.floaterm_keymap_next   = "<F8>"
      vim.g.floaterm_keymap_toggle = "<F5>"
    end,
    config = function()
      vim.api.nvim_create_autocmd("QuitPre", {
        group = vim.api.nvim_create_augroup("floaterm_kill", {}),
        pattern = "*",
        command = "FloatermKill!",
      })
    end,
    keys = { "<F5>", "<F6>", "<F7>", "<F8>" },
  },
}
