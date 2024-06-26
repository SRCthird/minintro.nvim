local function draw(PLUGIN_NAME, intro_logo)
  local INTRO_LOGO_HEIGHT = #intro_logo
  local INTRO_LOGO_WIDTH = (function()
    local max_length = 0
    for _, str in ipairs(intro_logo) do
      local str_length = #(str):gsub('[\128-\191]', '')
      if str_length > max_length then
        max_length = str_length
      end
    end
    return max_length
  end)()

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

  local function create_and_set_minintro_buf()
    local intro_buff = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(intro_buff, PLUGIN_NAME)
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = intro_buff })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = intro_buff })
    vim.api.nvim_set_option_value("filetype", "minintro", { buf = intro_buff })
    vim.api.nvim_set_option_value("swapfile", false, { buf = intro_buff })

    vim.api.nvim_set_current_buf(intro_buff)

    return intro_buff
  end

  local function set_options()
    vim.opt_local.number = false            -- disable line numbers
    vim.opt_local.relativenumber = false    -- disable relative line numbers
    vim.opt_local.list = false              -- disable displaying whitespace
    vim.opt_local.fillchars = { eob = ' ' } -- do not display "~" on each new line
    vim.opt_local.colorcolumn = "0"         -- disable colorcolumn
  end

  local function redraw(colors)
    unlock_buf(minintro_buff)
    vim.api.nvim_buf_set_lines(minintro_buff, 0, -1, true, {})
    lock_buf(minintro_buff)
    draw_minintro(minintro_buff, INTRO_LOGO_WIDTH, INTRO_LOGO_HEIGHT, colors)
  end

  local function display_minintro(colors)
    local default_buff = vim.api.nvim_get_current_buf()
    local default_buff_name = vim.api.nvim_buf_get_name(default_buff)
    if default_buff_name ~= "" then
      local winid = -1
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local cbuf = vim.api.nvim_win_get_buf(win)
        local cbufname = vim.api.nvim_buf_get_name(cbuf)
        if cbufname == "" then
          winid = win
          break
        end
      end
      if winid == -1 then
        return
      end
      vim.api.nvim_set_current_win(winid)
    end

    minintro_buff = create_and_set_minintro_buf()
    set_options()

    draw_minintro(minintro_buff, INTRO_LOGO_WIDTH, INTRO_LOGO_HEIGHT, colors)

    vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
      group = autocmd_group,
      buffer = minintro_buff,
      callback = function() redraw(colors) end
    })
  end

  return {
    autocmd = autocmd_group,
    display = display_minintro,

  }
end

return {
  draw = draw
}
