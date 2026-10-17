"""Render a diagnostic overlay; never modifies or ships the source map."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

from build_extended_level import POINTS


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs/assets/etapa6_extended_route.png"
with Image.open(ROOT / "img/mapa.png") as source:
    preview = source.convert("RGB")
draw = ImageDraw.Draw(preview)
draw.line(POINTS, fill=(236, 45, 43), width=3, joint="curve")
for x, y in POINTS:
    draw.ellipse((x - 2, y - 2, x + 2, y + 2), fill=(255, 245, 195))
draw.ellipse((428, 288, 482, 342), outline=(255, 220, 88), width=3)
draw.text((447, 303), "9", fill=(30, 24, 18))
OUT.parent.mkdir(parents=True, exist_ok=True)
preview.save(OUT)
print(OUT.relative_to(ROOT))
