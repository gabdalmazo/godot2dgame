"""Install approved image_gen outputs unchanged and audit their alpha/pivots.

No image editing occurs here: images are copied byte-for-byte, never regenerated.
Re-running reuses the installed artifact if the generated source is unavailable.
"""
from pathlib import Path
import hashlib
import json
import shutil
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
recipe = json.loads((ROOT / "tools/visual_assets_recipe.json").read_text(encoding="utf-8"))
rows = []
for entry in recipe["assets"]:
    source = Path(entry["generated_source"])
    destination = ROOT / entry["destination"]
    if source.exists():
        if destination.exists() and destination.read_bytes() != source.read_bytes():
            raise RuntimeError(f"Refusing to overwrite a different asset: {destination}")
        destination.parent.mkdir(parents=True, exist_ok=True)
        if not destination.exists():
            shutil.copy2(source, destination)
    if not destination.is_file():
        raise FileNotFoundError(f"Approved output unavailable: {destination}")
    with Image.open(destination) as image:
        assert image.mode == "RGBA", f"Missing alpha: {destination}"
        alpha = image.getchannel("A")
        histogram = alpha.histogram()
        assert histogram[0] > image.width * image.height * 0.1
        assert histogram[255] > 0, f"No opaque subject: {destination}"
        bbox = alpha.point(lambda value: 255 if value >= 32 else 0).getbbox()
        assert bbox and bbox[0] > 0 and bbox[1] > 0
        assert bbox[2] < image.width and bbox[3] < image.height, f"Clipped subject: {destination}"
        row = {"id": entry["id"], "original": entry["source"],
               "path": entry["destination"], "size": list(image.size),
               "alpha_bounds_32": list(bbox), "transparent_pixels": histogram[0],
               "partial_alpha_pixels": sum(histogram[1:255]), "opaque_pixels": histogram[255],
               "original_sha256": hashlib.sha256((ROOT / entry["source"]).read_bytes()).hexdigest(),
               "sha256": hashlib.sha256(destination.read_bytes()).hexdigest()}
        rows.append(row)
        print(f"{entry['id']}: {image.size}, bounds={bbox}, alpha0={histogram[0]}")
out = ROOT / "docs/assets/etapa3_processed_audit.json"
out.write_text(json.dumps(rows, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
