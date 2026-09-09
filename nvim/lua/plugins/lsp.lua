return {
	'neovim/nvim-lspconfig',
	dependencies = {
		{ 'williamboman/mason.nvim', config = true },
		'williamboman/mason-lspconfig.nvim',

		{ 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

		'folke/neodev.nvim',
	},

	config = function()
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true }),

			callback = function(event)
				local bufnr = event.buf

				local nmap = function(keys, func, desc)
					if desc then
						desc = 'LSP: ' .. desc
					end

					vim.keymap.set('n', keys, func, {
						buffer = bufnr,
						desc = desc,
					})
				end

				local function picker(name, fallback)
					return function()
						local ok, fzf = pcall(require, 'fzf-lua')

						if ok and fzf[name] then
							fzf[name]()
						else
							fallback()
						end
					end
				end

				nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
				nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

				nmap('gd', picker('lsp_definitions', vim.lsp.buf.definition), '[G]oto [D]efinition')
				nmap('gr', picker('lsp_references', vim.lsp.buf.references), '[G]oto [R]eferences')
				nmap('gI', picker('lsp_implementations', vim.lsp.buf.implementation), '[G]oto [I]mplementation')
				nmap('<leader>D', picker('lsp_typedefs', vim.lsp.buf.type_definition), 'Type [D]efinition')
				nmap('<leader>ds', picker('lsp_document_symbols', vim.lsp.buf.document_symbol), '[D]ocument [S]ymbols')
				nmap('<leader>ws', picker('lsp_live_workspace_symbols', vim.lsp.buf.workspace_symbol), '[W]orkspace [S]ymbols')

				nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
				nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

				nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

				nmap(
					'<leader>wa',
					vim.lsp.buf.add_workspace_folder,
					'[W]orkspace [A]dd Folder'
				)

				nmap(
					'<leader>wr',
					vim.lsp.buf.remove_workspace_folder,
					'[W]orkspace [R]emove Folder'
				)

				nmap('<leader>wl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, '[W]orkspace [L]ist Folders')

				pcall(vim.api.nvim_buf_create_user_command, bufnr, 'Format', function()
					vim.lsp.buf.format({
						async = true,
					})
				end, {
					desc = 'Format current buffer with LSP',
				})
			end,
		})

		-- TypeScript / Python / web tooling only.
		-- lua_ls stays for editing this Neovim config.
		local servers = {
			tsc = {},
			oxlint = {},
			oxfmt = {},
			tailwindcss = {},
			lua_ls = {
				Lua = {
					workspace = {
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
			pyright = {},
			ruff = {},
			ty = {},
		}

		local js_ts_filetypes = {
			'javascript',
			'javascriptreact',
			'typescript',
			'typescriptreact',
		}

		local web_filetypes = {
			'javascript',
			'javascriptreact',
			'typescript',
			'typescriptreact',
			'html',
			'css',
			'scss',
			'less',
			'json',
			'jsonc',
			'yaml',
			'markdown',
		}

		require('neodev').setup()

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		capabilities =
		    require('cmp_nvim_lsp').default_capabilities(capabilities)

		vim.lsp.config('*', {
			capabilities = capabilities,
		})

		for server_name, server_settings in pairs(servers) do
			if
			    type(server_settings) == 'table'
			    and next(server_settings)
			then
				vim.lsp.config(server_name, {
					settings = server_settings,
				})
			end
		end

		-- Keep filetypes to languages this setup actually uses so
		-- `:checkhealth vim.lsp` does not warn about unknown fts.
		vim.lsp.config('oxlint', {
			filetypes = js_ts_filetypes,
		})

		vim.lsp.config('oxfmt', {
			filetypes = web_filetypes,
		})

		vim.lsp.config('tailwindcss', {
			filetypes = {
				'javascript',
				'javascriptreact',
				'typescript',
				'typescriptreact',
				'html',
				'css',
				'scss',
				'less',
			},
		})

		require('mason-lspconfig').setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_enable = false,
		})

		local function cmd_ready(name)
			local config = vim.lsp.config[name]
			local cmd = config and config.cmd

			if type(cmd) == 'function' then
				return true
			end

			return type(cmd) == 'table'
			    and cmd[1] ~= nil
			    and vim.fn.executable(cmd[1]) == 1
		end

		for server_name in pairs(servers) do
			if cmd_ready(server_name) then
				vim.lsp.enable(server_name)
			end
		end
	end,
}
