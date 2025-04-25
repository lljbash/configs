return {
  {
    "rmagatti/auto-session",
    init = function()
      vim.o.sessionoptions =
        "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    config = function()
      require("auto-session").setup({
        post_restore_cmds = {
          function()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
              if vim.bo[bufnr].buftype == "" then
                vim.fn.bufload(bufnr)
              end
            end
          end,
        },
      })
      vim.keymap.set("n", "<C-s>", require("auto-session.session-lens").search_session, {
        noremap = true,
      })
    end,
  },
}
