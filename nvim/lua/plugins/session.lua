return {
  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      { "<C-s>", "<cmd>AutoSession search<CR>", desc = "Session search" },
    },
    init = function()
      vim.o.sessionoptions =
        "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    opts = {
      post_restore_cmds = {
        function()
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[bufnr].buftype == "" then
              vim.fn.bufload(bufnr)
            end
          end
        end,
      },
      load_on_setup = true,
    },
  },
}
