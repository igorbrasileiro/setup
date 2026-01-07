return {
	-- Set lualine as statusline
	{
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				theme = 'onedark',
				component_separators = '|',
				section_separators = '',
			},
		},
	},

	-- Add indentation guides even on blank lines
	{
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {},
		main = "ibl",
		config = function()
			require('ibl').setup({
				indent = { char = "|" },
			})
		end,
	},

	-- Useful plugin to show you pending keybinds.
	{ 'folke/which-key.nvim', opts = {} },
}
