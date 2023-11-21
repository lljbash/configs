return {
  {
    "gbprod/yanky.nvim",
    config = function()
      require("yanky").setup{
        system_clipboard = {
          sync_with_ring = false,
        },
      }
      vim.keymap.set({"n","x"}, "p", "<cmd>rshada<cr><Plug>(YankyPutAfter)")
      vim.keymap.set({"n","x"}, "P", "<cmd>rshada<cr><Plug>(YankyPutBefore)")
      vim.keymap.set({"n","x"}, "gp", "<cmd>rshada<cr><Plug>(YankyGPutAfter)")
      vim.keymap.set({"n","x"}, "gP", "<cmd>rshada<cr><Plug>(YankyGPutBefore)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
      vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
      vim.keymap.set({"n","x"}, "y", "<Plug>(YankyYank)")
      vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("sync_after_yank", {}),
        callback = function(ev)
          vim.cmd("silent! wshada")
        end,
      })
    end,
  },
}
