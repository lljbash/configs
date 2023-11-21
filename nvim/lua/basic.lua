--- 基础的 vim 设置

vim.opt.cursorline = true   -- show the cursor line
vim.opt.mouse = "a"         -- enable mouse
vim.opt.smartcase = true    -- ignores case for search unless a capital is used in search
vim.opt.number = true
-- vim.opt.textwidth = 120
vim.opt.linebreak = true    -- don't break words on wrap
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"  -- always show the signcolumn
vim.opt.termguicolors = true
vim.opt.updatetime = 100    -- default 4000ms is too long

-- Tab 设置
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true  -- spaces instead of tabs

-- C++ 自动缩进设置
vim.opt.cino:append("g0.5s")  -- public: 前的缩进
vim.opt.cino:append("h0.5s")  -- public: 下一行的缩进
vim.opt.cino:append("N-s")    -- namespace 下一行的缩进

-- 设置快捷键 <Leader>
vim.g.mapleader = ";"

-- spellcheck
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "cjk" }
vim.opt.spellcapcheck = ""
