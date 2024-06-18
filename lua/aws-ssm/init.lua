-- init.lua
local ssm = require('ssm')

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
end

return M

