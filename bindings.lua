--
-- Key binding configuration for awesome
--
-- The intent is to configure keybinding for the window manager *only* here
--
-- Rules:
--  - All keys have ⌘ as modifier for window manager operations
--  - The ⌘ modifier is forbidden for application level shortcuts

-- Keynames
Shift= "Shift"
Ctrl = "Control"
Alt  = "Mod1"
Cmd  = "Mod4"

-- Button numbers
LeftButton  = 1
RightButton = 3
ScrollUp    = 4
ScrollDown  = 5

-- Keys, global scope
globalkeys = awful.util.table.join(
   -- Client manipulation
   -- ⌘ → : next client
   awful.key({Cmd,}, "Right",
   	     function ()
   		awful.client.focus.byidx( 1)
   		if client.focus then client.focus:raise() end
   	     end),
   -- awful.key({Cmd,}, "u",
   -- 	     function ()
   -- 		awful.client.focus.byidx( 1)
   -- 		if client.focus then client.focus:raise() end
   -- 	     end),

   -- -- ⌘ ← previous client
   awful.key({ Cmd,}, "Left",
   	     function ()
   		awful.client.focus.byidx(-1)
   		if client.focus then client.focus:raise() end
   	     end),
   awful.key({ Cmd,}, "Tab",
	     function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	     end),
   awful.key({ Alt, }, "Escape",
	     function ()
		-- If you want to always position the menu on the same place set coordinates
		awful.menu.menu_keys.down = { "Down", "Alt_L" }
		local cmenu = awful.menu.clients({width=245}, { keygrabber=true, coords={x=525, y=330} })
	     end),

   -- Ctrl-⌘- ← : filters clients to the previous tag in the list
   awful.key({ Cmd, Ctrl }, "Left",   awful.tag.viewprev       ),
   awful.key({ Cmd, Ctrl }, "u",   awful.tag.viewprev       ),
   -- Ctrl-⌘ →  :filters clients to the next tag in the list
   awful.key({ Cmd, Ctrl }, "Right",  awful.tag.viewnext       ),
   awful.key({ Cmd, Ctrl }, "i",  awful.tag.viewnext       ),
   -- ⌘-Esc history restore? (switch back and forth between last view?)
   awful.key({ Cmd,           }, "Escape", awful.tag.history.restore),
   -- Control ⌘ w shows the main menu
   awful.key({ Cmd, Ctrl   }, "w", function () mymainmenu:show({keygrabber=true}) end),

   -- Layout manipulation
   awful.key({ Cmd, Shift   }, "j", function () awful.client.swap.byidx(  1)    end),
   awful.key({ Cmd, Shift   }, "k", function () awful.client.swap.byidx( -1)    end),
   awful.key({ Cmd, Ctrl    }, "j", function () awful.screen.focus_relative( 1) end),
   awful.key({ Cmd, Ctrl    }, "k", function () awful.screen.focus_relative(-1) end),
   awful.key({ Cmd,         }, "u", awful.client.urgent.jumpto),
   -- awful.key({ Cmd,         }, "Tab",
   -- 	     function ()
   -- 		awful.client.focus.history.previous()
   -- 		if client.focus then
   -- 		   client.focus:raise()
   -- 		end
   -- 	     end),

   awful.key({ Cmd, Ctrl      }, "r", awesome.restart),
   awful.key({ Cmd, Shift     }, "q", awesome.quit),
   awful.key({ Ctrl, Alt      }, "Delete", awesome.quit),

   awful.key({ Cmd,           }, "l",     function () awful.tag.incmwfact( 0.02)    end),
   awful.key({ Cmd,           }, "h",     function () awful.tag.incmwfact(-0.02)    end),

   -- FIXME: we need to be able to detect if windows are at top or at
   -- bottom, or change shortcut, otherwise it gets confusing. The
   -- interpretation is more along the lines of bigger and smaller
   -- portion, not higher and lower. For the Right and Left keys, it seems to work out fine.
   -- awful.key({ Cmd, Shift     }, "Right",     function () awful.tag.incmwfact( 0.02)    end),
   -- awful.key({ Cmd, Shift     }, "Left",     function () awful.tag.incmwfact(-0.02)    end),
   -- awful.key({ Cmd, Shift     }, "Up",    function () awful.client.incwfact(0.02)   end),
   -- awful.key({ Cmd, Shift     }, "Down",  function () awful.client.incwfact(-0.02) end),

   awful.key({ Cmd, Shift     }, "h",     function () awful.tag.incnmaster( 1)      end),
   awful.key({ Cmd, Shift     }, "l",     function () awful.tag.incnmaster(-1)      end),
   awful.key({ Cmd, Ctrl      }, "h",     function () awful.tag.incncol( 1)         end),
   awful.key({ Cmd, Ctrl      }, "l",     function () awful.tag.incncol(-1)         end),
   awful.key({ Cmd,           }, "space", function () awful.layout.inc(layouts,  1) end),
   awful.key({ Cmd, Shift     }, "space", function () awful.layout.inc(layouts, -1) end),

   -- Prompts
   awful.key({ Cmd            }, "r",     function () mypromptbox[mouse.screen]:run() end),

   awful.key({ Cmd, Shift }, "x",
	     function ()
		awful.prompt.run({ prompt = "Run Lua code: " },
				 mypromptbox[mouse.screen].widget,
				 awful.util.eval, nil,
				 awful.util.getdir("cache") .. "/history_eval")
	     end)
)

-- Keys: client scope
clientkeys = awful.util.table.join(
   awful.key({ Cmd,       }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ Cmd,       }, "w",      function (c) c:kill()                         end),
   awful.key({ Cmd, Ctrl  }, "space",  awful.client.floating.toggle                     ),
   awful.key({ Cmd, Ctrl  }, "Return", function (c) c:swap(awful.client.getmaster()) end),
   awful.key({ Cmd, Shift }, "r",      function (c) c:redraw()                       end),
   awful.key({ Cmd,       }, "t",      function (c) c.ontop = not c.ontop            end),
   awful.key({ Cmd, Shift }, "m",
	     function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	     end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ Cmd }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ Cmd, Ctrl }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ Cmd, Shift }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ Cmd, Ctrl, Shift }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

-- Set keys for the root to the globalkeys as configured above
root.keys(globalkeys)


-- Button bindings

clientbuttons = awful.util.table.join(
    awful.button({ },     LeftButton,  function (c) client.focus = c; c:raise() end),
    awful.button({ Cmd }, LeftButton,  awful.mouse.client.move),
    awful.button({ Cmd }, RightButton, awful.mouse.client.resize))

root.buttons(
   awful.util.table.join(
      -- Right click toggles the main aw menu
      awful.button({ }, RightButton, function () mymainmenu:toggle() end),
      -- Button 4 filters clients to the next tag in the list
      awful.button({ }, ScrollUp, awful.tag.viewnext),
      -- Button 5 filters clients to the previous tag in the list
      awful.button({ }, ScrollDown, awful.tag.viewprev)
))
