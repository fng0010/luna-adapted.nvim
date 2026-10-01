# Contributing

Preserve the original Luna dark palette and highlight mappings. Keep the four
syntax hues recognizable in the light variant, with readable ink and light
surfaces. ANSI colors should match the respective Ghostty companion files.

Use two spaces for Lua indentation; `.stylua.toml` defines formatting. Keep
imports in the `luna-adapted` namespace. Variant palettes live in
`lua/luna-adapted/palettes/`; variant highlight mappings live in
`lua/luna-adapted/groups/dark/` and `lua/luna-adapted/groups/light/`. Shared
configuration and loading belong in the parent modules.

Run `nvim --headless -u NONE -i NONE -l tests/theme.lua` before submitting.
For palette changes, regenerate previews using `python3 scripts/render_preview.py`
and inspect both SVGs. Tests must continue to verify automatic switching by
changing only Neovim's background option.

For optional testing with a real lualine installation, set
`LUNA_ADAPTED_LUALINE_PATH` to its checkout directory when running the tests.

Include the Neovim version, relevant plugin and a minimal configuration in bug
reports. For Tree-sitter issues, include parser versions.
