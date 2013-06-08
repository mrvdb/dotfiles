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

-- Start a few programs to make our life easier We do not use dex -a
-- because that starts a bit too much, but in theory that is what we
-- should do if we want to have everything around that gnome does in
-- the other session which is ubuntu's default.
-- I don't want that because the whole point is to be more in control
-- and have a leaner setup where possible.

-- TODO Starting gnome-settings-daemon should not be necessary (see
-- awesome wiki page on this)
-- We still start it for the following reasons:
-- 1. The theme-ing is easier to manager and in sync with the "normal" gnome session;
-- → DONE: now using lxappearance to control appearance settings
-- → DONE: gnome-color-chooser has even more
-- 2. Configured keyboard shortcuts in gnome won't work
-- otherwise. (TODO: move them to a lower level? *sigh*)
--    Q: can this be done with autokey which we are running for other reasons anyways
--    A: yes
-- → OPTION:using autokey for the global shortcuts ---> BUGGY, not suitable
-- 3. Some Fn keys are apparently handled by gnome-settings-daemon

-- I basically want the functionality of gnome-power manager
-- 1. Suspend the machine after some idle time
-- run_once("gnome-power-manager")

-- xbindkeys 
-- TODO: this should be done automatically, but I have an environment issue.
run_once("xbindkeys")

-- Applets
run_once("nm-applet")			-- Network applet is a whole lot easier than doing by hand
--run_once("wpa_gui", "wpa_gui -t")               -- WPA wireless lan managing when we're playing with the bonding stuff
run_once("bluetooth-applet")			-- Not really needed apart from signalling if it's there
run_once("system-config-printer-applet")	-- Printer is otherwise hard to reach
run_once("pyinputstats")			-- Keeping some stats about mouse mileage and keyclicks

-- Apps which have systray icons and should be run at startup
-- commented it out because I'm not using it anymore
-- run_once("shutter","shutter --min_at_startup")

-- FIXME: since upgrading to quantal, autokey does not work anymore
-- run_once("autokey-gtk","/usr/bin/python /usr/bin/autokey-gtk")

-- A less than braindead program to prevent the screensaver from running semi-automatically
run_once("caffeine")

-- Media player to connect to an MPD installation
run_once("gmpc","gmpc -h")

-- Kerberos authentication applet
run_once("krb5-auth-dialog")

-- This converts GConf th GSettings data, not sure if we need this,
-- but it is no daemon and it only runs on startup, so I don't really care
run_once("gsettings-data-convert")

-- TODO: specify here what this does, exactly
-- It is about disk insertion
run_once("gdu-notification-daemon","/usr/lib/gnome-disk-utility/gdu-notification-daemon")

-- TODO: check if this is needed
run_once("start-pulseaudio-x11")

-- TODO: This was not in gnome, do I need this?
run_once("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")


