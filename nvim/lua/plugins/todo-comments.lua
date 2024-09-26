return {
  -- 标记/搜索 TODO 类型注释
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
      },
      search = {
        pattern = [[\b(KEYWORDS)(\(\w*\))*:]],
      },
    },
  },
}
