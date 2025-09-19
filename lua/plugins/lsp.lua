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
		--  This function gets run when an LSP connects to a particular buffer.
		local on_attach = function(_, bufnr)
			-- NOTE: Remember that lua is a real programming language, and as such it is possible
			-- to define small helper and utility functions so you don't have to repeat yourself
			-- many times.
			--
			-- In this case, we create a function that lets us more easily define mappings specific
			-- for LSP related items. It sets the mode, buffer and description for us each time.
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
				if pcall(require, 'telescope.builtin') then
					require('telescope.builtin').lsp_references()
				else
					vim.lsp.buf.references()
				end
			end, '[G]oto [R]eferences')
			nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
			nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
			nmap('<leader>ds', function()
				if pcall(require, 'telescope.builtin') then
					require('telescope.builtin').lsp_document_symbols()
				else
					vim.lsp.buf.document_symbol()
				end
			end, '[D]ocument [S]ymbols')
			nmap('<leader>ws', function()
				if pcall(require, 'telescope.builtin') then
					require('telescope.builtin').lsp_dynamic_workspace_symbols()
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
			vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
				vim.lsp.buf.format()
			end, { desc = 'Format current buffer with LSP' })
		end

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
			ts_ls = {},
			denols = {},
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

		-- Ensure the servers above are installed
		local mason_lspconfig = require 'mason-lspconfig'

		-- Ensure only servers available in Mason are installed (denols is provided by the Deno binary)
		local ensure_in_mason = vim.tbl_filter(function(name)
			return name ~= 'denols'
		end, vim.tbl_keys(servers))

		mason_lspconfig.setup {
			ensure_installed = ensure_in_mason,
		}

		-- Using the new vim.lsp.config API instead of deprecated require('lspconfig')
		local util = require 'lspconfig.util'

		-- Use mason to set up servers, with custom root_dir logic for Deno vs TypeScript
		if type(mason_lspconfig.setup_handlers) == 'function' then
			mason_lspconfig.setup_handlers {
				function(server_name)
					if server_name == 'ts_ls' or server_name == 'denols' then
						return
					end
					vim.lsp.config(server_name, {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
					})
				end,
				['denols'] = function()
					vim.lsp.config('denols', {
						capabilities = capabilities,
						on_attach = on_attach,
						root_dir = util.root_pattern('deno.json', 'deno.jsonc'),
						init_options = { lint = true },
						settings = servers.denols,
					})
				end,
				['ts_ls'] = function()
					vim.lsp.config('ts_ls', {
						capabilities = capabilities,
						on_attach = on_attach,
						-- Disable TS in presence of a Deno project; otherwise use Node/TS roots
						root_dir = function(fname)
							if util.root_pattern('deno.json', 'deno.jsonc')(fname) then
								return nil
							end
							return util.root_pattern('package.json', 'tsconfig.json',
								'jsconfig.json')(fname)
						end,
						single_file_support = false,
						settings = servers.ts_ls,
					})
				end,
			}
		else
			-- Fallback for environments without setup_handlers
			for server_name, server_settings in pairs(servers) do
				if server_name ~= 'ts_ls' and server_name ~= 'denols' then
					vim.lsp.config(server_name, {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = server_settings,
					})
				end
			end

			vim.lsp.config('denols', {
				capabilities = capabilities,
				on_attach = on_attach,
				root_dir = util.root_pattern('deno.json', 'deno.jsonc'),
				init_options = { lint = true },
				settings = servers.denols,
			})

			vim.lsp.config('ts_ls', {
				capabilities = capabilities,
				on_attach = on_attach,
				root_dir = function(fname)
					if util.root_pattern('deno.json', 'deno.jsonc')(fname) then
						return nil
					end
					return util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json')(fname)
				end,
				single_file_support = false,
				settings = servers.ts_ls,
			})
		end
	end,
}
