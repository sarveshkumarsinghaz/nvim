local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

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

-- Telescope picker for zoxide
local function zoxide_select()
  local dirs = zoxide_list()
  if vim.tbl_isempty(dirs) then
    vim.notify("No zoxide entries found", vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = "Zoxide directories",
    finder = finders.new_table {
      results = dirs,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local function cd_selected()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          vim.cmd("cd " .. selection[1])
          vim.notify("Changed directory to: " .. selection[1], vim.log.levels.INFO)
        end
      end

      map("i", "<CR>", cd_selected)
      map("n", "<CR>", cd_selected)
      return true
    end,
  }):find()
end

-- make it available as :Zoxide
vim.api.nvim_create_user_command("Zoxide", zoxide_select, {})
vim.keymap.set("n", "<leader>cp", zoxide_select, { desc = "Change PWD using zoxide" })

