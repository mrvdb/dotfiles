-- Settings for the notifications

local naughty = require("naughty")

naughty.config.presets.timeout = 8
naughty.config.presets.position         = "top_right"
naughty.config.presets.margin           = 4
naughty.config.presets.height           = 50
naughty.config.presets.width            = 300
naughty.config.presets.gap              = 1
naughty.config.presets.ontop            = true
naughty.config.presets.font             = beautiful.font or "Verdana 8"
naughty.config.presets.icon             = "/home/mrb/.config/awesome/themes/zenburn/icons/emblem-generic.png"
naughty.config.presets.icon_size        = 32
naughty.config.presets.fg               = '#000000'
naughty.config.presets.bg               = '#f0dfaf'
naughty.config.presets.normal.border_color     = '#8c5353'
naughty.config.presets.border_width     = 2
naughty.config.presets.hover_timeout    = n

-- Presets for low urgency notification
naughty.config.presets.low.icon             = "/home/mrb/.config/awesome/themes/zenburn/icons/emblem-generic.png"

-- Presets for high urgency notification
naughty.config.presets.critical.icon           = "/home/mrb/.config/awesome/themes/zenburn/icons/emblem-important.png"
