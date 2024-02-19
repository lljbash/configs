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
      vim.g.floaterm_opener        = "tabe"
      vim.g.floaterm_keymap_new    = "<F6>"
      vim.g.floaterm_keymap_prev   = "<F7>"
      vim.g.floaterm_keymap_next   = "<F8>"
      vim.g.floaterm_keymap_toggle = "<F5>"
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
    end,
    config = function()
      local augroup = vim.api.nvim_create_augroup("floaterm", {})
      vim.api.nvim_create_autocmd("VimLeave", {
        group = augroup,
        pattern = "*",
        command = "FloatermKill!",
      })
      vim.api.nvim_create_autocmd("WinEnter", {
        group = augroup,
        pattern = "term://*",
        callback = function(opts)
          if vim.bo[opts.buf].filetype == "floaterm" then
            vim.opt_local.winblend = 0
          end
        end,
      })
      vim.api.nvim_create_autocmd("WinLeave", {
        group = augroup,
        pattern = "term://*",
        callback = function(opts)
          if vim.bo[opts.buf].filetype == "floaterm" then
            vim.opt_local.winblend = 30
          end
        end,
      })
    end,
    keys = { "<F5>", "<F6>", "<F7>", "<F8>" },
  },
}
