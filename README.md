# minintro.nvim
Extremely minimalistic intro screen for Neovim. This fork of [eoh-bse's minintro](https://github.com/eoh-bse/minintro.nvim/) allows for a multi-colored title screen.

## Motivation
`minintro.nvim` hijacks the `no-name` buffer and draws a simple intro logo.
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

## Reference Configuration
If you want to see a neovim configuration using this plugin, please refer to [this
nvim setup](https://github.com/SRCthird/nvim)
