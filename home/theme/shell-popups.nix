# GNOME Shell popups styled as islands like the top bar and dock: one fill,
# border and corner radius on every floating surface. Plain CSS (no wrapper
# theme around it) so it is shared by the session's user theme (gnome.nix) and
# the GDM login theme (system.nix).
{ palette, island }:
let
  c = palette.colors;
  inherit (palette) rgba;
  border = "${toString island.borderWidth}px solid ${island.border}";
  radius = "${toString island.radius}px";
in
''
  /* Popups as islands: every shell menu (panel menus, quick settings, the
     calendar, dock and extension menus), notification banners, OSDs, the
     app/window switcher, modal dialogs (polkit, run, end session), IME
     candidates and dock tooltips. popupFill is opaquer than the bar's:
     blur-my-shell can't blur behind popups, and text over a busy window needs
     it. */
  .popup-menu .popup-menu-content,
  .notification-banner,
  .osd-window,
  .osd-monitor-label,
  .switcher-list,
  .resize-popup,
  .workspace-switcher-container,
  .modal-dialog,
  .candidate-popup-content,
  .dash-label {
    background-color: ${island.popupFill};
    border: ${border};
    border-radius: ${radius};
  }

  /* Orchis pins these two menus' radius with !important (38px / 28px). */
  .quick-settings,
  .datemenu-popover {
    border-radius: ${radius} !important;
  }

  .notification-banner:hover,
  .notification-banner:focus,
  .notification-banner:active {
    background-color: ${rgba c.bgDark 0.98};
  }

  /* Orchis makes the OSD a pill; give it the island corners and keep its
     level bar inside them. */
  .osd-window .level {
    border-radius: ${toString (island.radius - 6)}px;
  }
''
