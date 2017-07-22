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

-- Some convenience constants for the tags I give to workspaces
local default = 1
local web     = 2
local edit    = 3
local system  = 4
local mail    = 5
local contact = 6
local media   = 7

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
   { rule = { class = "Claws-mail" },       callback = function(c) c:tags({tags[1][mail]}) end},
   { rule = { class = "Google-chrome" },    callback = function(c) c:tags({tags[1][default],tags[1][web]}) end},
   { rule = { class = "Chrome-browser" },   callback = function(c) c:tags({tags[1][default],tags[1][web]}) end},
   { rule = { class = "Iceweasel" },        callback = function(c) c:tags({tags[1][default],tags[1][web]}) end},
   -- Seems newer chrome put this in their class
   { rule = { class = "Google-chrome-beta" },    callback = function(c) c:tags({tags[1][default],tags[1][web]}) end},
   { rule = { class = "X-www-browser" },    callback = function(c) c:tags({tags[1][default],tags[1][web]}) end},
   { rule = { class = "Firefox" },    callback = function(c) c:tags({tags[1][default],tags[1][web]}) end},   
   { rule = { class = "Emacs" },            callback = function(c) c:tags({tags[1][default],tags[1][edit]}) end},
   { rule = { class = "Openerp-client.py"}, callback = function(c) c:tags({tags[1][contact]}) end},
   { rule = { class = "Virt-viewer"}, callback = function(c) c:tags({tags[1][system]}) end},


   -- Floating applications
   { rule_any = {class = { "MPlayer", "Gimp", "Psi-plus", "psi", "Remmina", "Virt-viewer"} },
        properties = { floating = true }
   },

   -- Centered floating applications which stay on top
   { rule_any = {class = {
                    "Bitcoin", "Vlc", "Pinentry", "Gmpc", "mpv",
                    "Gtk-recordmydesktop", "Wpa_gui", "Gnuplot",
                    "Arandr", "Linphone", "Pavucontrol", "coriander", "Coriander",
                    "Gpicview", "Caffeine", "ArmoryQt.py", "Wicd-client.py", "Popcorn-Time"}},
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
     properties = { floating = true, ontop =true },
     callback = place_on_all_tags
   },

   -- Emacs windows which I want to have floating on top and centered:
   -- * capture windows
   -- * dent creation
   -- * mail composition
   -- * edit with emacs window (textarea link to emacs)
   -- all have the 'Emacs' class, but different instances
   -- The matching uses the Lua string.match() function
   { rule_any = { instance   = { "twister", "capture", "dent", "pump", "mailcompose", "unsent mail", "Edit_with_Emacs_FRAME" }  },
     properties  = { floating = true, ontop = true},
     callback = awful.placement.centered
   },
   -- ... and appear on every tag
   { rule_any = { instance   = { "twister", "capture", "dent", "pump", "mailcompose", "unsent mail", "Edit_with_Emacs_FRAME" } },
     callback = place_on_all_tags
   },

   -- Dialog boxes with important messages that should never be hidden
   -- below another window or a tag screen
   { rule_any = { name = { "Discard message" } },
     properties = { ontop = true },
     callback = place_on_all_tags
   },
   

   -- Experimental builds of popcorn have no class???
   {  rule = { name = "Popcorn Time" },
      properties = { ontop = true, floating = true },
   },


   -- Dia has toolboxes, make sure they float
   -- Size can still be very odd?
   { rule = { role = "toolbox_window" },
     properties = { floating = true }
   },

   -- I can't get the bt747 to match on its class, so we do it by name
   -- We place it centered as that seems to have a positive
   -- side-effect that the menu focus is proper
   { rule = { name = "BT747 Application V2.1.3" },
     properties = { floating = true },
     callback = awful.placement.centered
   }
}