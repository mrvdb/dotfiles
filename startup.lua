-- Usually at the end of awesome config, a set of startup applications
-- need to be called. They have been gathered here.

require("lfs")
-- {{{ Run programm once
local function processwalker()
   local function yieldprocess()
      for dir in lfs.dir("/proc") do
        -- All directories in /proc containing a number, represent a process
        if tonumber(dir) ~= nil then
          local f, err = io.open("/proc/"..dir.."/cmdline")
          if f then
            local cmdline = f:read("*all")
            f:close()
            if cmdline ~= "" then
              coroutine.yield(cmdline)
            end
          end
        end
      end
    end
    return coroutine.wrap(yieldprocess)
end

local function run_once(process, cmd)
   assert(type(process) == "string")
   local regex_killer = {
      ["+"]  = "%+", ["-"] = "%-",
      ["*"]  = "%*", ["?"]  = "%?" }

   for p in processwalker() do
      if p:find(process:gsub("[-+?*]", regex_killer)) then
	 return
      end
   end
   return awful.util.spawn(cmd or process)
end

-- Start a few programs to make our life easier

-- Starting gnome-settings-daemon should not be necessary (see
-- awesome wiki page on this)
-- We still start it for the following reasons:
-- 1. The theme-ing is easier to manager and in sync with the "normal" gnome session;
-- 4. Handling the display settings with gnome control center is very comfy
-- run_once("gnome-settings-daemon")

run_once("xscreensaver","xscreensaver -nosplash")               -- xscreensaver, could use a better dialog
run_once("nm-applet")	                                        -- Network applet is a whole lot easier than doing by hand
-- run_once("wpa_gui", "wpa_gui -t")                            -- WPA wireless lan managing when we're playing with the bonding stuff
run_once("blueman-applet")					-- Not really needed apart from signalling if it's there
run_once("gnome-sound-applet")                                  -- Volume indicator mostly.
run_once("system-config-printer-applet")			-- Printer is otherwise hard to reach
run_once("caffeine")                                            -- Prevent screensaver to run is certain programs are active (vlc, youtube etc.)
run_once("gmpc","gmpc -h")                                      -- Media player to connect to an MPD installation
run_once("krb5-auth-dialog")                                    -- Kerberos authentication applet
run_once("/usr/lib/btsync-user/btsync-starter")                 -- Bittorrent sync, used for syncing files with mobile
