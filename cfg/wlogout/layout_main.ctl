{
    "label" : "lock",
    "action" : "systemctl suspend && swaylock",
    "text" : "Lock",
    "keybind" : "l"
}

{
    "label" : "logout",
    "action" : "hyprctl dispatch exit 0",
    "text" : "Logout",
    "keybind" : "e"
}

{
    "label" : "suspend",
    "action" : "systemctl suspend",
    "text" : "Suspend",
    "keybind" : "u"
}

{
    "label" : "shutdown",
    "action" : "systemctl poweroff",
    "text" : "Shutdown",
    "keybind" : "s"
}

{
    "label" : "reboot",
    "action" : "systemctl reboot",
    "text" : "Reboot",
    "keybind" : "r"
}

{
    "label" : "reboot-win",
    "action" : "systemctl reboot --boot-loader-entry=auto-windows",
    "text" : "Reboot (win)",
    "keybind" : "w"
}

{
    "label" : "hibernate",
    "action" : "systemctl hibernate",
    "text" : "Hibernate",
    "keybind" : "h"
}
