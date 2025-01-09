{ lib
, ...
}:
{
  home.activation.gsettings = lib.mkAfter ''
    echo "[gsettings] starting system configuration"

    # Extension schemas
    echo "[gsettings] setting up gnome-extensions schemas"
    /usr/bin/rm -rf ~/.local/share/glib-2.0/schemas
    /usr/bin/mkdir -p ~/.local/share/glib-2.0/schemas
    for x in $(/usr/bin/find ~/.local/share/gnome-shell/extensions -type f -name \*.gschema.xml); do
      /usr/bin/ln -sf $x ~/.local/share/glib-2.0/schemas/
    done
    /usr/bin/glib-compile-schemas ~/.local/share/glib-2.0/schemas

    # Cleanup
    echo "[gsettings] cleaning up unused keys"
    /usr/bin/gsettings set org.gnome.mutter overlay-key ""
    /usr/bin/gsettings set org.gnome.mutter.keybindings cancel-input-capture "[]"
    /usr/bin/gsettings set org.gnome.shell.keybindings shift-overview-up "[]"
    /usr/bin/gsettings set org.gnome.shell.keybindings toggle-quick-settings "[]"
    /usr/bin/gsettings set org.gnome.shell.keybindings focus-active-notification "[]"
    /usr/bin/gsettings set org.freedesktop.ibus.general.hotkey triggers "[]"
    /usr/bin/gsettings set org.freedesktop.ibus.panel.emoji hotkey "[]"
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.media-keys help "[]"
    for x in {1..9}; do
        /usr/bin/gsettings set org.gnome.shell.keybindings switch-to-application-$x "[]"
        /usr/bin/gsettings set org.gnome.shell.keybindings open-new-window-application-$x "[]"
        /usr/bin/gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$x "[]"
    done

    # Gnome general
    echo "[gsettings] setting up gnome interface"
    /usr/bin/gsettings set org.gnome.shell.extensions.user-theme name "Tokyonight-Grey-Dark-Storm"
    /usr/bin/gsettings set org.gnome.desktop.interface gtk-theme "Tokyonight-Grey-Dark-Storm"
    /usr/bin/gsettings set org.gnome.desktop.interface icon-theme "Suru++"
    /usr/bin/gsettings set org.gnome.desktop.interface clock-show-seconds true
    /usr/bin/gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.homesick/repos/dotfiles/wallpapers/unsplash.jpg"
    /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/.homesick/repos/dotfiles/wallpapers/unsplash.jpg"
    /usr/bin/gsettings set org.gnome.desktop.screensaver picture-uri "file://$HOME/.homesick/repos/dotfiles/wallpapers/unsplash.jpg"
    /usr/bin/gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "<Super>"
    /usr/bin/gsettings set org.gnome.desktop.wm.preferences focus-mode "mouse"
    /usr/bin/gsettings set org.gnome.desktop.wm.preferences auto-raise true
    /usr/bin/gsettings set org.gnome.desktop.wm.preferences theme "Tokyonight-Grey-Dark-Storm"
    /usr/bin/gsettings set org.gnome.desktop.wm.preferences workspace-names "['terminal', 'firefox', 'outlook', 'teams', 'spotify']"
    /usr/bin/gsettings set org.gnome.desktop.wm.preferences num-workspaces 8
    /usr/bin/gsettings set org.gnome.mutter workspaces-only-on-primary true
    /usr/bin/gsettings set org.gnome.mutter focus-change-on-pointer-rest false
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 240
    /usr/bin/gsettings set org.gnome.desktop.default-applications.terminal exec "$HOME/.bin/kitty"
    /usr/bin/gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-e"
    /usr/bin/gsettings set org.gnome.desktop.peripherals.keyboard repeat true
    /usr/bin/gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 14
    /usr/bin/gsettings set org.gnome.desktop.peripherals.keyboard delay 230
    /usr/bin/gsettings set org.gnome.desktop.sound event-sounds false
    /usr/bin/gsettings set org.gnome.desktop.sound input-feedback-sounds false
    /usr/bin/gsettings set org.gnome.desktop.sound theme-name "Yaru"
    /usr/bin/gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false
    /usr/bin/gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled false
    /usr/bin/gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
    /usr/bin/gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
    /usr/bin/gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false

    # Text scaling
    # ~/.bin/monitor-switch

    # Gnome keybindings
    echo "[gsettings] setting up gnome keybindings"
    /usr/bin/gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>Space']"
    /usr/bin/gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super><Alt>Space']"
    /usr/bin/gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Alt><Super>n']"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super><Alt>comma']"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super><Alt>f']"
    /usr/bin/gsettings set org.gnome.mutter.keybindings switch-monitor "['<Super><Alt>d','XF86Display']"
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super><Alt>l']"
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>Return']"

    # Focus workspaces
    echo "[gsettings] setting up custom workspace focus"
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom9/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom10/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom11/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom12/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom13/']"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Super>Escape'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'$HOME/.bin/focus-switch 0'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Switch focus to workspace 1'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'<Super>F2'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'$HOME/.bin/focus-switch 1'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'Switch focus to workspace 2'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/binding "'<Super>F1'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/command "'$HOME/.bin/focus-switch 2'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/name "'Switch focus to workspace 3'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/binding "'<Super>F3'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/command "'$HOME/.bin/focus-switch 3'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/name "'Switch focus to workspace 4'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/binding "'<Super>1'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/command "'$HOME/.bin/focus-switch 4'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/name "'Switch focus to workspace 5'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/binding "'<Super>2'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/command "'$HOME/.bin/focus-switch 5'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/name "'Switch focus to workspace 6'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/binding "'<Super>3'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/command "'$HOME/.bin/focus-switch 6'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/name "'Switch focus to workspace 7'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/binding "'<Super>4'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/command "'$HOME/.bin/focus-switch 7'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/name "'Switch focus to workspace 8'"

    # Move window to workspace
    echo "[gsettings] setting up moving windows to workspaces"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>Escape']"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>F2']"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>F1']"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>F3']"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>1']"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>2']"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>3']"
    /usr/bin/gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>4']"

    # Pop! Shell
    echo "[gsettings] setting up pop-shell"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell activate-launcher "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-down "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-left "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-right "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-up "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell pop-workspace-down "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell pop-workspace-up "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell active-hint true
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell active-hint-border-radius 12
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell hint-color-rgba "rgb(233,233,237)"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-enter "['<Super>Backspace']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-accept "['Return']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-reject "['Escape']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-orientation "['<Super><Alt>o']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell toggle-tiling "['<Super><Alt>y']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell toggle-stacking-global "['<Super><Alt>s']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-move-down "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-move-left "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-move-right "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-move-up "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-swap-down "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-swap-left "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-swap-right "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-swap-up "[]"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-resize-down "['Down']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-resize-left "['Left']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-resize-right "['Right']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-resize-up "['Up']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-move-down-global "['<Super><Alt>Down']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-move-left-global "['<Super><Alt>Left']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-move-right-global "['<Super><Alt>Right']"
    /usr/bin/gsettings set org.gnome.shell.extensions.pop-shell tile-move-up-global "['<Super><Alt>Up']"

    # Custom keybinds
    echo "[gsettings] setting up custom keybindings"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8/binding "'<Ctrl>space'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8/command "'nautilus'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8/name "'Open nautilus file manager'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom9/binding "'<Super><Alt>e'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom9/command "'gnome-session-quit'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom9/name "'Quite Gnome session'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom10/binding "'<Super><Alt>m'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom10/command "'$HOME/.bin/clean-notifications'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom10/name "'Clean all notifications'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom11/binding "'<Super><Alt>p'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom11/command "'/usr/bin/1password --quick-access'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom11/name "'Open 1password quick access'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom12/binding "'<Super><Alt>k'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom12/command "'systemctl suspend'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom12/name "'Suspend system'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom13/binding "'<Super><Alt>r'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom13/command "'$HOME/.bin/focus-switch rebalance'"
    /usr/bin/dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom13/name "'Rebalance windows'"

    # Power
    echo "[gsettings] setting up power management"
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 240
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power idle-dim true
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action "suspend"
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action "suspend"
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power lid-close-suspend-with-external-monitor false
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power power-button-action "nothing"
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery true
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "suspend"
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
    /usr/bin/gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type "suspend"

    echo "[gsettings] configuration applied successfully"
  '';
}
