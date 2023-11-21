return {
  {
    "voldikss/vim-floaterm",
    init = function()
      vim.cmd([[
        let g:floaterm_keymap_new    = "<F6>"
        let g:floaterm_keymap_prev   = "<F7>"
        let g:floaterm_keymap_next   = "<F8>"
        let g:floaterm_keymap_toggle = "<F5>"
        let g:floaterm_shell = "zsh"
      ]])
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
