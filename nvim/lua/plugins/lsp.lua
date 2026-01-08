return {
	-- LSP Configuration & Plugins
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ 'williamboman/mason.nvim', config = true },
		'williamboman/mason-lspconfig.nvim',

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		'folke/neodev.nvim',
	},
	config = function()
		-- [[ Configure LSP ]]
		-- Keymaps: create them on LspAttach so they only exist when an LSP is actually attached.
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true }),
			callback = function(event)
				local bufnr = event.buf
				local nmap = function(keys, func, desc)
					if desc then
						desc = 'LSP: ' .. desc
					end
					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
				end

				nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
				nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

				nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
				nmap('gr', function()
					local ok, telescope = pcall(require, 'telescope.builtin')
					if ok then
						telescope.lsp_references()
					else
						vim.lsp.buf.references()
					end
				end, '[G]oto [R]eferences')
				nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
				nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
				nmap('<leader>ds', function()
					local ok, telescope = pcall(require, 'telescope.builtin')
					if ok then
						telescope.lsp_document_symbols()
					else
						vim.lsp.buf.document_symbol()
					end
				end, '[D]ocument [S]ymbols')
				nmap('<leader>ws', function()
					local ok, telescope = pcall(require, 'telescope.builtin')
					if ok then
						telescope.lsp_dynamic_workspace_symbols()
					else
						vim.lsp.buf.workspace_symbol()
					end
				end, '[W]orkspace [S]ymbols')

				-- See `:help K` for why this keymap
				nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
				nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

				-- Lesser used LSP functionality
				nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
				nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
				nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
				nmap('<leader>wl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, '[W]orkspace [L]ist Folders')

				-- -- Create a command `:Format` local to the LSP buffer
				-- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
				-- 	vim.lsp.buf.format { async = true }
				-- end, { desc = 'Format current buffer with LSP' })

				-- format biome
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client.name == "biome" then
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("BiomeFixAll", { clear = true }),
						callback = function()
							vim.lsp.buf.code_action({
								context = {
									only = { "source.fixAll.biome" },
									diagnostics = {},
								},
								apply = true,
							})
						end,
					})
				else
					-- Create a command `:Format` local to the LSP buffer
					vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
						vim.lsp.buf.format { async = true }
					end, { desc = 'Format current buffer with LSP' })
				end
			end,
		})

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. They will be passed to
		--  the `settings` field of the server config. You must look up that documentation yourself.
		local servers = {
			-- clangd = {},
			-- gopls = {},
			-- rust_analyzer = {},
			-- TypeScript and Deno are configured below to avoid conflicts
			biome = {},
			tsgo = {},
			tailwindcss = {},
			--
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
			-- python
			pyright = {},
			ruff = {},
			ty = {}
		}

		-- Setup neovim lua configuration
		require('neodev').setup()

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		---@diagnostic disable-next-line: deprecated
		local lspconfig = require 'lspconfig'
		---@diagnostic disable-next-line: deprecated
		local util = require 'lspconfig.util'

		-- Ensure the servers above are installed
		local mason_lspconfig = require 'mason-lspconfig'

		local ensure_installed = vim.tbl_keys(servers)

		mason_lspconfig.setup {
			ensure_installed = ensure_installed,
			handlers = {
				function(server_name)
					lspconfig[server_name].setup {
						capabilities = capabilities,
						settings = servers[server_name],
					}
				end,
			},
		}

		-- TypeScript (ts_go): uses `tsgo` binary (https://github.com/microsoft/typescript-go)
		-- Note: this is NOT managed by mason-lspconfig; you must have `tsgo` on your PATH.
		local has_tsgo = vim.fn.executable 'tsgo' == 1
		if not has_tsgo then
			vim.notify(
				'[LSP] ts_go: `tsgo` não encontrado no PATH. Instale typescript-go e deixe `tsgo` acessível.',
				vim.log.levels.WARN
			)
			return
		end

		---@diagnostic disable-next-line: deprecated
		local configs = require 'lspconfig.configs'
		if not configs.ts_go then
			configs.ts_go = {
				default_config = {
					cmd = { 'tsgo', 'lsp', '--stdio' },
					filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
					root_dir = util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json',
						'.git'),
					single_file_support = false,
				},
			}
		end

		lspconfig.ts_go.setup {
			capabilities = capabilities,
		}
	end,
}
