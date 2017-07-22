-- This is the main configuration file for awesome

-- Catch errors and fallback to /etc/xdg/awesome/rc.lua if aw.lua fails
-- a la http://www.markurashi.de/dotfiles/awesome/rc.lua

local awful   = require("awful")
local naughty = require("naughty")

-- This is the normal sequence of events
-- Load my main file and check for errors
local rc, err = loadfile(awful.util.getdir("config") .. "/aw.lua")
if rc then
  rc, err = pcall(rc)
  if rc then
    return
  end
end

-- And if I screw up, we get here.
dofile("/home/mrb/.config/awesome/rc-save.lua")

for s = 1,screen.count() do
  mypromptbox[s].text = awful.util.escape(err:match("[^\n]*"))
end

naughty.notify { text = "awesomeWM crashed during startup on " .. os.date("%d/%m/%Y %T:\n\n") ..  err .. "\n", timeout = 0 }
