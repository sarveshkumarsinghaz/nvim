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

map("n", "<leader>du", function() dapui.toggle() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })

map({ "n", "v" }, "<leader>dw", function() require("dapui").eval(nil, { enter = true }) end,
  { noremap = true, silent = true, desc = "Add word under cursor to Watches" })

map({ "n", "v" }, "Q", function() require("dapui").eval() end,
  {
    noremap = true,
    silent = true,
    desc =
    "Hover/eval a single value (opens a tiny window instead of expanding the full object) "
  })
map("n", "<leader>p", ":pwd<CR>", { desc = "Print working directory" })

-- Core LSP
  map("n", "gd", vim.lsp.buf.definition, {desc="Go to definition"})         
  map("n", "gD", vim.lsp.buf.declaration, {desc="Go to declaration"})         
  map("n", "gi", vim.lsp.buf.implementation, {desc="Go to implementation"})     
  map("n", "grr", vim.lsp.buf.references, {desc="List references"})         
  map("n", "K", vim.lsp.buf.hover, {desc="Hover docs"})         
  map("n", "<C-k>", vim.lsp.buf.signature_help, {desc="signature help"})   

  -- Code actions / Refactor
  map("n", "<leader>rn", vim.lsp.buf.rename, {desc= "Rename Symbol"})      
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {desc = "Code Action"})

  -- Diagnostics
  map("n", "gl", vim.diagnostic.open_float, {desc = "Show diagnostics popup"})       
  map("n", "[d", vim.diagnostic.goto_prev, {desc ="Prev diagnostic"})       
  map("n", "]d", vim.diagnostic.goto_next, {desc = "Next diagnostic"})      
  map("n", "<leader>q", vim.diagnostic.setloclist, {desc = "Lsp diagnostics local list"})

  -- Formatting
  map("n", "<leader>f", function()
    vim.lsp.buf.format { async = true }
  end, opts)
