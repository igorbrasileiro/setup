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

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
					vim.lsp.buf.format { async = true }
				end, { desc = 'Format current buffer with LSP' })
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
			-- pyright = {},
			-- rust_analyzer = {},
			-- TypeScript and Deno are configured below to avoid conflicts
			tailwindcss = {},
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		}

		-- Setup neovim lua configuration
		require('neodev').setup()

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		local lspconfig = require 'lspconfig'
		local util = require 'lspconfig.util'

		-- nvim-lspconfig renamed tsserver -> ts_ls in some versions; support both.
		local ts_server = lspconfig.ts_ls and 'ts_ls' or 'tsserver'

		-- Ensure the servers above are installed
		local mason_lspconfig = require 'mason-lspconfig'

		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, { 'denols', ts_server })

		mason_lspconfig.setup {
			ensure_installed = ensure_installed,
			handlers = {
				function(server_name)
					lspconfig[server_name].setup {
						capabilities = capabilities,
						settings = servers[server_name],
					}
				end,
				-- Deno: only enable if deno.json or deno.jsonc exists
				denols = function()
					lspconfig.denols.setup {
						capabilities = capabilities,
						root_dir = util.root_pattern('deno.json', 'deno.jsonc'),
					}
				end,
				-- TypeScript/JavaScript: only enable if not a Deno project.
				[ts_server] = function()
					lspconfig[ts_server].setup {
						capabilities = capabilities,
						root_dir = function(fname)
							local deno_root = util.root_pattern('deno.json', 'deno.jsonc')(fname)
							if deno_root then
								return nil
							end
							return util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')(fname)
						end,
						single_file_support = false,
					}
				end,
			},
		}
	end,
}
