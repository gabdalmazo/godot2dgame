"""Read-only pixel audit of originals; copies only the playable map unchanged."""
from pathlib import Path
import hashlib
import json
import shutil
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
rows = []
for source in sorted((ROOT / "img").iterdir()):
    if not source.is_file():
        continue
    with Image.open(source) as image:
        histogram = image.convert("RGBA").getchannel("A").histogram()
        rows.append({
            "source": source.relative_to(ROOT).as_posix(),
            "format": image.format, "size": list(image.size), "mode": image.mode,
            "transparent_pixels": histogram[0],
            "partial_alpha_pixels": sum(histogram[1:255]),
            "opaque_pixels": histogram[255],
            "sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        })
destination = ROOT / "game-inicial/assets/maps/aurora_valley/aurora_valley.png"
destination.parent.mkdir(parents=True, exist_ok=True)
shutil.copy2(ROOT / "img/mapa.png", destination)
assert destination.read_bytes() == (ROOT / "img/mapa.png").read_bytes()
out = ROOT / "docs/assets/pixel_audit.json"
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(json.dumps(rows, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
for row in rows:
    print(f"{row['source']}: {row['size']}, alpha0={row['transparent_pixels']}, "
          f"alpha1..254={row['partial_alpha_pixels']}, alpha255={row['opaque_pixels']}")
