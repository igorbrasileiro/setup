return {
	-- avante curso IDE like
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
		opts = {
			-- add any opts here
			-- for example
			-- Cursor Agent CLI via ACP only (no OpenRouter / HTTP LLM defaults)
			provider = "cursor",
			acp_providers = {
				cursor = {
					command = vim.fn.expand("~/.local/bin/agent"),
					args = { "acp", "--model", "cursor-grok-4.5-medium" },
					auth_method = "cursor_login",
					env = {
						HOME = os.getenv("HOME"),
						PATH = os.getenv("PATH"),
					},
				},
			},
			mode = "agentic",
			behaviour = {
				-- Auto-suggestions need an HTTP provider; disabled while ACP-only
				auto_suggestions = false,
			},
			selector = {
				provider = "fzf_lua",
			},
			input = {
				provider = "dressing",
			},
			mappings = {
				ask = "<leader>aq",
				files = {
					add_current = "<leader>a.",
				},
			},
			suggestion = {
				debounce = 300, -- Time in milliseconds
				throttle = 300, -- Time in milliseconds
			},
			rag_service = {
				enabled = false, -- Set to true to enable it
				host_mount = os.getenv("HOME") .. "/dev", -- Or adjust path as needed (e.g., "/")
				runner = "docker",
				-- For OpenAI:
				embed = {    -- Embedding model configuration for RAG service
					provider = "openai", -- Embedding provider
					endpoint = "https://api.openai.com/v1", -- Embedding API endpoint
					api_key = "_OPENAI_API_KEY", -- Environment variable name for the embedding API key
					model = "text-embedding-3-small", -- Embedding model name
					extra = nil, -- Additional configuration options for the embedding model
				},
				llm = {      -- Language Model (LLM) configuration for RAG service
					provider = "openai", -- LLM provider
					endpoint = "https://api.openai.com/v1", -- LLM API endpoint
					api_key = "_OPENAI_API_KEY", -- Environment variable name for the LLM API key
					model = "gpt-4o-mini", -- LLM model name
					extra = nil, -- Additional configuration options for LLM
				},
			},
			-- HTTP providers removed — Cursor ACP is the only chat provider
			providers = {},
			vendors = {},

			-- Improved MCPHub integration
			system_prompt = function()
				local ok, hub = pcall(function()
					return require("mcphub").get_hub_instance()
				end)
				if ok and hub then
					return hub:get_active_servers_prompt()
				end
				return ""
			end,

			-- Fix for custom tools to properly load MCPHub tools
			custom_tools = function()
				local ok, mcphub_ext = pcall(require, "mcphub.extensions.avante")
				if ok then
					return { mcphub_ext.mcp_tool() }
				end
				return {}
			end,
		},

		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for selector provider fzf_lua
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				'MeanderingProgrammer/render-markdown.nvim',
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
