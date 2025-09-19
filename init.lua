local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration modules
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Setup plugins
require('lazy').setup({
  -- Import all plugin configurations
  { import = 'plugins' },
}, {})
