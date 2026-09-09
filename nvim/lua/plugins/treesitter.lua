return {
	'nvim-treesitter/nvim-treesitter',

	lazy = false,

	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},

	build = ':TSUpdate',

	config = function()
		local treesitter = require('nvim-treesitter')

		local parsers = {
			'c',
			'cpp',
			'go',
			'lua',
			'python',
			'rust',
			'tsx',
			'typescript',
			'vimdoc',
			'vim',
			'javascript',
			'markdown',
			'markdown_inline',
			'json',
			'yaml',
			'bash',
		}

		treesitter.setup()

		-- Install missing parsers.
		treesitter.install(parsers)

		-- Enable Tree-sitter highlighting.
		vim.api.nvim_create_autocmd('FileType', {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})

		-- Enable Tree-sitter indentation.
		vim.api.nvim_create_autocmd('FileType', {
			callback = function()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
