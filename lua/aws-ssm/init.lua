-- aws-ssm.lua

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
  local text = vim.fn.input("Enter Text: ")
  local path = vim.fn.input("Enter Path: ")
  local profile = vim.fn.input("Enter Profile: ")

  local clipboard_content = vim.fn.getreg('*')
  if clipboard_content ~= '' then
    text = clipboard_content
  end
  
  print("")
  
  save_to_ssm(text, path, profile)
end

return M

