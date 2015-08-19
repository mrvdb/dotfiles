-- Settings for the notifications

local naughty = require("naughty")

-- Defaults is what the defaults are for all notifications
-- If so desired, deviate from these with presets for low, normal and critical
naughty.config.defaults.timeout          = 8
naughty.config.defaults.screen           = 1
naughty.config.defaults.position         = "top_right"
naughty.config.defaults.margin           = 4
naughty.config.defaults.height           = nil -- adjust height, fix width
naughty.config.defaults.width            = 300
naughty.config.defaults.gap              = 1
naughty.config.defaults.ontop            = true
naughty.config.defaults.font             = beautiful.font or "Verdana 8"
naughty.config.defaults.icon             = "/home/mrb/.config/awesome/themes/zenburn/icons/emblem-generic.png"
naughty.config.defaults.icon_size        = 32
naughty.config.defaults.fg               = '#000000'
naughty.config.defaults.bg               = '#f0dfaf'
naughty.config.defaults.border_color     = '#8c5353'
naughty.config.defaults.border_width     = 2
naughty.config.defaults.hover_timeout    = nil

-- -- Defaults for low urgency notification
naughty.config.presets.low.icon          = "/home/mrb/.config/awesome/themes/zenburn/icons/emblem-generic.png"

-- -- Defaults for high urgency notification
naughty.config.presets.critical.icon     = "/home/mrb/.config/awesome/themes/zenburn/icons/emblem-important.png"

local low = naughty.config.presets.low
local critical = naughty.config.presets.critical

-- --Test, normally commented.
naughty.notify ({
      title =  "Test for normal notification",
      text  =  "This is how a normal notification would be presented."
})

naughty.notify ({
      title =  "Test for low priority notification",
      text  =  "This is how a low priority notification would be presented.",
      preset=  low
})

naughty.notify ({
      title =  "Test for critical priority notification",
      text  =  "This is how a critical priority notification would be presented.",
      preset=  critical
})
