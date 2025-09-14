local function toggle_shell()
  local current = vim.o.shell
  if current:match("cmd.exe") then
    vim.o.shell = "pwsh.exe" -- or powershell.exe
    vim.notify("Switched shell to PowerShell")
  else
    vim.o.shell = "cmd.exe"
    vim.notify("Switched shell to cmd.exe")
  end
end

vim.api.nvim_create_user_command("Tshell", toggle_shell, {})

