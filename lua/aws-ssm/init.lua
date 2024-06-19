-- init.lua
local ssm = require('aws-ssm.ssm')

local M = {}

function M.setup(options)
  ssm.setup(options)

  -- Register the custom command
  vim.api.nvim_create_user_command(
    'PSMPut',
    function()
      ssm.ssm()
    end,
    { nargs = 0 }
  )

  vim.api.nvim_create_user_command(
    'PSMList',
    function()
      ssm.list_parameters()
    end,
    { nargs = 0 }
  )

end

return M

