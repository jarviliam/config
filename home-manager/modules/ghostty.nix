{
  ...
}:
{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Everforest Dark Hard";
      font-size = 11;

      font-family = "Blex Mono";
      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-paste-protection = false;

      window-decoration = "client";
      window-theme = "ghostty";

      mouse-hide-while-typing = true;

      unfocused-split-opacity = 0.8;
      background-opacity = 0.85;
      background-blur = true;

      keybind = [
        "ctrl+shift+up=new_split:up"
        "ctrl+shift+down=new_split:down"
        "ctrl+shift+left=new_split:left"
        "ctrl+shift+right=new_split:right"
        "alt+shift+left=next_tab"
        "alt+shift+right=previous_tab"
        "global:ctrl+backquote=toggle_quick_terminal"
      ];
    };
  };
}
