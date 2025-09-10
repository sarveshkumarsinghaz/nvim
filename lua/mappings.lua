require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map({"n","v"}, '<leader>ca', vim.lsp.buf.code_action, {desc = "Code Action"})
map('t', '<Esc><Esc>', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true), 'n', true)
  vim.cmd('bd!')
end, { desc = 'Exit terminal mode and close buffer' })
map('n', '<Esc><Esc>',"<C-w><C-q>", { desc = 'close window' })
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Normal mode
map('n', '<A-j>', ':m .+1<CR>==', opts)  -- Move line down
map('n', '<A-k>', ':m .-2<CR>==', opts)  -- Move line up

-- Visual mode
map('v', '<A-j>', ":m '>+1<CR>gv=gv", opts)  -- Move block down
map('v', '<A-k>', ":m '<-2<CR>gv=gv", opts)  -- Move block up


-- Resize with Ctrl + Arrow keys
map('n', '<C-Up>',    ':resize +2<CR>', opts)    -- increase height
map('n', '<C-Down>',  ':resize -2<CR>', opts)    -- decrease height
map('n', '<C-Left>',  ':vertical resize -2<CR>', opts) -- decrease width
map('n', '<C-Right>', ':vertical resize +2<CR>', opts) -- increase width

