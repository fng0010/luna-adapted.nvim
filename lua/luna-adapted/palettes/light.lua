local Util = require("luna-adapted.util")

---@class LunaAdaptedPalette
local palette = {
  -- Warm paper surfaces, based on the companion Luna Light Ghostty theme.
  bg = "#faf8f4",
  bg_alt = "#eeece7",
  bg_soft = "#f3f1ec",
  bg_plum = "#e9dfed",
  bg_delete = "#f5dfe0",
  surface = "#dedbd5",
  selection = "#b9cde6",
  border = "#b3afa8",
  float_bg = "#f0ede8",

  -- Neutral foregrounds: the stronger the role, the darker the ink.
  grey_warm = "#756b66",
  comment = "#74706b",
  grey = "#696970",
  grey_mid = "#62626b",
  grey_light = "#575760",
  grey_pale = "#4d4d55",
  silver = "#3e3e47",
  fg = "#26262b",
  fg_bright = "#16161a",
  cream = "#805b48",

  black = "#000000",
  white = "#ffffff",

  -- Luna's four syntax hues, deepened for legibility on warm paper.
  keyword = "#a4512b", -- peach / burnt orange: keywords, numbers, builtins
  func = "#2f6b9e", -- blue: functions and methods
  type = "#8559a0", -- lavender / violet: types, constants, tags
  string = "#526d3d", -- sage / olive: strings and regular expressions
  signal = "#9c5f2a", -- warm amber: search, jump targets and changes

  error = "#b64848",
  warning = "#936019",
  info = "#536b8b",
  hint = "#805b48",
  ok = "#347645",

  none = "NONE",
}

palette.number = palette.keyword
palette.cursor_line = { bg = palette.bg_alt }
palette.cursor_line_nr = { fg = palette.silver }
palette.line_nr = "#8f8a83"

palette.git = {
  add = { fg = palette.ok, bg = Util.blend_bg(palette.ok, 0.10, palette.bg) },
  delete = { fg = palette.error, bg = palette.bg_delete },
  change = { fg = palette.signal, bg = Util.blend_bg(palette.signal, 0.10, palette.bg) },
  text = { fg = palette.fg_bright, bg = Util.blend_bg(palette.signal, 0.24, palette.bg) },
}

palette.diag = {
  error = palette.error,
  warning = palette.warning,
  info = palette.info,
  hint = palette.hint,
  ok = palette.ok,
}

palette.visual = palette.selection
palette.float_border = palette.border

-- Match all sixteen ANSI slots in extras/ghostty/luna-adapted-light exactly.
-- Bright ANSI colors retain Luna's original pastels; syntax uses deeper ink.
palette.terminal = {
  [0] = "#26262b",
  "#c04f4f", "#3f8f52", "#9c5f2a", "#2f6b9e", "#8559a0", "#2f6b9e", "#4d4d55",
  "#a0a0aa", "#e08585", "#6fbe80", "#d9a35a", "#8c9cb8", "#c4a8d6", "#75a1c7", "#16161a",
}

return palette
