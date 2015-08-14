-- Standard awesome library
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")

-- Widget and layout library
wibox = require("wibox")
menubar = require("menubar")

local vicious = require("vicious")
local vicious_contrib = require("vicious.contrib")

-- Themes define colours, icons, and wallpapers
beautiful = require("beautiful")
beautiful.init("/home/mrb/.config/awesome/themes/zenburn/theme.lua")
-- Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

-- The systray is a bit complex. We need to configure it to display
-- the right colors. Here is a link with more background about this:
-- http://thread.gmane.org/gmane.comp.window-managers.awesome/9028
xprop = assert(io.popen("xprop -root _NET_SUPPORTING_WM_CHECK"))
wid = xprop:read():match("^_NET_SUPPORTING_WM_CHECK.WINDOW.: window id # (0x[%S]+)$")
xprop:close()
if wid then
   wid = tonumber(wid) + 1
   os.execute("xprop -id " .. wid ..
		 " -format _NET_SYSTEM_TRAY_COLORS 32c " ..
		 "-set _NET_SYSTEM_TRAY_COLORS " ..
		 "56320,56320,52224,65535,8670,8670,65535,32385,0,8670,65535,8670")
end

-- Environment settings
local home   = os.getenv("HOME")
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell
local scount = screen.count()
config = awful.util.getdir("config")

-- This is used later as the default terminal and editor to run.
terminal   = "x-terminal-emulator"
editor     = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
   --awful.layout.suit.fair,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.magnifier,        -- master in the middle, windows select puts it there
}

--
-- Tags use layouts, but gets used by keybindings
-- Define a tag table which hold all screen tags.
tagdefs = {
   names = {"default","web","edit","system","mail","contact","media"},
   layout ={layouts[1], layouts[1],layouts[1],layouts[1],layouts[1],layouts[1],layouts[1]}
}
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tagdefs.names, s, tagdefs.layout)
end

-- Keybindings can be defined now.
clientkeys    = {}
clientbuttons = {}
local bindings = require("bindings")

-- Notification library settings
local notifications = require('notifications')

--
-- Prepare components for the wibox

-- separator image
-- FIXME: does not work since 3.5.1
separator = wibox.widget.imagebox()
separator.set_image = beautiful.widget_sep

-- Battery
battery = wibox.widget.textbox()    
battery:set_text(" | Battery | ")    
batterytimer = timer({ timeout = 5 })    
batterytimer:connect_signal("timeout",    
  function()    
    fh = assert(io.popen("acpi | cut -d, -f 2,3 -", "r"))    
    battery:set_text(" | 🔋" .. fh:read("*l") .. " | ")    
    fh:close()    
  end    
)    
batterytimer:start()

-- CPU usage
cpuicon = wibox.widget.imagebox()
cpuicon.image = beautiful.widget_cpu
cpugraph = awful.widget.graph()
cpugraph:set_width(40):set_height(14)
cpugraph:set_background_color(beautiful.fg_off_widget)

cpugraph:set_color({  type = "linear",
		      from = { 0, 0 }, to = { 0, 20 },
		      stops = {
			 { 0, beautiful.fg_end_widget },
			 { 0.5,beautiful.fg_center_widget },
			 { 1, beautiful.fg_widget }
		      }
		   }
)
vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, LeftButton, awful.tag.viewonly),
                    awful.button({ Cmd }, LeftButton, awful.client.movetotag),
                    awful.button({ }, RightButton, awful.tag.viewtoggle),
                    awful.button({ Cmd }, RightButton, awful.client.toggletag),
                    awful.button({ }, ScrollUp, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, ScrollDown, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, LeftButton, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, RightButton, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, ScrollUp, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, ScrollDown, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, LeftButton, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, RightButton, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, ScrollUp, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, ScrollDown, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    -- mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(separator)
    left_layout:add(mytaglist[s])
    left_layout:add(separator)

    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()

    -- System tray just on the first screen
    local st = wibox.widget.systray()

    if s == 1 then right_layout:add(st) end

    right_layout:add(battery)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}


--
-- Rules inclusion
--
local rules = require("rules")

--
-- Signals inclusion
--
local signals = require("signals")

--
-- Load the configuration for our startup applications.
--
local startup = require("startup")
