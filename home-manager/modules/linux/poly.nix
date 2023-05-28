{ pkgs, ... }: {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      mpdSupport = true;
      githubSupport = true;
    };
    script = "exec polybar main &";
    settings = let
      color = {
        background = "#1F1F1F";
        foreground = "#FFFFFF";
        foreground-alt = "#8F8F8F";
        # shade1 = "#0D47A1";
        # shade2 = "#1565C0";
        # shade3 = "#1976D2";
        # shade4 = "#1E88E5";
        # shade5 = "#2196F3";
        # shade6 = "#42A5F5";
        # shade7 = "#64B5F6";
        # shade8 = "#90CAF9";
        # foreground = "#e0def4";
        # background = "#191724";
        red = "#eb6f92";
        blue = "#31748f";
        cyan = "#ebbcba";
        shade1 = "#4A148C";
        shade2 = "#6A1B9A";
        shade3 = "#7B1FA2";
        shade4 = "#8E24AA";
        shade5 = "#9C27B0";
        shade6 = "#AB47BC";
        shade7 = "#BA68C8";
        shade8 = "#CE93D8";

      };
    in {
      "settings" = {
        screenchange-reload = false;
        compositing-background = "source";
        compositing-foreground = "over";
        compositing-overline = "over";
        compositing-underline = "over";
        compositing-border = "over";
        psuedo-transparency = false;
      };

      "module/cpu" = {
        type = "internal/cpu";

        # Seconds to sleep between updates
        # Default: 1
        interval = 1;

        # Available tags:
        #   <label> (default)
        #   <bar-load>
        #   <ramp-load>
        #   <ramp-coreload>
        #;format = <label> <ramp-coreload>
        format = "<label>";
        format-prefix = "﬙";
        format-background = "${color.shade3}";
        format-padding = 2;

        # Available tokens:
        #   %percentage% (default) - total cpu load averaged over all cores
        #   %percentage-sum% - Cumulative load on all cores
        #   %percentage-cores% - load percentage for each core
        #   %percentage-core[1-9]% - load percentage for specific core
        label = " %percentage%%";
      };
      "module/volume" = {
        type = "internal/pulseaudio";
        use-ui-max = false;
        interval = 5;
        format-volume = "<ramp-volume>  <label-volume>";
        format-muted = "<label-muted>";
        format-muted-prefix = "婢";
        format-muted-prefix-font = 2;
        format-muted-prefix-foreground = color.red;
        label-volume = "%percentage%%";
        label-muted = "  Muted";
        label-muted-foreground = "#757575";
        ramp-volume-0 = "奄";
        ramp-volume-1 = "奄";
        ramp-volume-2 = "奄";
        ramp-volume-3 = "奔";
        ramp-volume-4 = "奔";
        ramp-volume-5 = "奔";
        ramp-volume-6 = "墳";
        ramp-volume-7 = "墳";
        ramp-volume-8 = "墳";
        ramp-volume-9 = "墳";
        ramp-volume-font = 2;
        ramp-volume-foreground = color.blue;
        ramp-headphones-0 = "";
        ramp-headphones-1 = "";
      };
      "module/date" = {
        type = "internal/date";

        # Seconds to sleep between updates
        interval = 1.0;

        # See "http://en.cppreference.com/w/cpp/io/manip/put_time" for details on how to format the date string
        # NOTE: if you want to use syntax tags here you need to use %%{...}
        #;date = %Y-%m-%d%

        # Optional time format;
        time = " %I:%M %p";

        # if `date-alt` or `time-alt` is defined, clicking
        # the module will toggle between formats
        #;date-alt = %A, %d %B %Y
        time-alt = " %a, %d %b %Y";

        # Available tags:
        #   <label> (default)
        format = "<label>";
        format-background = "${color.shade3}";
        format-padding = 2;

        # Available tokens:
        #   %date%
        #   %time%
        # Default: %date%
        label = "%time%";
      };
      "module/filesystem" = {
        type = "internal/fs";

        # Mountpoints to display
        mount-0 = "/";
        #;mount-1 = /home
        #;mount-2 = /var

        # Seconds to sleep between updates
        # Default: 30
        interval = 30;

        # Display fixed precision values
        # Default: false
        fixed-values = "true";

        # Spacing between entries
        # Default: 2
        #;spacing = 4

        # Available tags:
        #   <label-mounted> (default)
        #   <bar-free>
        #   <bar-used>
        #   <ramp-capacity>
        format-mounted = "<label-mounted>";
        format-mounted-prefix = "";
        format-mounted-background = "${color.shade5}";
        format-mounted-padding = 2;

        # Available tags:
        #   <label-unmounted> (default)
        format-unmounted = "<label-unmounted>";
        format-unmounted-prefix = "";
        format-unmounted-background = "${color.shade5}";
        format-unmounted-padding = 2;

        # Available tokens:
        #   %mountpoint%
        #   %type%
        #   %fsname%
        #   %percentage_free%
        #   %percentage_used%
        #   %total%
        #   %free%
        #   %used%
        # Default: %mountpoint% %percentage_free%%
        label-mounted = " %free%";

        # Available tokens:
        #   %mountpoint%
        # Default: %mountpoint% is not mounted
        label-unmounted = " %mountpoint%: not mounted";

      };
      "module/mpd" = {
        type = "internal/mpd";

        # Host where mpd is running (either ip or domain name)
        # Can also be the full path to a unix socket where mpd is running.
        #;host = 127.0.0.1
        #;port = 6600
        #;password = mysecretpassword

        # Seconds to sleep between progressbar/song timer sync
        # Default: 1
        interval = 1;

        # Available tags:
        #   <label-song> (default)
        #   <label-time>
        #   <bar-progress>
        #   <toggle> - gets replaced with <icon-(pause|play)>
        #   <toggle-stop> - gets replaced with <icon-(stop|play)>
        #   <icon-random>
        #   <icon-repeat>
        #   <icon-repeatone> (deprecated)
        #   <icon-single> - Toggle playing only a single song. Replaces <icon-repeatone>
        #   <icon-consume>
        #   <icon-prev>
        #   <icon-stop>
        #   <icon-play>
        #   <icon-pause>
        #   <icon-next>
        #   <icon-seekb>
        #   <icon-seekf>
        format-online = "<toggle> <label-song>";
        #format-online-prefix = ﱘ
        format-online-background = "${color.shade8}";
        format-online-foreground = "#2E2E2E";
        format-online-padding = 2;

        #format-playing = ${self.format-online}
        #format-paused = ${self.format-online}
        #format-stopped = ${self.format-online}

        # Available tags:
        #   <label-offline>
        format-offline = "<label-offline>";
        format-offline-prefix = "ﱘ";
        format-offline-background = "${color.shade8}";
        format-offline-foreground = "#2E2E2E";
        format-offline-padding = 2;

        # Available tokens:
        #   %artist%
        #   %album-artist%
        #   %album%
        #   %date%
        #   %title%
        # Default: %artist% - %title%
        label-song = "%artist% - %title%";
        label-song-maxlen = 25;
        label-song-ellipsis = "true";

        # Available tokens:
        #   %elapsed%
        #   %total%
        # Default: %elapsed% / %total%
        label-time = "%elapsed% / %total%";

        # Available tokens:
        #   None
        label-offline = " Offline";

        # Only applies if <icon-X> is used
        icon-play = "喇";
        icon-pause = "";
        icon-stop = "";
        icon-prev = "";
        icon-next = "";
        icon-seekb = "";
        icon-seekf = "";
        icon-random = "";
        icon-repeat = "";
        icon-repeatone = "";
        icon-single = "";
        icon-consume = "";

        # Used to display the state of random/repeat/repeatone/single
        # Only applies if <icon-[random|repeat|repeatone|single]> is used
        toggle-on-foreground = "${color.foreground}";
        toggle-off-foreground = "${color.background}";
      };

      "module/github" = {
        type = "internal/github";

        # Accessing an access token stored in file
        token = "file:~/.config/gha.token";
        user = "jarviliam";

        # Accessing an access token stored in an environment variable
        #;token = ${env:GITHUB_ACCESS_TOKEN}

        # Whether empty notifications should be displayed or not
        #;empty-notifications = false

        # Number of seconds in between requests
        #;interval = 10

        # Available tags:
        #   <label> (default)
        #;format = <label>
        #;format-prefix = 

        # Available tokens:
        #   %notifications% (default)
        # Default: Notifications: %notifications%
        #;label = %notifications%
      };
      "module/google" = {
        type = "custom/text";
        content-foreground = "${color.foreground-alt}";
        content-padding = 2;
        content = "";
        click-left = "exo-open https://www.google.com/ &";
      };
      "module/githublink" = {
        type = "custom/text";
        content-foreground = "${color.foreground-alt}";
        content-padding = 2;
        content = "";
        click-left = "exo-open https://www.github.com/ &";
      };
      "module/reddit" = {
        type = "custom/text";
        content-foreground = "${color.foreground-alt}";
        content-padding = 2;
        content = "";
        click-left = "exo-open https://www.reddit.com/ &";
      };
      "module/gmail" = {
        type = "custom/text";
        content-foreground = "${color.foreground-alt}";
        content-padding = 2;
        content = "";
        click-left = "exo-open https://mail.google.com/ &";
      };
      "module/twitter" = {
        type = "custom/text";
        content-foreground = "${color.foreground-alt}";
        content-padding = 2;
        content = "";
        click-left = "exo-open https://www.twitter.com/ &";
      };
      "module/empty-space" = {
        type = "custom/text";
        content = " ";
      };
      "module/backlight" = {
        type = "internal/backlight";
        # Use the following command to list available cards:
        # $ ls -1 /sys/class/backlight/
        card = "intel_backlight";
        # card = amdgpu_bl0;

        # Available tags:
        #   <label> (default)
        #   <ramp>
        #   <bar>
        format = "<ramp> <label>";
        format-background = color.shade2;
        format-padding = 2;

        # Available tokens:
        #   %percentage% (default)
        label = "%percentage%%";

        # Only applies if <ramp> is used
        ramp-0 = "";
        ramp-1 = "";
        ramp-2 = "";
        ramp-3 = "";
        ramp-4 = "";
      };
      "module/battery" = {
        type = "internal/battery";

        # This is useful in case the battery never reports 100% charge
        full-at = 99;

        # Use the following command to list batteries and adapters:
        # $ ls -1 /sys/class/power_supply/
        battery = "BAT1";
        adapter = "ACAD";

        # If an inotify event haven't been reported in this many
        # seconds, manually poll for new values.
        #
        # Needed as a fallback for systems that don't report events
        # on sysfs/procfs.
        #
        # Disable polling by setting the interval to 0.
        #
        # Default: 5
        poll-interval = 2;

        # see "man date" for details on how to format the time string
        # NOTE: if you want to use syntax tags here you need to use %%{...}
        # Default: %H:%M:%S
        time-format = "%H:%M";

        # Available tags:
        #   <label-charging> (default)
        #   <bar-capacity>
        #   <ramp-capacity>
        #   <animation-charging>
        format-charging = "<animation-charging> <label-charging>";
        format-charging-background = "${color.shade5}";
        format-charging-padding = 2;

        # Available tags:
        #   <label-discharging> (default)
        #   <bar-capacity>
        #   <ramp-capacity>
        #   <animation-discharging>
        format-discharging = "<ramp-capacity> <label-discharging>";
        format-discharging-background = "${color.shade5}";
        format-discharging-padding = 2;

        # Available tags:
        #   <label-full> (default)
        #   <bar-capacity>
        #   <ramp-capacity>
        format-full = "<label-full>";
        format-full-prefix = "";
        format-full-background = "${color.shade5}";
        format-full-padding = 2;

        # Available tokens:
        #   %percentage% (default)
        #   %time%
        #   %consumption% (shows current charge rate in watts)
        label-charging = "%percentage%%";

        # Available tokens:
        #   %percentage% (default)
        #   %time%
        #   %consumption% (shows current discharge rate in watts)
        label-discharging = "%percentage%%";

        # Available tokens:
        #   %percentage% (default)
        label-full = "Full";

        # Only applies if <ramp-capacity> is used
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        ramp-capacity-5 = "";
        ramp-capacity-6 = "";
        ramp-capacity-7 = "";
        ramp-capacity-8 = "";
        ramp-capacity-9 = "";

        # Only applies if <bar-capacity> is used
        #bar-capacity-width = 10

        # Only applies if <animation-charging> is used
        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-5 = "";
        animation-charging-6 = "";

        # Framerate in milliseconds
        animation-charging-framerate = 750;

        # Only applies if <animation-discharging> is used
        #;animation-discharging-0 = ${battery.anim0}
        #;animation-discharging-1 = ${battery.anim1}

        # Framerate in milliseconds
        #animation-discharging-framerate = 500
      };
      "module/memory" = {
        type = "internal/memory";

        # Seconds to sleep between updates
        # Default: 1
        interval = 1;

        # Available tags:
        #   <label> (default)
        #   <bar-used>
        #   <bar-free>
        #   <ramp-used>
        #   <ramp-free>
        #   <bar-swap-used>
        #   <bar-swap-free>
        #   <ramp-swap-used>
        #   <ramp-swap-free>
        format = "<label>";
        format-prefix = "";
        format-background = "${color.shade4}";
        format-padding = 2;

        # Available tokens:
        #   %percentage_used% (default)
        #   %percentage_free%
        #   %gb_used%
        #   %gb_free%
        #   %gb_total%
        #   %mb_used%
        #   %mb_free%
        #   %mb_total%
        #   %percentage_swap_used%
        #   %percentage_swap_free%
        #   %mb_swap_total%
        #   %mb_swap_free%
        #   %mb_swap_used%
        #   %gb_swap_total%
        #   %gb_swap_free%
        #   %gb_swap_used%

        label = " %mb_used%";

        # Only applies if <ramp-used> is used
        #;ramp-used-0 = ${memory.used0}
        #;ramp-used-1 = ${memory.used1}
        #;ramp-used-2 = ${memory.used2}

        # Only applies if <ramp-free> is used
        #;ramp-free-0 = ${memory.free0}
        #;ramp-free-1 = ${memory.free1}
        #;ramp-free-2 = ${memory.free2}
      };
      "module/bspwm" = {
        type = "internal/bspwm";
        pin-workspaces = true;
        enable-click = true;
        enable-scroll = true;
        ws-icon-0 = "1;";
        ws-icon-1 = "2;";
        ws-icon-2 = "3;";
        ws-icon-3 = "4;";
        ws-icon-4 = "5;";
        ws-icon-default = "";

        # Available tags:
        #   <label-monitor>
        #   <label-state> - gets replaced with <label-(active|urgent|occupied|empty)>
        # Default: <label-state>
        format = "<label-state>";
        format-padding = 1;
        format-background = color.shade2;

        # Available tokens:
        #   %name%
        # Default: %name%
        label-monitor = "%name%";

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        # Default: %icon%  %name%
        label-focused = "";
        label-focused-foreground = "${color.foreground}";

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        # Default: %icon%  %name%
        label-occupied = "";
        label-occupied-foreground = "${color.foreground}";

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        # Default: %icon%  %name%
        label-urgent = "";
        label-urgent-foreground = "${color.background}";

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        # Default: %icon%  %name%
        label-empty = "";

        label-active-padding = 1;
        label-urgent-padding = 1;
        label-occupied-padding = 1;
        label-empty-padding = 1;
      };

      "module/launcher" = {
        type = "custom/text";
        content = "";

        # "content" has the same properties as "format-NAME"
        content-background = color.shade1;
        content-foreground = color.foreground;
        content-padding = 2;

        # "click-(left|middle|right)" will be executed using "/usr/bin/env sh -c $COMMAND"
        # click-left = "~/.config/polybar/shades/scripts/launcher.sh &";
        #;click-middle = ~/.config/polybar/shades/scripts/launcher-full
        # click-right = "~/.config/polybar/shades/scripts/color-switch.sh &";

        # "scroll-(up|down)" will be executed using "/usr/bin/env sh -c $COMMAND"
        #;scroll-up = ~/.config/polybar/shades/scripts/launcher.sh &
        #;scroll-down = ~/.config/polybar/shades/scripts/color-switch.sh &
        # content = "  ";
        # content-foreground = color.blue;
        # content-background = color.background;
        # content-padding = 0;
        # click-left = "rofi -show drun";
      };
      "module/powermenu" = {
        type = "custom/menu";

        # If true, <label-toggle> will be to the left of the menu items (default).
        # If false, it will be on the right of all the items.
        expand-right = "true";

        # "menu-LEVEL-N" has the same properties as "label-NAME" with
        # the additional "exec" property
        #
        # Available exec commands:
        #   menu-open-LEVEL
        #   menu-close
        # Other commands will be executed using "/usr/bin/env sh -c $COMMAND"
        menu-0-0 = "reboot";
        menu-0-0-exec = "menu-open-1";
        menu-0-1 = "shutdown";
        menu-0-1-exec = "menu-open-2";

        menu-1-0 = "back";
        menu-1-0-exec = "menu-open-0";
        menu-1-1 = "reboot";
        menu-1-1-exec = "systemctl reboot";

        menu-2-0 = "shutdown";
        menu-2-0-exec = "systemctl poweroff";
        menu-2-1 = "back";
        menu-2-1-exec = "menu-open-0";

        # Available tags:
        #   <label-toggle> (default) - gets replaced with <label-(open|close)>
        #   <menu> (default)
        # Note that if you use <label-toggle> you must also include
        # the definition for <label-open>

        format = "<label-toggle> <menu>";
        format-background = "${color.shade1}";
        format-foreground = "${color.foreground}";
        format-padding = 2;

        label-open = "";
        label-close = "";

        # Optional item separator
        # Default: none
        label-separator = " | ";

        #;label-open-foreground = ${color.foreground}
        #;label-close-foreground = ${color.background}
        #;label-separator-foreground = ${color.background}
      };
      "module/network" = {
        type = "internal/network";
        interface = "wlp2s0";
        # Seconds to sleep between updates
        # Default: 1
        interval = 1.0;

        # Test connectivity every Nth update
        # A value of 0 disables the feature
        # NOTE: Experimental (needs more testing)
        # Default: 0
        #ping-interval = 3

        # @deprecated: Define min width using token specifiers (%downspeed:min% and %upspeed:min%)
        # Minimum output width of upload/download rate
        # Default: 3
        #;udspeed-minwidth = 5

        # Accumulate values from all interfaces
        # when querying for up/downspeed rate
        # Default: false
        accumulate-stats = "true";

        # Consider an `UNKNOWN` interface state as up.
        # Some devices have an unknown state, even when they're running
        # Default: false
        unknown-as-up = "true";

        # Available tags:
        #   <label-connected> (default)
        #   <ramp-signal>
        format-connected = "<ramp-signal> <label-connected>";
        format-connected-background = "${color.shade4}";
        format-connected-padding = 2;

        # Available tags:
        #   <label-disconnected> (default)
        format-disconnected = "<label-disconnected>";
        format-disconnected-prefix = "睊";
        format-disconnected-background = "${color.shade4}";
        format-disconnected-padding = 2;

        # Available tags:
        #   <label-connected> (default)
        #   <label-packetloss>
        #   <animation-packetloss>
        #;format-packetloss = <animation-packetloss> <label-connected>

        # Available tokens:
        #   %ifname%    [wireless+wired]
        #   %local_ip%  [wireless+wired]
        #   %local_ip6% [wireless+wired]
        #   %essid%     [wireless]
        #   %signal%    [wireless]
        #   %upspeed%   [wireless+wired]
        #   %downspeed% [wireless+wired]
        #   %linkspeed% [wired]
        # Default: %ifname% %local_ip%
        label-connected = "%{A1:networkmanager_dmenu &:}%essid%%{A}";

        # Available tokens:
        #   %ifname%    [wireless+wired]
        # Default: (none)
        label-disconnected = "%{A1:networkmanager_dmenu &:} Offline%{A}";
        #;label-disconnected-foreground = #66ffffff

        # Available tokens:
        #   %ifname%    [wireless+wired]
        #   %local_ip%  [wireless+wired]
        #   %local_ip6% [wireless+wired]
        #   %essid%     [wireless]
        #   %signal%    [wireless]
        #   %upspeed%   [wireless+wired]
        #   %downspeed% [wireless+wired]
        #   %linkspeed% [wired]
        # Default: (none)
        #label-packetloss = %essid%
        #label-packetloss-foreground = #eefafafa

        # Only applies if <ramp-signal> is used
        ramp-signal-0 = "直";
        ramp-signal-1 = "直";
        ramp-signal-2 = "直";

        # Only applies if <animation-packetloss> is used
        #;animation-packetloss-0 = ⚠
        #;animation-packetloss-0-foreground = #ffa64c
        #;animation-packetloss-1 = ⚠
        #;animation-packetloss-1-foreground = #000000
        # Framerate in milliseconds
        #;animation-packetloss-framerate = 500
      };

      "module/sysmenu" = {
        type = "custom/text";
        content = "襤";
        content-background = "${color.shade2}";
        content-foreground = "${color.foreground}";
        content-padding = 2;

        click-left = "~/.config/polybar/shades/scripts/powermenu.sh &";

      };
      "module/alsa" = {
        type = "internal/alsa";

        # Soundcard to be used
        # Usually in the format hw:# where # is the card number
        # You can find the different card numbers in `/proc/asound/cards`
        master-soundcard = "default";
        speaker-soundcard = "default";
        headphone-soundcard = "default";

        # Name of the master, speaker and headphone mixers
        # Use the following command to list available mixer controls:
        # $ amixer scontrols | sed -nr "s/.*'([[:alnum:]]+)'.*/\1/p"
        # If master, speaker or headphone-soundcard isn't the default, 
        # use `amixer -c # scontrols` instead where # is the number 
        # of the master, speaker or headphone soundcard respectively
        #
        # Default: Master
        master-mixer = "Master";

        # Optionally define speaker and headphone mixers
        # Default: none
        #;speaker-mixer = Speaker
        # Default: none
        #;headphone-mixer = Headphone

        # NOTE: This is required if headphone_mixer is defined
        # Use the following command to list available device controls
        # $ amixer controls | sed -r "/CARD/\!d; s/.*=([0-9]+).*name='([^']+)'.*/printf '%3.0f: %s\n' '\1' '\2'/e" | sort
        # You may also need to use `amixer -c # controls` as above for the mixer names
        # Default: none
        #;headphone-id = 9

        # Use volume mapping (similar to amixer -M and alsamixer), where the increase in volume is linear to the ear
        # Default: false
        #;mapped = true

        # Interval for volume increase/decrease (in percent points)
        # Default: 5
        interval = 5;

        # Available tags:
        #   <label-volume> (default)
        #   <ramp-volume>
        #   <bar-volume>
        format-volume = "<ramp-volume> <label-volume>";
        format-volume-background = color.shade6;
        format-volume-padding = 2;

        # Available tags:
        #   <label-muted> (default)
        #   <ramp-volume>
        #   <bar-volume>
        format-muted = "<label-muted>";
        format-muted-prefix = "婢";
        format-muted-background = color.shade6;
        format-muted-padding = "2";

        # Available tokens:
        #   %percentage% (default)
        label-volume = "%percentage%%";

        # Available tokens:
        #   %percentage% (default
        label-muted = " Muted";
        label-muted-foreground = color.foreground;

        # Only applies if <ramp-volume> is used
        ramp-volume-0 = "奄";
        ramp-volume-1 = "奔";
        ramp-volume-2 = "墳";

        # If defined, it will replace <ramp-volume> when
        # headphones are plugged in to `headphone_control_numid`
        # If undefined, <ramp-volume> will be used for both
        # Only applies if <ramp-volume> is used
        ramp-headphones-0 = "";
      };

      "global/wm" = {
        margin-bottom = 0;
        margin-top = 0;
      };

      "bar/main" = {
        monitor = "\${env:MONITOR:HDMI-1}";
        bottom = false;
        width = "98%";
        height = 36;
        offset-x = "1%";
        offset-y = "2%";
        fixed-center = true;
        background = color.background;
        foreground = color.foreground;
        line-size = 2;

        border-size = 0;
        border-color = color.background;

        radius-top = 0.0;
        radius-bottom = 0.0;
        wm-restack = "bspwm";
        # font-0 = "JetBrains Mono Nerd Font:size=10:weight=bold;3";
        font-0 = "Hack Nerd Font:pixelsize=12;3";
        font-1 = "Iosevka Nerd Font:pixelsize=14;4";
        dim-value = 1.0;
        enable-ipc = true;

        underline-size = 2;
        underline-color = color.foreground;

        modules-left = "launcher bspwm google githublink reddit gmail";
        modules-center = "";
        modules-right = "mpd alsa battery network date sysmenu";

        separator = "";
        tray-position = "none";
        tray-detached = false;
        tray-maxsize = 16;
        tray-background = color.background;
        tray-offset-x = 0;
        tray-offset-y = 0;
        tray-padding = 0;
        tray-scale = 1.0;

        padding = 0;
        module-margin-left = 0;
        module-margin-right = 0;
      };
    };
  };
}
