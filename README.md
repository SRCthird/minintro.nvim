# minintro.nvim
Extremely minimalistic intro screen for Neovim. This fork of [eoh-bse's minintro](https://github.com/eoh-bse/minintro.nvim/) allows for a multi-colored title screen.

## Motivation
Neovim intro screen can be extremely buggy and forced to close automatically by plugins installed such as 
[bufferline](https://github.com/akinsho/bufferline.nvim), 
[lualine](https://github.com/nvim-lualine/lualine.nvim) and many more.  
`minintro.nvim` hijects `no-name` and `directory` buffer and draws a simple intro logo.
If you just want a simple and lightweight startup intro that works, this plugin is for you.

## Screenshot
![minintro-screenshot](screenshots/screenshot.png)

## Installation
```lua
-- Lazy
{
    "SRCthird/minintro.nvim",
    config = true,
    lazy = false
}
```

```lua
-- Packer
use {
    "SRCthird/minintro.nvim",
    config = {function() 
        require("minintro").setup() 
    end}
}
```

## Configuration
There is only one option available for `minintro.nvim` and that is colors of the intro logo. There is no need
to create a separate config file. Pass the config directly in your plugin installation file. You can choose as many colors as you'd like.
```lua
-- Lazy
{
    "SRCthird/minintro.nvim",
    opts = { colors = {
        "#98c379"
    }}
    config = true,
    lazy = false
}
```

```lua
-- Packer
use {
    "SRCthird/minintro.nvim",
    config = {function()
        require("minintro").setup({ 
            colors = {
                "#f72585", "#b5179e", "#560bad"  
            }
        }) 
    end}
}
```

## Things to be aware of
If you have some sort of `tabline` plugin such as [bufferline](https://github.com/akinsho/bufferline.nvim),
`vim.opt.showtabline` will be overridden to `1`. This forces display of a buffer tab even when there is only
one. If you do not wanna see the tab, you can modify `bufferline`'s configuration like the following:
```lua
require("bufferline").setup({
    options = {
        always_show_bufferline = false
    }
})
```
The above configuration will effectively set `vim.opt.showtabline` to 2, meaning the tabs will only start to
display when there is more than one buffer open

## Reference Configuration
If you want to see a neovim configuration using this plugin, please refer to [this
nvim setup](https://github.com/SRCthird/nvim)
