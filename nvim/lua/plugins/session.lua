return {
  {
    "rmagatti/auto-session",
    init = function()
      vim.o.sessionoptions =
        "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    config = function()
      require("auto-session").setup({
        pre_save_cmds = {
          -- "AerialClose",
        },
      })
      vim.keymap.set("n", "<C-s>", require("auto-session.session-lens").search_session, {
        noremap = true,
      })
    end,
  },
}
