vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- helper to get zoxide dirs
local function zoxide_list()
  local handle = io.popen("zoxide query -l")
  if not handle then return {} end
  local result = {}
  for line in handle:lines() do
    table.insert(result, line)
  end
  handle:close()
  return result
end

-- main function
local function zoxide_select()
  local dirs = zoxide_list()
  if vim.tbl_isempty(dirs) then
    print("No zoxide entries found")
    return
  end

  vim.ui.select(dirs, { prompt = "Zoxide directories" }, function(choice)
    if choice then
      vim.cmd("cd " .. choice)
      print("Changed directory to: " .. choice)
    end
  end)
end

-- make it available as :Zoxide
vim.api.nvim_create_user_command("Zoxide", zoxide_select, {})

-- optional keymap
vim.keymap.set("n", "<leader>cp", zoxide_select, { desc = "Change PWD using zoxide" })

