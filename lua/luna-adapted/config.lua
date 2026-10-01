local M = {}

---@class luna_adapted.Config
---@field transparent? boolean
---@field plugins? table<string,boolean|table>
---@field accent? number 0-1, blends syntax accents toward grey_light. 1 = full color (default).
---@field on_highlights? fun(highlights: luna_adapted.Highlights, colors: LunaAdaptedPalette)
---@field on_colors? fun(colors: LunaAdaptedPalette)
M.defaults = {
  transparent = false,
  accent = 1.0,
  plugins = {
    all = true,
    auto = true,
  },
  on_highlights = function(highlights, colors) end,
  on_colors = function(colors) end,
}

---@param opts? luna_adapted.Config
function M.setup(opts)
  M.opts = M.extend(opts)
end

---@param opts? luna_adapted.Config
function M.extend(opts)
  return vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
