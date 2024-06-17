# aws-ssm.nvim
`aws-ssm.nvim` is a Lua module for NeoVim or Vim that facilitates adding parameters to AWS Systems Manager Parameter Store.

Module can be check clipboard and if any clipboard item exist, you can use it directly.

## Installation

### Using vim-plug

```vim
Plug 'oguzhancoskun/aws-ssm.nvim'
```


## Configuration

```lua
require('aws-ssm')
vim.cmd("command! -nargs=0 SSM lua require('aws-ssm').ssm()")
```

## Optional Setup Settings

```lua
requre('aws-ssm').setup{
  fidget = true, -- if you want to see the outputs on fidget
}
```

## Usage

```vim
:SSM
```

