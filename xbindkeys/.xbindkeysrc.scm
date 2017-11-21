;; This document was written with the external keyboard of a thinkpad
;; The key assignments are keyboard dependent; over time I will mark
;; each note for which keyboard that was written, so the text is not
;; terribly confusing.

;; This is roughly taken from the xmodmap output
;; Mod1 : left alt key
;; Mod2 : numlock
;; Mod3 : ?
;; Mod4 : windows key (left) and menu key (right)
;; Mod5 : right alt key
;;
;; Function key assignments and their functionality as handled by the firmware
;; Most taken from kernel/Documentations/laptops/thinkpad-acpi.txt
;;
;; Fn-F1   : nothing, not detected
;; Fn-F2   : lock screen
(xbindkey '(XF86ScreenSaver) "xtrlock")     ; Internal keyboard

;; Fn-F3   : battery (yeah, what about it?) (XF86Battery)
;; Fn-F4   : suspend to ram                   ; Internal keyboard (handled by firmware)
(xbindkey '(XF86LaunchB)  "suspend-or-hibernate")  ; External Apple keyboard
(xbindkey '(XF86Sleep)    "suspend-or-hibernate")  ; Thinkpad keyboards (both internal and external)
(xbindkey '(XF86PowerOff) "suspend-or-hibernate")  ; Power key on HHKB keyboard gives this

;; Fn-F5   : turn off all radios (duplicates the hardware switch?) (XF86WLAN)
;; Fn-F6   : Now used to toggle bluetooth (XF86webcam)
(xbindkey '(Mod5 F6) "/etc/acpi/togglebluetooth.sh")

;; Fn-F7   : cycle through display modes on all monitors (requires acpi trickery!!)
;;(xbindkey '(XF86Display) "disper --cycle-stages='-S:-s' --cycle")

;; Fn-F8   : toggle screen-expand / ultranav (XF86TouchpadjjToggle)
;; Fn-F9   : nothing, not detected
;; Fn-F10  : nothing, not detected
;; Fn-F11  : nothing, not detected
;; Fn-F12  : suspend to disk on internal keyboard
;; Fn-Home : brightness up    (XF86MonBrightnessUp)
;; Fn-End  : brightness down  (XF86MonBrightnessDown)
;; Fn-PgUp : thinklight toggle, handled by firmware, not on external kbd
;; Fn-Space: zoom key (not sure what that actually does)

;; XF86Launch1 : Thinkvantage key

;; Volume / muting
;; Local speakers
;; TODO: can we make the mute a toggle
;; NOTE: make sure that the .asoundrc file has the proper default card
(xbindkey '(XF86AudioMute) "amixer set Master toggle")
(xbindkey '(XF86AudioRaiseVolume) "amixer set Master 1%+ unmute")
(xbindkey '(XF86AudioLowerVolume) "amixer set Master 1%- unmute")

;; Volume of whatever mpc is connected to (mostly the speakers in the office)
;; TODO: can we make the mute a toggle?
(xbindkey '(Shift XF86AudioMute)  "mpc volume 0")
(xbindkey '(Shift XF86AudioRaiseVolume) "mpc volume +1")
(xbindkey '(Shift XF86AudioLowerVolume) "mpc volume -1")
(xbindkey '(XF86AudioPlay) "mpc toggle")
(xbindkey '(XF86AudioStop) "mpc stop")


;; These keys are captured, but do not work with modifiers (because they only are available with Fn modifier)
;; So, we have just one set which we can control (local or mpc client) unless we make a toggle to activate
;; one or the other. Either way, we'll have to script it then.
;;XF86AudioNext
;;XF86AudioPrev
;;XF86AudioStoph
;;XF86AudioPlay

;; Shortcuts to start programs all have just Mod4
;; run dialog
(xbindkey '(Mod4 r)      "rofi -show run")
;; editor
(xbindkey '(Mod4 e)      "edit")
;; mail
(xbindkey '(Mod4 m)      "startmail")
;; browser
(xbindkey '(Mod4 b)      "xdg-open about:blank")
;; calculator
(xbindkey '(Mod4 l)      "calc")
;; terminal
(xbindkey '(Mod4 Return) "xterm")
;; file manager
(xbindkey '(Mod4 y)      "pcmanfm --no-desktop")
;; telegram
(xbindkey '(Mod4 t)      "telegram")

;; Capture like windows always involve space-bar
;; Exceptions:
;; Ctrl Mod4 space: awesome toggle floating  (could be changed I guess)
;; Ctrl Space:     emacs set the mark       (probably keep it that way)
(xbindkey '(Control Shift space) "capture-todo.sh")
(xbindkey '(Control Alt   space) "capture-buy.sh" )
(xbindkey '(Alt Shift space)     "capture-tweet.sh")

;; Global new mail
;; FIXME: this hides some Emacs shortcuts ending in Ctrl-M
;; TODO: make this into a floating emacs window, with the same funtion like C-x m does now.
;;(xbindkey '(Control m) "claws-mail --compose")
;; Once I am ready comment the previous line and uncomment the next
;;(xbindkey '(Control m) "capture-mail.sh")

;; Poor man's keyboard variant switching, this is the only way i got to work properly
(xbindkey '(Control Mod4 bracketright ) "~/bin/togglekblayout")

;; Screenshots
(xbindkey '(Release Print) "~/bin/scrshot --select --border")

;; Password helper
(xbindkey '(Control Mod4 p) "passmenu --type")

;; Window switcher (should this be a shortcut in i3?)
(xbindkey '(Control Mod4 w) "rofi -show window")
