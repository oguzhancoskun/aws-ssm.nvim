local M = {}

local function save_to_ssm(text, path, profile)
  local cmd = string.format(
    "aws ssm put-parameter --name '%s' --value '%s' --type SecureString --profile %s > /dev/null 2>&1 ; echo $?",
    path, text, profile
  )

  local handle = io.popen(cmd)
  local exit_status = handle:read("*n")
  handle:close()

  if exit_status == 0 then
    vim.notify("Parameter saved successfully!", vim.log.levels.INFO)
  else
    vim.notify("Failed to save parameter. Exit status: " .. exit_status, vim.log.levels.ERROR)
  end
end

function M.ssm()
  local clipboard_content = vim.fn.getreg('*')

  local text
  if clipboard_content ~= '' then
    local answer = vim.fn.input("Clipboard detected (y/n): ")
    if answer == 'y' then
      text = clipboard_content
      vim.notify("Clipboard content used as parameter text.", vim.log.levels.INFO)
    else
      text = vim.fn.input("Enter Text: ")
    end
  end

  local path = vim.fn.input("Enter Path: ")
  local profile = vim.fn.input("Enter Profile: ")

  vim.notify("\n", vim.log.levels.INFO)

  save_to_ssm(text, path, profile)
end

return M
