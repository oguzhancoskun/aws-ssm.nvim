-- ssm.lua
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
    local answer = vim.fn.input("Parameter already exists. Do you want to overwrite it? (y/n): ")
    if answer == 'n' then
      send_notification("Parameter not saved.", vim.log.levels.INFO)
      return
    else
      overwrite = "--overwrite"
    end
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

local function create_floating_window()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'rounded'
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  return buf, win
end

local function list_in_floating_window(parameters)
  local buf, win = create_floating_window()

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, parameters)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  -- Close the window on 'q' press
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bd!<CR>', { noremap = true, silent = true })
end

function M.list_parameters()
  local keyword = vim.fn.input("Enter keyword to search for: ")
  local profile = vim.fn.input("Enter AWS profile: ")

  local cmd = string.format(
    "aws ssm describe-parameters --profile %s --query 'Parameters[?contains(Name, `%s`)].Name' --output json",
    profile, keyword
  )

  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()

  local parameters = vim.fn.json_decode(result)

  if parameters and #parameters > 0 then
    list_in_floating_window(parameters)
  else
    send_notification("No matching parameters found.", vim.log.levels.INFO)
  end
end


return M

