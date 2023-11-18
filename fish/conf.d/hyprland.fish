# If running from tty1 start Hyprland
set TTY1 (tty)
[ "$TTY1" = "/dev/tty1" ] && exec Hyprland
