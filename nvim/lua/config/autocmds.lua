-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

-- Format on save when an LSP client supports it.
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		local bufnr = args.buf
		local clients = vim.lsp.get_clients({ bufnr = bufnr })

		for _, client in ipairs(clients) do
			if client:supports_method('textDocument/formatting') then
				vim.lsp.buf.format({
					async = false,
					bufnr = bufnr,
					timeout_ms = 2000,
				})
				return
			end
		end
	end,
})
