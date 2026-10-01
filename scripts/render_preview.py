#!/usr/bin/env python3
"""Generate a dependency-free SVG preview using actual Neovim syntax colors."""
import html
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent.parent
for variant in ("dark", "light"):
    result = subprocess.run(
        ["nvim", "--headless", "-u", "NONE", "-i", "NONE", "-l", "scripts/preview.lua", variant],
        cwd=ROOT, capture_output=True, text=True, check=True,
        env={**os.environ, "NVIM_LOG_FILE": os.devnull},
    )
    data = json.loads((result.stdout + result.stderr).strip())
    palette = data["palette"]
    width = 980
    line_height = 25
    height = 138 + len(data["lines"]) * line_height
    parts = [f'''<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">
    <title>Luna Adapted ({variant}) Neovim palette preview</title>
    <desc>Lua source colored using Neovim syntax highlights, with Luna's orange, blue, violet and sage accents in the {variant} variant.</desc>
    <rect width="{width}" height="{height}" rx="12" fill="{palette['bg']}"/>
    <path d="M12 0H968Q980 0 980 12V56H0V12Q0 0 12 0" fill="{palette['bg_alt']}"/>
    <text x="30" y="35" fill="{palette['fg']}" font-family="system-ui, sans-serif" font-size="16" font-weight="600">luna-adapted.nvim · {variant}</text>
    <text x="{width-150}" y="35" fill="{palette['comment']}" font-family="system-ui, sans-serif" font-size="13">examples/luna.lua</text>
    <g font-family="'SFMono-Regular', Consolas, 'Liberation Mono', monospace" font-size="16" xml:space="preserve">''']
    for row, spans in enumerate(data["lines"], 1):
        y = 65 + row * line_height
        if row == 6:
            parts.append(f'<rect x="0" y="{y-19}" width="{width}" height="25" fill="{palette["bg_alt"]}"/>')
        parts.append(f'<text x="46" y="{y}" text-anchor="end" fill="{palette["line_nr"]}" font-size="13">{row}</text>')
        text_parts = [f'<text x="72" y="{y}">']
        for span in spans:
            text_parts.append(f'<tspan fill="{span["color"]}">{html.escape(span["text"])}</tspan>')
        text_parts.append('</text>')
        parts.append(''.join(text_parts))
    parts.append('</g>')
    y = height - 36
    for i, (key, label) in enumerate([
        ("keyword", "keywords"), ("func", "functions"), ("type", "types"), ("string", "strings")
    ]):
        x = 72 + i * 180
        parts.append(f'<circle cx="{x}" cy="{y-5}" r="5" fill="{palette[key]}"/>')
        parts.append(f'<text x="{x+16}" y="{y}" font-family="system-ui, sans-serif" font-size="13" fill="{palette[key]}">{label}</text>')
    parts.append('</svg>')
    output = ROOT / 'assets' / f'preview-{variant}.svg'
    output.parent.mkdir(exist_ok=True)
    output.write_text('\n'.join(parts) + '\n', encoding='utf-8')
    print(f'Generated {output.relative_to(ROOT)}')
