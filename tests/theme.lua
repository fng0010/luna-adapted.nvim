-- Run from the repository root: nvim --headless -u NONE -i NONE -l tests/theme.lua
vim.opt.runtimepath:prepend(vim.fn.getcwd())
for _, file in ipairs(vim.fn.glob("**/*.lua", false, true)) do
  local chunk, message = loadfile(file)
  assert(chunk, message)
end
local theme = require("luna-adapted")
local function eq(actual, expected, label)
  assert(vim.deep_equal(actual, expected), (label or "value") .. ": " .. vim.inspect(actual))
end
local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end
local function hex(color)
  return tonumber(color:sub(2), 16)
end
local function luminance(color)
  local channels = {}
  for i = 2, 6, 2 do
    local v = tonumber(color:sub(i, i + 1), 16) / 255
    channels[#channels + 1] = v <= 0.04045 and v / 12.92 or ((v + 0.055) / 1.055) ^ 2.4
  end
  return channels[1] * 0.2126 + channels[2] * 0.7152 + channels[3] * 0.0722
end
local function contrast(fg, bg)
  local a, b = luminance(fg), luminance(bg)
  return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05)
end
local expected_bg = { dark = "#060606", light = "#faf8f4" }
local expected_function = { dark = "#75a1c7", light = "#2f6b9e" }

theme.setup()
for _, variant in ipairs({ "dark", "light" }) do
  vim.o.background = variant
  vim.cmd.colorscheme("luna-adapted")
  eq(vim.o.background, variant, "respects background")
  eq(vim.g.colors_name, "luna-adapted", "single colorscheme")
  eq(theme.variant, variant, "resolved variant")
  local c = theme.colors
  eq(hl("Normal").bg, hex(expected_bg[variant]), "background")
  eq(hl("Function").fg, hex(expected_function[variant]), "function")
  eq(hl("@lsp.type.keyword").fg, hex(c.keyword), "semantic token")
  eq(hl("NeoTreeDirectoryName").fg, hex(c.grey_light), "plugin")
  for _, key in ipairs({ "fg", "comment", "keyword", "func", "type", "string", "error", "warning", "info", "hint", "ok" }) do
    assert(contrast(c[key], c.bg) >= 4.5, variant .. " " .. key .. " contrast")
  end
  for line in io.lines("extras/ghostty/luna-adapted-" .. variant) do
    local index, color = line:match("^palette = (%d+)=(#%x+)$")
    if index and tonumber(index) < 16 then
      eq(vim.g["terminal_color_" .. index], color, "ANSI " .. index)
    end
  end
  local bar = require("lualine.themes.luna-adapted")
  eq(bar.normal.c.bg, c.bg, "lualine surface")
  for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command" }) do
    assert(contrast(bar[mode].a.fg, bar[mode].a.bg) >= 4.5, variant .. " lualine " .. mode)
  end
end

-- Change only background: native Neovim reload must update every component.
-- Also exercise lualine's ColorScheme refresh while preserving user sections.
local config = { options = { theme = "luna-adapted" }, sections = { lualine_c = { "filename" } } }
local refreshes = 0
package.loaded.lualine = {
  get_config = function() return config end,
  setup = function(opts)
    eq(opts, config, "preserve lualine configuration")
    local bar = require("lualine.themes.luna-adapted")
    eq(bar.normal.c.bg, theme.colors.bg, "automatic lualine refresh")
    refreshes = refreshes + 1
  end,
}
for _, variant in ipairs({ "dark", "light", "dark", "light" }) do
  vim.cmd("set background=" .. variant)
  eq(vim.g.colors_name, "luna-adapted", "same name after automatic switch")
  eq(theme.variant, variant, "automatic variant")
  eq(hl("Normal").bg, hex(expected_bg[variant]), "automatic editor switch")
  eq(hl("Function").fg, hex(expected_function[variant]), "automatic syntax switch")
  eq(hl("NeoTreeDirectoryName").fg, hex(theme.colors.grey_light), "automatic plugin switch")
  eq(vim.g.terminal_color_4, expected_function[variant], "automatic terminal switch")
end
assert(refreshes >= 4, "background changes should refresh lualine")
config.options.theme = "another-theme"
local before = refreshes
vim.cmd("set background=dark")
eq(refreshes, before, "respect another lualine theme")
package.loaded.lualine = nil

for _, variant in ipairs({ "dark", "light" }) do
  vim.o.background = variant
  theme.setup({ plugins = { all = false, auto = false, telescope = true } })
  vim.cmd.colorscheme("luna-adapted")
  assert(not vim.tbl_isempty(hl("TelescopeSelection")))
  assert(vim.tbl_isempty(hl("NeoTreeDirectoryName")))
  theme.setup({ plugins = { telescope = false } })
  vim.cmd.colorscheme("luna-adapted")
  assert(vim.tbl_isempty(hl("TelescopeSelection")))
  assert(not vim.tbl_isempty(hl("NeoTreeDirectoryName")))

  package.loaded.lazy = {}
  package.loaded["lazy.core.config"] = { plugins = { ["telescope.nvim"] = {} } }
  theme.setup({ plugins = { all = false, auto = true } })
  vim.cmd.colorscheme("luna-adapted")
  assert(not vim.tbl_isempty(hl("TelescopeSelection")))
  assert(vim.tbl_isempty(hl("NeoTreeDirectoryName")))
  package.loaded.lazy = nil
  package.loaded["lazy.core.config"] = nil

  local called = false
  theme.setup({
    transparent = true,
    accent = 0,
    on_colors = function(colors)
      colors.grey_light = "#454545"
      colors.fg = "#242424"
    end,
    on_highlights = function(groups, colors)
      eq(colors.keyword, "#454545", "colors hook before blending")
      groups.Function = { fg = "#123456", bold = true }
      called = true
    end,
  })
  vim.cmd.colorscheme("luna-adapted")
  assert(called)
  eq(hl("Normal").bg, nil, "transparent editor")
  eq(hl("NormalFloat").bg, nil, "transparent float")
  eq(hl("Keyword").fg, hex("#454545"), "accent zero")
  eq(hl("Function").fg, hex("#123456"), "highlight hook")
  local bar = require("lualine.themes.luna-adapted")
  eq(bar.normal.c.bg, "NONE", "transparent lualine")
  eq(bar.normal.b.fg, "#242424", "lualine colors hook")

  theme.setup()
  vim.cmd.colorscheme("luna-adapted")
  eq(hl("Function").fg, hex(expected_function[variant]), "fresh palette after hooks")
end

-- The optional source checkout verifies full dark highlight parity with Luna.
local sibling = vim.fn.fnamemodify(vim.fn.getcwd(), ":h") .. "/luna.nvim"
if vim.fn.isdirectory(sibling) == 1 then
  vim.opt.runtimepath:append(sibling)
  local original = require("luna.groups").setup(require("luna.palette"), require("luna.config").defaults)
  local adapted = require("luna-adapted.groups").setup(
    require("luna-adapted.palette").get("dark"), require("luna-adapted.config").defaults, "dark"
  )
  eq(adapted, original, "complete original dark highlight parity")
  vim.cmd.colorscheme("luna")
  eq(hl("Normal").bg, hex("#060606"), "original can coexist")
  vim.cmd.colorscheme("luna-adapted")
  eq(hl("Normal").bg, hex(expected_bg[vim.o.background]), "independent modules")
end
-- Optional integration check against an installed lualine checkout.
local lualine_path = vim.env.LUNA_ADAPTED_LUALINE_PATH
if lualine_path and vim.fn.isdirectory(lualine_path) == 1 then
  vim.opt.runtimepath:append(lualine_path)
  local lualine = require("lualine")
  lualine.setup({ options = { theme = "luna-adapted", icons_enabled = false } })
  local sections = lualine.get_config().sections
  for _, variant in ipairs({ "dark", "light", "dark" }) do
    vim.cmd("set background=" .. variant)
    eq(hl("lualine_a_normal").bg, hex(expected_function[variant]), "real lualine switch")
    eq(lualine.get_config().sections, sections, "real lualine sections")
  end
end
print("Luna Adapted: all tests passed")
