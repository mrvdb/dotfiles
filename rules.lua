--
-- Awesome client rules
--
-- Notes:
-- - matching is case sensitive, use xprop to find out the
--   details on a window
-- - if the resulting matchlist contain the same
--   windows and set the same properties the last one gets applied

-- Helper functions
function place_on_all_tags(client, parent)
   client:tags({tags[1][1],tags[1][2],tags[1][3],tags[1][4],tags[1][5]})
end

-- Specify rules for generic to more specific.
awful.rules.rules = {
   -- All clients will match this rule, so these are the global settings.
   { rule = { },
     properties = {
	size_hints_honor = false, -- This removes gaps between windows
	border_width = beautiful.border_width,
	border_color = beautiful.border_normal,
	focus = true,
	keys = clientkeys,
	buttons = clientbuttons
     }
   },

   -- Application to Tag placement
   { rule = { class = "Claws-mail" },       callback = function(c) c:tags({tags[1][5]}) end},
   { rule = { class = "Google-chrome" },    callback = function(c) c:tags({tags[1][1],tags[1][2]}) end},
   { rule = { class = "Chromium-browser" }, callback = function(c) c:tags({tags[1][1],tags[1][2]}) end},
   -- Seems newer chrome put this in their class
   { rule = { class = "X-www-browser" },    callback = function(c) c:tags({tags[1][1],tags[1][2]}) end},
   { rule = { class = "Emacs" },            callback = function(c) c:tags({tags[1][1],tags[1][3]}) end},
   { rule = { class = "Openerp-client.py"}, callback = function(c) c:tags({tags[1][6]}) end},


   -- Floating applications
   { rule_any = {class = { "MPlayer", "Gimp", "Psi-plus", "psi", "Remmina"} },
        properties = { floating = true }
   },

   -- Centered floating applications which stay on top
   { rule_any = {class = {
		    "Bitcoin", "Totem", "pinentry", "Krb5-auth-dialog", "Gmpc",
		    "Gtk-recordmydesktop", "Wpa_gui", "Gnuplot",
		    "Arandr", "Linphone", "Pavucontrol", "coriander", "Coriander", "Assword","Gpicview"}},
        properties = { floating = true, ontop = true },
   	callback   = awful.placement.centered
   },

   -- Mail compose window is identified by its role property, make it
   -- centralized and floating, but not on top or it will hide the
   -- pinentry window
   { rule = { role = "compose" },
     properties = { floating = true},
     callback = awful.placement.centered
   },

   -- Any window that has the pop-up role should be a pop-up, meaning
   -- floating and be made sure I see it so to be place on all tags
   { rule = { role = "pop-up" },
     properties = { floating = true, ontop = true },
     callback = place_on_all_tags
   },

   -- Claws-mail in its own workspace, but compose on any screen
   { rule = { role = "compose" },
     callback = place_on_all_tags
   },

   -- Emacs windows which I want to have floating on top and centered:
   -- * capture windows
   -- * dent creation
   -- * mail composition
   -- all have the 'Emacs' class, but different instances
   -- The matching uses the Lua string.match() function
   { rule_any = { instance   = { "capture", "dent", "pump", "mailcompose", "unsent mail" }  },
     properties  = { floating = true, ontop = true},
     callback = awful.placement.centered
   },
   -- ... and appear on every tag
   { rule_any = { instance   = { "capture", "dent", "pump", "mailcompose", "unsent mail" } },
     callback = place_on_all_tags
   }
}
