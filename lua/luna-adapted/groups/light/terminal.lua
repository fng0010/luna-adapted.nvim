local M = {}

function M.get(c, opts)
  return { _terminal_colors = c.terminal }
end

return M
