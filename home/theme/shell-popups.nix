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
  # Corners of elements inside an island (OSD level, dialog buttons and entries).
  inner = toString (island.radius - 6);
in
''
  /* Popups as islands: every shell menu (panel menus, quick settings, the
     calendar, dock and extension menus), OSDs, the app/window switcher,
     modal dialogs (polkit, run, end session), IME candidates and dock
     tooltips. popupFill is opaquer than the bar's: blur-my-shell can't blur
     behind popups, and text over a busy window needs it. */
  .popup-menu .popup-menu-content,
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

  /* Notification banners: island fill and corners but no border; they
     stack in a corner, and an outline on each one is noise. */
  .notification-banner {
    background-color: ${island.popupFill};
    border: none;
    border-radius: ${radius};
  }
  .notification-banner:hover,
  .notification-banner:focus,
  .notification-banner:active {
    background-color: ${rgba c.bgDark 0.98};
  }

  /* Orchis makes the OSD a pill; give it the island corners and keep its
     level bar inside them. */
  .osd-window .level {
    border-radius: ${inner}px;
  }

  /* Modal dialogs (keyring/GPG/polkit prompts, run, end session) as one
     island: Orchis paints the content box solid over the translucent fill
     (a box in a box), pads the buttons away from the edges as pills, and
     spaces sections 32px apart with an always-present empty error label.
     !important where Orchis uses it. */
  .modal-dialog {
    padding: 16px;
  }
  .modal-dialog .modal-dialog-content-box,
  .prompt-dialog .modal-dialog-content-box {
    background-color: transparent;
    margin: 8px 12px 20px;
    spacing: 16px;
  }
  .message-dialog-content .message-dialog-title {
    font-size: 14pt;
    font-weight: 700;
  }
  .prompt-dialog-error-label,
  .prompt-dialog-info-label,
  .prompt-dialog-null-label {
    font-size: 10pt;
  }
  .modal-dialog .modal-dialog-button-box {
    padding-top: 0;
    spacing: 8px;
  }
  .modal-dialog .modal-dialog-button {
    min-height: 36px;
    border-radius: ${inner}px;
    color: ${c.fg};
    background-color: ${rgba c.fg 0.08};
  }
  .modal-dialog .modal-dialog-button:hover {
    background-color: ${rgba c.fg 0.14};
  }
  /* Cancel is not destructive: Orchis colors it red. */
  .prompt-dialog .modal-dialog-button:first-child {
    color: ${c.fg};
  }
  .prompt-dialog .modal-dialog-button:last-child {
    color: ${c.bgDark} !important;
    background-color: ${c.blue};
  }
  .prompt-dialog .modal-dialog-button:last-child:hover {
    background-color: ${c.cyan};
  }
  /* Entries: a quiet field with a thin accent outline on focus, instead of
     a shadowed pill with a 2px ring. */
  .modal-dialog StEntry {
    border-radius: ${inner}px;
    background-color: ${rgba c.bgHighlight 0.9};
    border: 1px solid ${rgba c.fg 0.12} !important;
    box-shadow: none !important;
  }
  .modal-dialog StEntry:hover {
    box-shadow: none !important;
  }
  .modal-dialog StEntry:focus {
    border: 1px solid ${c.blue} !important;
    box-shadow: none !important;
  }
''
