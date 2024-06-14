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
    print("Parameter saved successfully!")
  else
    print("Failed to save parameter. Exit status: " .. exit_status)
  end
end

function M.ssm()
  local clipboard_content = vim.fn.getreg('*')

  local text
  if clipboard_content ~= '' then


    local answer = vim.fn.input("Clipboard detected (y/n): ")
    if answer == 'y' then
      text = clipboard_content
      print("Clipboard content used as parameter text.")
    else
      text = vim.fn.input("Enter Text: ")
    end

    text = clipboard_content
  else
    text = vim.fn.input("Enter Text: ")
  end

  local path = vim.fn.input("Enter Path: ")
  local profile = vim.fn.input("Enter Profile: ")

  print("")

  save_to_ssm(text, path, profile)
end

return M
