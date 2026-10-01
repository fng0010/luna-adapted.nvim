local M = {}

---@param variant? "dark"|"light"
---@param opts? luna_adapted.Config
---@return LunaAdaptedPalette
function M.get(variant, opts)
  variant = variant or vim.o.background
  assert(variant == "dark" or variant == "light", "Unknown Luna variant: " .. tostring(variant))
  local colors = vim.deepcopy(require("luna-adapted.palettes." .. variant))
  if opts and opts.on_colors then
    opts.on_colors(colors)
  end
  require("luna-adapted.util").apply_accent(colors, opts and opts.accent or 1)
  return colors
end

return M
