-- Add file/folder with C# template (single-line namespace + smarter root handling)
local function add_path(path)
  local uv = vim.loop
  local cwd = vim.fn.getcwd()
  local target = cwd .. "/" .. path

  -- Detect project root from cwd folder name
  local project_root = vim.fn.fnamemodify(cwd, ":t")

  -- Normalize target path
  target = vim.fn.fnamemodify(target, ":p")

  if path:sub(-1) == "/" then
    -- Make folder
    uv.fs_mkdir(target, 493, function(err)
      if err then
        vim.notify("Error creating folder: " .. err, vim.log.levels.ERROR)
      else
        vim.notify("Folder created: " .. target, vim.log.levels.INFO)
      end
    end)
    return
  end

  -- Ensure parent exists
  local parent = vim.fn.fnamemodify(target, ":h")
  vim.fn.mkdir(parent, "p")

  local exists = vim.fn.filereadable(target) == 1

  -- Open file in buffer
  vim.cmd("edit " .. target)

  if not exists then
    -- Insert template if it's a .cs file
    if target:match("%.cs$") then
      local fname = vim.fn.fnamemodify(target, ":t:r") -- filename without extension
      local relpath = target:sub(#cwd + 2, -#fname - 5) -- relative folder
      local namespace = relpath:gsub("[/\\]", ".")      -- convert path to namespace
      namespace = namespace:gsub("^%.*", "")           -- strip leading dots

      -- 🔥 Prevent duplication of project_root
      if namespace:find("^" .. project_root) then
        -- already starts with project root → leave it
      elseif namespace ~= "" then
        namespace = project_root .. "." .. namespace
      else
        namespace = project_root
      end

      local lines
      if fname:match("Tests$") then
        -- XUnit test boilerplate
        lines = {
          "using Xunit;",
          "",
          "namespace " .. namespace .. ";",
          "",
          "public class " .. fname,
          "{",
          "    [Fact]",
          "    public void Test1()",
          "    {",
          "        Assert.True(true);",
          "    }",
          "}",
        }
      elseif fname:match("^I[A-Z]") then
        -- Interface boilerplate
        lines = {
          "namespace " .. namespace .. ";",
          "",
          "public interface " .. fname,
          "{",
          "}",
        }
      else
        -- Class boilerplate
        lines = {
          "namespace " .. namespace .. ";",
          "",
          "public class " .. fname,
          "{",
          "}",
        }
      end

      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      vim.cmd("write") -- save immediately
      vim.notify("C# file created with namespace: " .. namespace, vim.log.levels.INFO)
    else
      vim.notify("File created: " .. target, vim.log.levels.INFO)
    end
  else
    vim.notify("Opened existing file: " .. target, vim.log.levels.WARN)
  end
end

-- Command: :Add <path>
vim.api.nvim_create_user_command("Add", function(opts)
  add_path(opts.args)
end, { nargs = 1, complete = "file" })

vim.keymap.set("n", "<leader>a", ":Add ", { desc = "Add new file/folder", silent = false })
