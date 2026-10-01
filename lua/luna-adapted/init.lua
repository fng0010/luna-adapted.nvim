local M = {}

-- Neovim reloads the active colorscheme when 'background' changes. Keep the
-- named lualine theme in sync as well, without changing the user's sections.
local group = vim.api.nvim_create_augroup("LunaAdapted", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  pattern = "luna-adapted",
  callback = function()
    package.loaded["lualine.themes.luna-adapted"] = nil
    local lualine = package.loaded.lualine
    if type(lualine) == "table" and type(lualine.get_config) == "function" then
      local config = lualine.get_config()
      if config.options and config.options.theme == "luna-adapted" then
        lualine.setup(config)
      end
    end
  end,
})

---@param opts? luna_adapted.Config
function M.setup(opts)
  require("luna-adapted.config").setup(opts)
end

function M.load()
  local config = require("luna-adapted.config")
  local opts = config.opts or config.defaults
  local colors, groups = require("luna-adapted.highlights").setup(opts)
  M.colors = colors
  M.variant = vim.o.background
  vim.g.colors_name = "luna-adapted"
  package.loaded["lualine.themes.luna-adapted"] = nil
  return colors, groups, opts
end

return M
