{ pkgs, config, ... }:
let
  screenshot =
    let
      hyprland = config.wayland.windowManager.hyprland.finalPackage;
      hyprctl = "${hyprland}/bin/hyprctl";
      jq = "${pkgs.jq}/bin/jq";
      grim = "${pkgs.grim}/bin/grim";
      slurp = "${pkgs.slurp}/bin/slurp";
    in
    pkgs.writeScriptBin "screenshot" ''
      workspace=$(${hyprctl} activeworkspace -j | ${jq} '.id')

      ${hyprctl} clients -j |
      	${jq} '.[] | select(.workspace.id == '$workspace')' |
      	${jq} -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' |
      	${slurp} |
        ${grim} -g -
    '';
in
{
  imports = [
    ./ags
    ./avizo
    ./swayosd
  ];

  programs.jq.enable = true;

  home.packages = [ screenshot ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    settings = {
      exec-once = [
        "hyprctl setcursor Catppuccin-Macchiato-Dark-Cursors 32"
        "wluma"
      ];
      "$browser" = "firefox";
      "$mod" = "SUPER";
      "$terminal" = "kitty";

      env = [
        "XCURSOR_SIZE, 24"
        "QT_QPA_PLATFORMTHEME, qt5ct"
        "XDG_SESSION_TYPE, wayland"
        "WLR_NO_HARDWARE_CURSORS, 1"
      ];

      bind =
        [
          "$mod, B, exec, $browser"
          "$mod, Return, exec, $terminal"
          "$mod, Q, killactive,"
          "$mod SHIFT, Q, exit"
          "$mod, SPACE, togglefloating,"
          "$mod, F, fullscreen, 1"
          "$mod SHIFT, F, fullscreen,"

          ", XF86MonBrightnessUp, exec, lightctl up"
          ", XF86MonBrightnessDown, exec, lightctl down"

          ", XF86AudioRaiseVolume, exec, volumectl -u up"
          ", XF86AudioLowerVolume, exec, volumectl -u down"
          ", XF86AudioMute, exec, volumectl toggle-mute"
          ", XF86AudioMicMute, exec, volumectl -m toggle-mute"
        ]
        # Vi like keybindings
        ++ (
          let
            viMove = {
              l = "r";
              h = "l";
              j = "d";
              k = "u";
            };
          in
          builtins.concatMap (name: [
            "$mod, ${name}, movefocus, ${viMove.${name}}"
            "$mod SHIFT, ${name}, swapwindow, ${viMove.${name}}"
          ]) (builtins.attrNames viMove)
        )
        ++ builtins.concatLists (
          builtins.genList (
            x:
            let
              ws = if x > 0 then builtins.toString x else "10";
            in
            [
              "$mod, ${builtins.toString x}, workspace, ${ws}"
              "$mod SHIFT, ${builtins.toString x}, movetoworkspace, ${ws}"
            ]
          ) 10
        );

      input = {
        kb_layout = "us";
        kb_variant = "colemak_dh";
        touchpad.natural_scroll = true;
        follow_mouse = 1;
        sensitivity = 0;
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(e5b9c6ff) rgba(c293a3ff) 45deg";
        "col.inactive_border" = "0xff382D2E";
        no_border_on_floating = false;
        layout = "dwindle";
        no_cursor_warps = true;
        allow_tearing = false;
      };

      decoration = {
        rounding = 12;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };

        drop_shadow = false;
        shadow_ignore_window = true;
        shadow_offset = "1 2";
        shadow_range = 10;
        shadow_render_power = 5;
        "col.shadow" = "0x66404040";

        blurls = [
          "waybar"
          "locksrceen"
        ];
      };

      animations = {
        enabled = true;

        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];

        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      misc = {
        mouse_move_enables_dpms = true;
        vfr = true;
        vrr = 0;
        animate_manual_resizes = true;
        mouse_move_focuses_monitor = true;
        enable_swallow = true;
        swallow_regex = "^(org\.wezfurlong\.wezterm|kitty)$";
      };

      dwindle = {
        no_gaps_when_only = false;
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_is_master = true;
      };

      gestures = {
        workspace_swipe = false;
      };
    };
  };
}
