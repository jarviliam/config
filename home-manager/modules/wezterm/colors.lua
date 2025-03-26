local M = {}

local melange = {
  foreground = "#ECE1D7",
  background = "#292522",
  cursor_bg = "#ECE1D7",
  cursor_border = "#ECE1D7",
  cursor_fg = "#292522",
  selection_bg = "#403A36",
  selection_fg = "#ECE1D7",
  ansi = {
    "#34302C",
    "#BD8183",
    "#78997A",
    "#E49B5D",
    "#7F91B2",
    "#B380B0",
    "#7B9695",
    "#C1A78E",
  },
  brights = {
    "#867462",
    "#D47766",
    "#85B695",
    "#EBC06D",
    "#A3A9CE",
    "#CF9BC2",
    "#89B3B6",
    "#ECE1D7",
  },
}

local gruv = {
  background = "#30363d",
  foreground = "#e6edf3",

  cursor_bg = "#e6edf3",
  cursor_border = "#e6edf3",
  cursor_fg = "#30363d",

  selection_bg = "#33588a",
  selection_fg = "#e6edf3",
  ansi = {
    "#484f58",
    "#ff7b72",
    "#3fb950",
    "#d29922",
    "#58a6ff",
    "#bc8cff",
    "#39c5cf",
    "#b1bac4",
  },
  brights = {
    "#6e7681",
    "#ffa198",
    "#56d364",
    "#e3b341",
    "#79c0ff",
    "#d2a8ff",
    "#56d4dd",
    "#ffffff",
  },
}

M.color_scheme = melange

M.apply = function(c)
  c.inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.8,
  }
  c.color_scheme = "Gruvbox dark, soft (base16)"
  c.color_schemes = {
    ["Github Dark New"] = M.color_scheme,
  }
end
return M
