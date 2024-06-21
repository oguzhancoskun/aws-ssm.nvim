# aws-ssm.nvim

[![Luacheck](https://img.shields.io/github/actions/workflow/status/oguzhancoskun/aws-ssm.nvim/luacheck.yml?branch=main&label=Luacheck&logo=Lua)](https://github.com/oguzhancoskun/aws-ssm.nvim/actions?workflow=Luacheck)
![language](https://img.shields.io/badge/language-lua-yellow)
![version](https://img.shields.io/badge/version-0.1.0-blue)
![author](https://img.shields.io/badge/author-oguzhancoskun-blue)
![neovim](https://img.shields.io/badge/neovim-0.5%2B-green)
![license](https://img.shields.io/github/license/oguzhancoskun/aws-ssm.nvim)
![GitHub stars](https://img.shields.io/github/stars/oguzhancoskun/aws-ssm.nvim)

`aws-ssm.nvim` is a Lua module for NeoVim or Vim that facilitates the use of
AWS SSM Parameter Store. This module is using `aws-cli` to interact with AWS SSM Parameter Store.

## Requirements

- [aws-cli](https://aws.amazon.com/cli/)
- [fidget](https://github.com/j-hui/fidget.nvim) (optional)

## Installation

### Using vim-plug

```vim
Plug 'oguzhancoskun/aws-ssm.nvim'
```


## Configuration

```lua
requre('aws-ssm').setup{
  fidget = true, -- if you want to see the outputs on fidget
}
```

## Commands

- `:PSMPut` - Add parameter to AWS SSM Parameter Storie
- `:PSMList` - List parameters in AWS SSM Parameter Store

## Features

- Add parameter to AWS SSM Parameter Store
- List parameters in AWS SSM Parameter Store
- When you add a parameter, it will be encrypted by default
- You can see the outputs on fidget
- You can use directly clipboard item for the parameter value
- List parameters with pagination and can be show encrypted values
