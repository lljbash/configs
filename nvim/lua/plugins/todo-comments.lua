return {
  -- 标记/搜索 TODO 类型注释
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        keyword = "bg",
        pattern = [[.*<(KEYWORDS)(\(.+\))?:]],
      },
      search = {
        pattern = [[\b(KEYWORDS)(\(.+\))?:]],
      },
    },
  },
}
