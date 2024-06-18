-- Fork of https://github.com/eoh-bse/minintro.nvim
local version = vim.version()

local intro_logo = {
  " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
  " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
  " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
  " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
  " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
  " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
  "",
  "                     Version: " .. version.major .. "." .. version.minor .. "." .. version.patch,
  "",
  "     Nvim is open source and freely distributable",
  "              https://neovim.io/#chat",
  "",
  "     type  :help nvim<Enter>       if you are new!",
  "     type  :checkhealth<Enter>     to optimize Nvim",
  "     type  :q<Enter>               to exit",
  "     type  :help<Enter>            for help",
  "",
  "            Help poor children in Uganda!",
  "     type  :help iccf<Enter>       for information",
}

local PLUGIN_NAME = "minintro"
local DEFAULT_COLORS = {
  "#fb6f92", "#ff8fab", "#ffb3c6", "#ffc2d1", "#ffe5ec",
  "#ffe5ec", "#ffc2d1", "#ffb3c6", "#ff8fab", "#fb6f92",
}
local INTRO_LOGO_HEIGHT = #intro_logo
local INTRO_LOGO_WIDTH = 55

local autocmd_group = vim.api.nvim_create_augroup(PLUGIN_NAME, {})
local highlight_ns_id = vim.api.nvim_create_namespace(PLUGIN_NAME)
local minintro_buff = -1

local function unlock_buf(buf)
	vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
end

local function lock_buf(buf)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end

local function draw_minintro(buf, logo_width, logo_height, colors)
	local window = vim.fn.bufwinid(buf)
	local screen_width = vim.api.nvim_win_get_width(window)
	local screen_height = vim.api.nvim_win_get_height(window) - vim.opt.cmdheight:get()

	local start_col = math.floor((screen_width - logo_width) / 2)
	local start_row = math.floor((screen_height - logo_height) / 2)
	if (start_col < 0 or start_row < 0) then return end

	local top_space = {}
	for _ = 1, start_row do table.insert(top_space, "") end

	local col_offset_spaces = {}
	for _ = 1, start_col do table.insert(col_offset_spaces, " ") end
	local col_offset = table.concat(col_offset_spaces, '')

	local adjusted_logo = {}
	for _, line in ipairs(intro_logo) do
		table.insert(adjusted_logo, col_offset .. line)
	end

	unlock_buf(buf)
	vim.api.nvim_buf_set_lines(buf, 1, 1, true, top_space)
	vim.api.nvim_buf_set_lines(buf, start_row, start_row, true, adjusted_logo)
	lock_buf(buf)

  for i, _ in ipairs(adjusted_logo) do
    local hl_group = "LineColor" .. ((i - 1) % #colors + 1)
    vim.api.nvim_buf_add_highlight(buf, highlight_ns_id, hl_group, start_row + i - 1, start_col,
      start_col + #adjusted_logo[i])
  end
end

local function create_and_set_minintro_buf(default_buff)
  local intro_buff = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(intro_buff, PLUGIN_NAME)
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = intro_buff })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = intro_buff })
	vim.api.nvim_set_option_value("filetype", "minintro", { buf = intro_buff })
	vim.api.nvim_set_option_value("swapfile", false, { buf = intro_buff })

	vim.api.nvim_set_current_buf(intro_buff)
	vim.api.nvim_buf_delete(default_buff, { force = true })

	return intro_buff
end

local function set_options()
	vim.opt_local.number = false         -- disable line numbers
	vim.opt_local.relativenumber = false -- disable relative line numbers
	vim.opt_local.list = false           -- disable displaying whitespace
	vim.opt_local.fillchars = { eob = ' ' } -- do not display "~" on each new line
	vim.opt_local.colorcolumn = "0"      -- disable colorcolumn
end

local function redraw(colors)
	unlock_buf(minintro_buff)
	vim.api.nvim_buf_set_lines(minintro_buff, 0, -1, true, {})
	lock_buf(minintro_buff)
	draw_minintro(minintro_buff, INTRO_LOGO_WIDTH, INTRO_LOGO_HEIGHT, colors)
end

local function display_minintro(payload)
	local is_dir = vim.fn.isdirectory(payload.file) == 1

	local default_buff = vim.api.nvim_get_current_buf()
	local default_buff_name = vim.api.nvim_buf_get_name(default_buff)
	local default_buff_filetype = vim.api.nvim_get_option_value("filetype", { buf = default_buff })
	if not is_dir and default_buff_name ~= "" and default_buff_filetype ~= PLUGIN_NAME then
		return
	end

	minintro_buff = create_and_set_minintro_buf(default_buff)
	set_options()

	draw_minintro(minintro_buff, INTRO_LOGO_WIDTH, INTRO_LOGO_HEIGHT)

	vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
		group = autocmd_group,
		buffer = minintro_buff,
		callback = redraw
	})
end

local function setup(options)
	options = options or {}
  local colors = options.colors or DEFAULT_COLORS

  for i, color in ipairs(colors) do
    vim.api.nvim_set_hl(0, "LineColor" .. i, { fg = color })
  end

  vim.api.nvim_create_autocmd("VimEnter", {
    group = autocmd_group,
    callback = function() display_minintro({ file = vim.fn.getcwd(), colors = colors }) end,
    once = true
  })
end

return {
	setup = setup
}
