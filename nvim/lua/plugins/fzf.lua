return {
	{
		'ibhagwan/fzf-lua',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			local fzf = require('fzf-lua')

			-- Telescope-like keybinds + hide-on-Esc so resume keeps cursor position.
			fzf.setup({
				{ 'telescope', 'hide' },
				grep = {
					rg_glob = true,
				},
				lsp = {
					jump1 = true,
					ignore_current_line = true,
				},
			})

			fzf.register_ui_select()

			-- Same leader maps as the old Telescope setup.
			vim.keymap.set('n', '<leader>?', fzf.oldfiles, { desc = '[?] Find recently opened files' })
			vim.keymap.set('n', '<leader><space>', fzf.buffers, { desc = '[ ] Find existing buffers' })
			vim.keymap.set('n', '<leader>/', function()
				fzf.blines({ previewer = false })
			end, { desc = '[/] Fuzzily search in current buffer' })

			vim.keymap.set('n', '<leader>gf', fzf.git_files, { desc = 'Search [G]it [F]iles' })
			vim.keymap.set('n', '<leader>gs', fzf.git_status, { desc = '[G]it [S]tatus' })
			vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
			vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
			vim.keymap.set('v', '<leader>sw', fzf.grep_visual, { desc = '[S]earch selection' })
			vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
		end,
	},
}
