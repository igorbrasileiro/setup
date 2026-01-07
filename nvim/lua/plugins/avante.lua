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
			provider = "openrouter", -- Set the default provider to OpenRouter
			mode = "agentic",
			behaviour = {
				auto_suggestions = true,
				auto_suggestion_provider = "groq", -- Use Groq for faster auto-suggestions
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
			providers = {
				openrouter = {
					__inherited_from = "openai", -- OpenRouter is OpenAI-compatible
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY", -- Environment variable name for your API key
					model = "anthropic/claude-sonnet-4.5", -- Specify the model you want to use (e.g., "mistralai/mixtral-8x7b-instruct-v0.1")
				},
				gemini = {
					model = "gemini-2.5-pro-exp-03-25",
					max_tokens = 65536,
				},
				groq = { -- define groq provider
					__inherited_from = 'openai',
					api_key_name = 'GROQ_API_KEY',
					endpoint = 'https://api.groq.com/openai/v1/',
					model = 'llama-3.3-70b-versatile',
					-- max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
					-- max_tokens = 6000, -- remember to increase this value, otherwise it will stop generating halfway
					extra_request_body = {
						max_completion_tokens = 32768
					}
				},
				deepseek = {
					__inherited_from = "openai",
					api_key_name = "DEEPSEEK_API_KEY",
					endpoint = "https://api.deepseek.com",
					model = "deepseek-ai/deepseek-r1",
				}
			},
			vendors = {
			},

			-- Improved MCPHub integration
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub:get_active_servers_prompt()
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
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
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
