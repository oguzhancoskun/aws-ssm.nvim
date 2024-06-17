-- Author: Oguzhan Coskun
-- Mail: svartonn@gmail.com

local M = {}

local use_fidget = false

function M.setup(options)
  if options and options.fidget then
    use_fidget = true
  end
end

local function send_notification(message, level)
  if use_fidget then
    local fidget = require('fidget')
    if fidget and fidget.notify then
      fidget.notify(message, level)
    else
      vim.notify(message, level)
    end
  else
    vim.notify(message, level)
  end
end


local function check_parameter(path, profile)
  local cmd = string.format(
    "aws ssm get-parameter --name '%s' --profile %s > /dev/null 2>&1 ; echo $?",
    path, profile
  )

  local handle = io.popen(cmd)
  local exit_status = handle:read("*n")
  handle:close()

  if exit_status == 0 then
    return true
  else
    return false
  end
end

local function save_to_ssm(text, path, profile)


  local overwrite = "--no-overwrite"

  if check_parameter(path, profile) then
    local answer vim.fn.input("Parameter already exists. Do you want to overwrite it? (y/n): ")
    if answer == 'n' then
      send_notification("Parameter not saved.", vim.log.levels.INFO)
    else
      overwrite = "--no-overwrite"
    end
    return
  end


  local cmd = string.format( 
    "aws ssm put-parameter --name '%s' --value '%s' --type SecureString --profile %s %s > /dev/null 2>&1 ; echo $?",
    path, text, profile, overwrite
  )

  local handle = io.popen(cmd)
  local exit_status = handle:read("*n")
  handle:close()

  if exit_status == 0 then
    send_notification("Parameter saved successfully!", vim.log.levels.INFO)
  else
    send_notification("Failed to save parameter. Exit status: " .. exit_status, vim.log.levels.ERROR)
  end
end

function M.ssm()
  local clipboard_content = vim.fn.getreg('*')

  local text
  if clipboard_content ~= '' then
    local answer = vim.fn.input("Clipboard detected (y/n): ")
    if answer == 'y' then
      text = clipboard_content
      send_notification("Clipboard content used as parameter text.", vim.log.levels.INFO)
    else
      text = vim.fn.input("Enter Text: ")
    end
  end

  local path = vim.fn.input("Enter Path: ")
  local profile = vim.fn.input("Enter Profile: ")

  send_notification("\n", vim.log.levels.INFO)

  save_to_ssm(text, path, profile)
end

return M

