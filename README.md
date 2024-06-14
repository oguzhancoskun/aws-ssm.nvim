# aws-ssm.nvim
`aws-ssm.nvim` is a Lua module for NeoVim or Vim that facilitates adding parameters to AWS Systems Manager Parameter Store.

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

## Usage

```vim
:SSM
```

