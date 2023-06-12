-- WARN in nixos this file has no use
require('user.cmd')
require('user.setting')
require('user.keymap')
require('user.utils')
require('user.lualine')
require('user.cmp')
require('user.lsp')
require('user.sniprun')
require('user.nvimtree')
require('user.treesitter')
require('user.indentline')
require('user.neodev')
require('user.colorizer')

local status_ok, colorbuddy = pcall(require, "colorbuddy")
if not status_ok then
	return
end

colorbuddy.colorscheme('user.colorscheme')
