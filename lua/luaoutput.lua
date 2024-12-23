--[[
 _                 _____       _               _     _                    ___  ____ _ _            ___                  
| |               |  _  |     | |             | |   | |              ____ |  \/  (_) | |          / _ \                 
| |    _   _  __ _| | | |_   _| |_ _ __  _   _| |_  | |__  _   _    / __ \| .  . |_| | | ___ _ __/ /_\ \_ __  _ __  ___ 
| |   | | | |/ _` | | | | | | | __| '_ \| | | | __| | '_ \| | | |  / / _` | |\/| | | | |/ _ \ '__|  _  | '_ \| '_ \/ __|
| |___| |_| | (_| \ \_/ / |_| | |_| |_) | |_| | |_  | |_) | |_| | | | (_| | |  | | | | |  __/ |  | | | | |_) | |_) \__ \
\_____/\__,_|\__,_|\___/ \__,_|\__| .__/ \__,_|\__| |_.__/ \__, |  \ \__,_\_|  |_/_|_|_|\___|_|  \_| |_/ .__/| .__/|___/
                                  | |                       __/ |   \____/                             | |   | |        
                                  |_|                      |___/                                       |_|   |_|        


-- A simple windowed lua output for the current file
-- This uses the `:luafile` command to run the current file
-- and display the output in a new window below the current one.
-- will this be the best thing in the world? probably not
--]]

-- TODO: Add syntax highlighting to the output buffer
-- TODO: Add error highlighting to the output buffer
-- TODO: Add Run-On-Save functionality
-- TODO: Add auto-close after 30 seconds
-- TODO: Add LSP docs

local M = {}

-- Helper function to find and close any existing output window
local function cleanup_existing_output()
	-- Find windows with lua-output filetype
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.api.nvim_buf_get_option(buf, "filetype")
		if ft == "lua-output" then
			-- Close the window (which will wipe the buffer due to bufhidden=wipe)
			vim.api.nvim_win_close(win, true)
		end
	end
end

local function create_output_window()
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "swapfile", false)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "filetype", "lua-output")

	-- Store current window to return to later
	local current_win = vim.api.nvim_get_current_win()

	-- Create split
	vim.cmd("split")
	vim.cmd("wincmd J")
	vim.cmd("resize 10")

	-- Get the window and set buffer
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)

	-- Set window options
	vim.api.nvim_win_set_option(win, "wrap", false)
	vim.api.nvim_win_set_option(win, "cursorline", true)
	vim.api.nvim_win_set_option(win, "number", false)
	vim.api.nvim_win_set_option(win, "relativenumber", false)

	-- Add keymap to close window
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", {
		noremap = true,
		silent = true,
	})

	-- Return to original window
	vim.api.nvim_set_current_win(current_win)

	return buf, win
end

local function execute_lua(content)
	-- Create temporary file
	local tmpfile = vim.fn.tempname() .. ".lua"
	vim.fn.writefile(vim.split(content, "\n"), tmpfile)

	-- Execute using :luafile and capture output
	local output = {}

	-- Capture both print output and command output
	local result = vim.fn.execute("luafile " .. tmpfile)

	-- Clean up
	vim.fn.delete(tmpfile)

	-- Process output
	if result and result ~= "" then
		for _, line in ipairs(vim.split(result, "\n")) do
			if line ~= "" then
				table.insert(output, line)
			end
		end
	end

	return output
end

function M.lua_output_window()
	-- Get current buffer's content
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local content = table.concat(lines, "\n")

	-- Execute and capture all output
	local output = execute_lua(content)
	local final_output = #output > 0 and output or { "No output" }

	-- Cleanup any existing output window
	cleanup_existing_output()

	-- Create fresh output window
	local buf, win = create_output_window()

	-- Display the output
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, final_output)
end

-- Set up the plugin (called automatically by lazy.nvim)
function M.init()
	-- Create command
	vim.api.nvim_create_user_command("LuaOutput", function()
		M.lua_output_window()
	end, {})

	-- Default keymap
	vim.keymap.set("n", "<A-l>", "<cmd>LuaOutput<CR>", {
		desc = "Run lua for current file",
		noremap = true,
		silent = true,
	})
end

return M
