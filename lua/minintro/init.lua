-- Fork of https://github.com/eoh-bse/minintro.nvim
local PLUGIN_NAME = "minintro"
local DEFAULT_COLORS = {
  "#fb6f92", "#ff8fab", "#ffb3c6", "#ffc2d1", "#ffe5ec",
  "#ffe5ec", "#ffc2d1", "#ffb3c6", "#ff8fab", "#fb6f92",
}

local function setup(options)
  options = options or {}
  local colors = options.colors or DEFAULT_COLORS
  local intro_logo = require('minintro.graphics').setup(options)

  local status, result = pcall(function()
    for i, color in ipairs(colors) do
      vim.api.nvim_set_hl(0, "LineColor" .. i, { fg = color })
    end
  end)
  if not status then
    print('Minitro.nvim error: ' .. result)
    return
  end

  local draw = require('minintro.draw').draw(
    PLUGIN_NAME, intro_logo
  )

  vim.api.nvim_create_autocmd("VimEnter", {
    group = draw.autocmd_group,
    callback = function() draw.display(colors) end,
    once = true
  })
end

return {
  setup = setup
}
