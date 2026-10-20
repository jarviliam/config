{ ... }:
{
  homebrew = {
    casks = [
      "nikitabobko/tap/aerospace"
    ];
  };

  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys" = {
    AppleSymbolicHotKeys = {
      # Disable the standard macOS shortcuts that usually conflict with a
      # tiling window manager / keyboard-driven workspace workflow.
      # These cover Spotlight, app/window switching, and Mission Control /
      # Spaces style bindings.
      "32".enabled = false; # Mission Control
      "33".enabled = false; # App Exposé
      "34".enabled = false; # Show Desktop
      "35".enabled = false; # Launchpad
      "36".enabled = false; # Move left a space
      "37".enabled = false; # Move right a space
      "38".enabled = false; # Move focus to active or next window
      "49".enabled = false; # Spotlight
      "63".enabled = false; # Input source
      "64".enabled = false; # Input source menu
      "79".enabled = false; # Switch to Desktop 1
      "80".enabled = false; # Switch to Desktop 2
      "81".enabled = false; # Switch to Desktop 3
      "82".enabled = false; # Switch to Desktop 4
    };
  };
}
