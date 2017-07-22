--
-- Signals configuration
-- A signal is a hook which can be configured by adding a behaviour to it.
--
-- The documentation for signals is here: https://awesome.naquadah.org/wiki/Signals


-- Signal function to execute when a new client appears.
client.connect_signal(
   "manage",
   function (c, startup)
      -- Enable sloppy focus for each new client
      -- c:add_signal(
      -- 	 "mouse::enter",
      -- 	 function(c)
      -- 	    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
      -- 	    and awful.client.focus.filter(c) then
      -- 	    client.focus = c
      -- 	 end
      -- end)

      if not startup then
	 -- Set the windows at the slave,
	 -- i.e. put it at the end of others instead of setting it master.
	 -- awful.client.setslave(c)

	 -- Put windows in a smart way, only if they does not set an initial position.
	 if not c.size_hints.user_position and not c.size_hints.program_position then
	    -- FXIME: this placement runs after the rules and as such
	    -- placement callbacks in the rules will be overruled if
	    -- this is active here.
	    -- awful.placement.no_overlap(c)
	    awful.placement.no_offscreen(c)
	 end
      end
   end)

-- Handle focus/unfocus
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
