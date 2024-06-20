local nvim_version = vim.version()

local DEFAULTS = {}

DEFAULTS.title = {
  " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
  " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
  " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
  " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
  " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
  " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
}

DEFAULTS.version = {
  "",
  "                     Version: " .. nvim_version.major .. "." .. nvim_version.minor .. "." .. nvim_version.patch,
  "",
}

DEFAULTS.info = {
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

local function combine_arrays(...)
  local combined = {}
  for _, array in ipairs({...}) do
    for _, value in ipairs(array) do
      table.insert(combined, value)
    end
  end
  return combined
end

local function setup(options)
  local title = options.title or DEFAULTS.title
  local version = options.version or DEFAULTS.version
  local info = options.info or DEFAULTS.info

  local intro = combine_arrays(title, version, info)
  return intro
end



return {
  setup = setup
}
