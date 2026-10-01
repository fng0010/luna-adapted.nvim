local Util = require("luna-adapted.util")

local M = {}

---@param c LunaAdaptedPalette
---@param opts luna_adapted.Config
function M.get(c, opts)
  return {
    DressingInputNormal = { bg = opts.transparent and "NONE" or c.bg, fg = c.fg },
    DressingInputBorder = { fg = c.float_border },
    DressingInputTitle = { fg = c.silver },
    DressingSelectNormal = { bg = opts.transparent and "NONE" or c.bg, fg = c.fg },
    DressingSelectBorder = { fg = c.float_border },
    DressingSelectTitle = { fg = c.silver },
  }
end

return M
