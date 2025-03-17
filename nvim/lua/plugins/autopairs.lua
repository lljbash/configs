--- 自动括号补全
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("nvim-autopairs").setup({
        -- <M-e> fast wrap incomplete pair
        fast_wrap = {},
      })
    end,
  },
}
