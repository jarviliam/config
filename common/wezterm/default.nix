#wip
{ config, pkgs, lib, ... }:
let light_palette = {
  flamingo = "#DD7878",
  pink = "#ea76cb",
  mauve = "#8839EF",
  red = "#D20F39",
  maroon = "#E64553",
  peach = "#FE640B",
  yellow = "#df8e1d",
  green = "#40A02B",
  teal = "#179299",
  sky = "#04A5E5",
  sapphire = "#209FB5",
  blue = "#1e66f5",
  lavender = "#7287FD",
  text = "#4C4F69",
  subtext1 = "#5C5F77",
  subtext0 = "#6C6F85",
  overlay2 = "#7C7F93",
  overlay1 = "#8C8FA1",
  overlay0 = "#9CA0B0",
  surface2 = "#ACB0BE",
  surface1 = "#BCC0CC",
  surface0 = "#CCD0DA",
  base = "#EFF1F5",
  mantle = "#E6E9EF",
  crust = "#DCE0E8",
  };
  {
  programs.wezterm = {
    enable = true;
    colorSchemes = {
      light = {
        split = Theme.palette.surface0,
        foreground = Theme.palette.text,
        background = Theme.palette.base,
        cursor_bg = Theme.palette.overlay2,
        cursor_border = Theme.palette.overlay2,
        cursor_fg = Theme.palette.base,
        selection_bg = Theme.palette.surface2,
        selection_fg = Theme.palette.text,
        visual_bell = Theme.palette.surface0,
        indexed = {
        [16] = Theme.palette.peach,
        [17] = light_palette.flamingo,
        },
        scrollbar_thumb = Theme.palette.surface2,
        compose_cursor = Theme.palette.flamingo,
        ansi = {
        Theme.palette.surface0,
        Theme.palette.red,
        Theme.palette.green,
        Theme.palette.yellow,
        Theme.palette.blue,
        Theme.palette.mauve,
        Theme.palette.teal,
        Theme.palette.text,
        },
        brights = {
        Theme.palette.surface2,
        Theme.palette.red,
        Theme.palette.green,
        Theme.palette.yellow,
        Theme.palette.blue,
        Theme.palette.mauve,
        Theme.palette.teal,
        Theme.palette.surface2,
        },
        tab_bar = {
        background = Theme.palette.mantle,
        active_tab = {
        bg_color = "none",
        fg_color = Theme.palette.subtext1,
        intensity = "Bold",
        underline = "None",
        italic = false,
        strikethrough = false,
        },
        inactive_tab = {
        bg_color = Theme.palette.mantle,
        fg_color = Theme.palette.surface1,
        },
        inactive_tab_hover = {
        bg_color = Theme.palette.mantle,
        fg_color = Theme.palette.surface1,
        },
        new_tab = {
        bg_color = Theme.palette.mantle,
        fg_color = Theme.palette.subtext0,
        },
        new_tab_hover = {
        bg_color = Theme.palette.mantle,
        fg_color = Theme.palette.surface2,
        },
        },
        };
        dark = {
          rosewater = "#F5E0DC",
          flamingo = "#F2CDCD",
          pink = "#F5C2E7",
          mauve = "#CBA6F7",
          red = "#F38BA8",
          maroon = "#EBA0AC",
          peach = "#FAB387",
          yellow = "#F9E2AF",
          green = "#A6E3A1",
          teal = "#94E2D5",
          sky = "#89DCEB",
          sapphire = "#74C7EC",
          blue = "#89B4FA",
          lavender = "#B4BEFE",
          text = "#CDD6F4",
          subtext1 = "#BAC2DE",
          subtext0 = "#A6ADC8",
          overlay2 = "#9399B2",
          overlay1 = "#7F849C",
          overlay0 = "#6C7086",
          surface2 = "#585B70",
          surface1 = "#45475A",
          surface0 = "#313244",
          base = "#1E1E2E",
          mantle = "#181825",
          crust = "#11111B",
          };
        };
        extraConfig = '';
    };
}

