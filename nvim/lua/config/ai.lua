local function avante_toggle()
	require("avante").toggle()
end

local function use_cursor()
	local Config = require("avante.config")
	if Config.provider ~= "cursor" then
		Config.override({ provider = "cursor" })
		require("avante.utils").info("Switch to provider: cursor", { title = "Avante" })
	end

	local avante = require("avante")
	if avante.is_sidebar_open() then
		require("avante.api").focus()
	else
		avante.open_sidebar({})
	end
end

local function open_mcphub()
	vim.cmd("MCPHub")
end

local function setup_ai_keymaps()
	vim.keymap.set("n", "<leader>aa", avante_toggle, { desc = "AI: Avante toggle" })
	vim.keymap.set("n", "<leader>ac", use_cursor, { desc = "AI: Cursor Agent (ACP)" })
	vim.keymap.set("n", "<leader>am", open_mcphub, { desc = "AI: MCPHub" })
end

local function register_which_key()
	local ok, wk = pcall(require, "which-key")
	if not ok then
		return
	end

	wk.add({
		{ "<leader>a", group = "AI" },
	})
end

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	once = true,
	callback = function()
		setup_ai_keymaps()
		register_which_key()
	end,
})
