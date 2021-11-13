local execute = vim.api.nvim_command
local fn = vim.fn
local cmd = vim.cmd
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
vim.o.completeopt = "menuone,noselect"
require('packer').startup(function(use)
  if packer_bootstrap then
    require('packer').sync()
  end
end)
-- Only required if you have packer configured as `opt`
cmd [[packadd packer.nvim]]
require('plugins')
cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])
require('setup')
