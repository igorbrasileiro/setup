return {
	-- MCP HUB
	{
		"ravitemer/mcphub.nvim",
		-- tag = "v4.6.1",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
		},
		-- Remove lazy loading to ensure MCPHub is available when avante.nvim loads
		-- cmd = "MCPHub",
		build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
		config = function()
			require("mcphub").setup({
				auto_approve = true,
				-- Add any additional configuration needed for your Puppeteer server
				-- For example, you might need to specify server settings:
				-- servers = {
				--   puppeteer = {
				--     enabled = true,
				--     -- any specific puppeteer server settings
				--   }
				-- }
			})
		end,
	},
}
