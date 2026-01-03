{ ... }:
{
  programs = {
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          position = "top";
          layer = "top";
          height = 35;
          margin-top = 0;
          margin-bottom = 0;
          margin-left = 0;
          margin-right = 0;
          exclusive = true;
          passthrough = false;

          modules-left = [
            "custom/notification"
            "clock"
          ];
          modules-center = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "pulseaudio"
            "network"
            "custom/power"
          ];

          "hyprland/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = true;
            "active-only" = false;
            "on-click" = "activate";
            "format" = "{icon}";
            "format-icons" = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
            };
            "persistent-workspaces" = {
              "*" = 5;
            };
          };

          "clock" = {
            "interval" = 60;
            "format" = "  {:%I:%M %p}";
            "max-length" = 25;
          };
          "pulseaudio" = {
            "format" = "{icon}  {volume}%";
            "format-bluetooth" = "{volume}% {icon}";
            "format-bluetooth-muted" = " {icon}";
            "format-muted" = "";
            "format-source" = "{volume}% ";
            "format-source-muted" = "";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [
                ""
                ""
                ""
              ];
            };
            "on-click" = "pavucontrol";
          };

          "custom/notification" = {
            "tooltip" = true;
            "format" = "{icon}";
            "format-icons" = {
              "notification" = "";
              "none" = "";
              "dnd-notification" = "";
              "dnd-none" = "";
              "inhibited-notification" = "";
              "inhibited-none" = "";
              "dnd-inhibited-notification" = "";
              "dnd-inhibited-none" = "";
            };
            "return-type" = "json";
            "exec-if" = "which swaync-client";
            "exec" = "swaync-client -swb";
            "on-click" = "swaync-client -t -sw";
            "on-click-right" = "swaync-client -d -sw";
            "escape" = true;
          };

          "network" = {
            "format-wifi" = "  Network";
            "format-ethernet" = "{ipaddr}/{cidr} ";
            "tooltip-format" = "{ifname} via {gwaddr} ";
            "format-linked" = "{ifname} (No IP) ";
            "format-disconnected" = "Disconnected ⚠";
            "format-alt" = "  Network";
            "on-click" = "nm-connection-editor";
          };
          "custom/power" = {
            "format" = "";
            "tooltip" = false;
            "on-click" = "wlogout";
          };

          "bluetooth" = {
            "format" = "";
            "format-disabled" = "";
            "format-connected" = " {num_connections}";
            "format-connected-battery" = "{icon} {num_connections}";
            # "format-connected-battery"= "{icon} {device_alias}-{device_battery_percentage}%";
            "format-icons" = [
              "󰥇"
              "󰤾"
              "󰤿"
              "󰥀"
              "󰥁"
              "󰥂"
              "󰥃"
              "󰥄"
              "󰥅"
              "󰥆"
              "󰥈"
            ];
            # "format-device-preference"= [ "device1"; "device2" ]; // preference list deciding the displayed device If this config option is not defined or none of the devices in the list are connected; it will fall back to showing the last connected device.
            "tooltip-format" = "{controller_alias}\n{num_connections} connected";
            "tooltip-format-connected" =
              "{controller_alias}\n{num_connections} connected\n\n{device_enumerate}";
            "tooltip-format-enumerate-connected" = "{device_alias}";
            "tooltip-format-enumerate-connected-battery" =
              "{device_alias}\t{icon} {device_battery_percentage}%";
          };
        };
      };
      style = ''
        @define-color bg0 #1a1b26;
        @define-color bg1 #16161e;
        @define-color bg2 #2f334d;
        @define-color bg3 #414868;
        @define-color bg4 #565f89;

        @define-color red    #f7768e;
        @define-color orange #ff9e64;
        @define-color yellow #e0af68;
        @define-color green  #9ece6a;
        @define-color aqua   #0db9d7;
        @define-color blue   #7aa2f7;
        @define-color purple #bb9af7;

        @define-color fg #a9b1d6;

        @define-color grey0 #565f89;
        @define-color grey1 #6c7a9c;
        @define-color grey2 #7f8ebf;

          * {
                      /* `otf-font-awesome` is required to be installed for icons */
                      font-family: "Adwaita Sans", "Font Awesome", sans-serif;
                      font-size: 14px;
                      font-weight: bold;
                  }

                  window#waybar {
                      background-color: rgba(43, 48, 59, 0);
                      color: #ffffff;
                  }

                  #workspaces {
                      padding: 10px 10px;
                      background-color: @bg0;
                      margin: 7 0;
                      border-radius: 25px
                  }

                  #workspaces button {
                      transition: all 0.2s ease-in-out;
                      padding: 0 8px;
                      background-color: @bg2;
                      border-radius: 20px;
                      min-width: 50px;
                      margin: 0 3px;
                      color: transparent;
                  }

                  #workspaces button:hover {
                      background: @fg;
                      color: @bg2
                  }

                  #workspaces button.active {
                      transition: all 0.3s ease-in-out;
                      min-width: 80px;
                      background-color: @blue;
                      color: @bg2
                  }

                  #workspaces button.urgent {
                      background-color: #eb4d4b;
                  }

                  #clock,
                  #custom-weather,
                  #battery,
                  #network,
                  #custom-power,
                  #custom-notification,
                  #tray,
                  #pulseaudio {
                      padding: 0 14px;
                      background-color: @bg0;
                      border-radius: 50px;
                      margin: 11 5
                  }

                  #custom-weather {
                      transition: all 0.2s ease-in-out;
                      color: @grray
                  }

                  #tray {
                      transition: all 0.2s ease-in-out;
                      color: @purple
                  }

                  #custom-notification {
                      transition: all 0.2s ease-in-out;
                      color: @blue
                  }

                  #custom-power {
                      transition: all 0.2s ease-in-out;
                      color: @red
                  }

                  #clock {
                      transition: all 0.2s ease-in-out;
                      color: @blue
                  }

                  #battery {
                      transition: all 0.2s ease-in-out;
                      color: @green
                  }

                  #battery.charging, #battery.plugged {
                      transition: all 0.2s ease-in-out;
                      color: @green

                  }

                  #battery.critical:not(.charging) {
                      transition: all 0.2s ease-in-out;
                      animation-name: blink;
                      animation-duration: 0.5s;
                      animation-timing-function: steps(12);
                      animation-iteration-count: infinite;
                      animation-direction: alternate;
                  }

                  #network {
                      transition: all 0.2s ease-in-out;
                      color: @aqua
                  }

                  #network.disconnected {
                      transition: all 0.2s ease-in-out;
                      color: @grey0
                  }

                  #pulseaudio {
                      transition: all 0.2s ease-in-out;
                      color: @orange
                  }

                  #pulseaudio.muted {
                      transition: all 0.2s ease-in-out;
                      color: @grey11
                  }
      '';
    };
  };
}
