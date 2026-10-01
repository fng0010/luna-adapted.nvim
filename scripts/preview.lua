-- Export actual Neovim legacy Lua syntax colors for the SVG renderer.
vim.opt.runtimepath:prepend(vim.fn.getcwd())
vim.o.background = arg[1] or "dark"
vim.cmd.colorscheme("luna-adapted")
vim.cmd("syntax enable")
vim.cmd("edit examples/luna.lua")
vim.bo.filetype = "lua"
vim.cmd("syntax sync fromstart")
local palette = require("luna-adapted").colors
local lines = {}
for row, text in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
  local spans = {}
  for column = 1, #text do
    local id = vim.fn.synIDtrans(vim.fn.synID(row, column, true))
    local color = vim.fn.synIDattr(id, "fg#")
    if color == "" then
      color = palette.fg
    end
    local last = spans[#spans]
    if last and last.color == color then
      last.text = last.text .. text:sub(column, column)
    else
      spans[#spans + 1] = { text = text:sub(column, column), color = color }
    end
  end
  lines[#lines + 1] = spans
end
print(vim.json.encode({ palette = palette, lines = lines }))
