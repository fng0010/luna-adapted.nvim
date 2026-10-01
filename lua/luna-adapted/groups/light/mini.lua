local M = {}

function M.get(c, opts)
  local normal_bg = c.func
  local insert_bg = c.type
  local visual_bg = c.grey_light
  local replace_bg = c.comment
  local command_bg = c.silver

  return {
    -- Mini.statusline
    MiniStatuslineModeNormal = { fg = c.white, bg = normal_bg },
    MiniStatuslineModeInsert = { fg = c.white, bg = insert_bg },
    MiniStatuslineModeVisual = { fg = c.white, bg = visual_bg },
    MiniStatuslineModeReplace = { fg = c.white, bg = replace_bg },
    MiniStatuslineModeCommand = { fg = c.white, bg = command_bg },
    MiniStatuslineModeOther = { fg = c.white, bg = c.grey_light },

    MiniStatuslineDevinfo = { fg = c.fg, bg = c.bg_alt },
    MiniStatuslineFilename = { fg = c.fg_bright, bg = opts.transparent and "NONE" or c.bg },
    MiniStatuslineFileinfo = { fg = c.fg, bg = c.bg_alt },
    MiniStatuslineInactive = { fg = c.keyword, bg = opts.transparent and "NONE" or c.bg },
  }
end

return M
