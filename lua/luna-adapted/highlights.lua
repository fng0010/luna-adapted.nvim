local M = {}

---@param opts? luna_adapted.Config
function M.setup(opts)
  vim.cmd("hi clear")
  if vim.g.syntax_on then
    vim.cmd("syntax reset")
  end

  vim.opt.termguicolors = true

  local p = require("luna-adapted.palette").get(vim.o.background, opts)

  local groups = require("luna-adapted.groups").setup(p, opts)

  -- Apply user on_highlights last, so it always wins
  if opts and opts.on_highlights then
    opts.on_highlights(groups, p)
  end

  local terminal_colors = nil
  for group, hl in pairs(groups) do
    if group == "_terminal_colors" then
      terminal_colors = hl
    else
      hl = type(hl) == "string" and { link = hl } or hl
      vim.api.nvim_set_hl(0, group, hl)
    end
  end

  if terminal_colors then
    for i = 0, 15 do
      vim.g["terminal_color_" .. i] = terminal_colors[i]
    end
  end

  return p, groups, opts
end

return M
