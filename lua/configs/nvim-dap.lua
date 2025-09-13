local dap = require("dap")

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe"

local netcoredbg_adapter = {
  type = "executable",
  command = mason_path,
  args = { "--interpreter=vscode" },
}

dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
dap.adapters.coreclr = netcoredbg_adapter    -- needed for unit test debugging

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",

    program = function()
      return require("dap-dll-autopicker").build_dll_path()
    end,
    -- justMyCode = false,
    -- stopAtEntry = false,
    -- -- program = function()
    -- --   -- todo: request input from ui
    -- --   return "/path/to/your.dll"
    -- -- end,
    -- env = {
    --   ASPNETCORE_ENVIRONMENT = function()
    --     -- todo: request input from ui
    --     return "Development"
    --   end,
    --   ASPNETCORE_URLS = function()
    --     -- todo: request input from ui
    --     return "http://localhost:5050"
    --   end,
    -- },
    -- cwd = function()
    --   -- todo: request input from ui
    --   return vim.fn.getcwd()
    -- end,
  },
}

local map = vim.keymap.set

local opts = { noremap = true, silent = true }

map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", opts)
map("n", "<F6>", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", opts)
map("n", "<F9>", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
map("n", "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
-- map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
map("n", "<leader>ts", function() require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })

-- Open the output (error details, logs) for the last run
map("n", "<leader>to", function()  require("neotest").output.open({ enter = true })
end, { desc = "Show test output" })

-- Open a quick popup with output for the nearest test
map("n", "<leader>tp", function()  require("neotest").output_panel.toggle()
end, { desc = "Toggle output panel" })
map("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts)
map("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opts)
map("n", "<leader>dt", "<Cmd>lua require('neotest').run.run()<CR>",
  { noremap = true, silent = true, desc = 'debug nearest test' })
