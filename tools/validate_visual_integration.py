"""Verify assets and stage-2 preservation contract; does not execute Godot/GDScript."""
from pathlib import Path
import hashlib
import json
import re
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "game-inicial"
checks, errors = [], []


def check(condition, message):
    (checks if condition else errors).append(message)


def text(path):
    return path.read_text(encoding="utf-8-sig")


def digest(body):
    return hashlib.sha256(body.encode("utf-8")).hexdigest()


contract = json.loads(text(ROOT / "docs/validation/etapa3_gameplay_contract.json"))
for relative, functions in contract["functions"].items():
    body = text(PROJECT / relative)
    # Remove only the explicit visual additions. Any other function difference fails.
    if relative == "scripts/enemies/enemy.gd":
        body = body.replace("\telif _using_static:\n\t\t_update_static_visual()\n", "")
        body = body.replace("\tz_index = AuroraVisualAssets.depth_at(position.y)\n", "")
    if relative == "scripts/projectiles/projectile.gd":
        body = body.replace("\teffect.texture = AuroraVisualAssets.load_texture(data.impact_texture_path)\n", "")
    for name, expected in functions.items():
        match = re.search(r"^func "+re.escape(name)+r"\([^\n]*\n.*?(?=^func |\Z)", body, re.M | re.S)
        check(match is not None and digest(match[0].strip()) == expected,
              f"Gameplay function preserved: {relative}:{name}")

visual_fields = {"texture_path", "texture_scale", "texture_offset", "projectile_texture_path",
                 "projectile_texture_scale", "projectile_texture_rotation_degrees", "impact_texture_path",
                 "static_texture_path", "static_scale", "static_pivot", "visual_height",
                 "health_bar_width", "bob_amplitude", "sway_degrees"}
for relative, old in contract["data"].items():
    current = dict(re.findall(r"^(\w+) = (.+)$", text(PROJECT / relative), re.M))
    for key, value in old.items():
        check(current.get(key) == value, f"Data preserved: {relative}:{key}")
    check(set(current) - set(old) <= visual_fields, f"Only visual data added: {relative}")

for relative in ["scenes/world/aurora_level.tscn", "scenes/ui/game_hud.tscn"]:
    body = text(PROJECT / relative)
    if "ui/" in relative:
        body = re.sub(r'(\[node name="PrototypeNote"[^\]]*\][\s\S]*?^text = ).*$', r'\1"<visual-note>"', body, count=1, flags=re.M)
    check(digest(body) == contract[relative], f"Scene preserved except documented visuals: {relative}")

initial = json.loads(text(ROOT / "docs/validation/etapa3_initial_files.json"))
protected = [item for item in initial if item["path"].startswith("img/") or item["path"] in {
    "game-inicial/project.godot", "game-inicial/scripts/core/level.gd",
    "game-inicial/scripts/systems/wave_manager.gd", "game-inicial/scripts/ui/game_hud.gd",
    "game-inicial/scripts/towers/tower_pad.gd", "game-inicial/assets/maps/aurora_valley/aurora_valley.png"}]
for item in protected:
    path = ROOT / item["path"]
    check(path.is_file() and hashlib.sha256(path.read_bytes()).hexdigest().lower() == item["sha256"].lower(),
          f"Protected file byte-identical: {item['path']}")

audit = json.loads(text(ROOT / "docs/assets/etapa3_processed_audit.json"))
approved = {row["id"]: row["sha256"] for row in audit}
recipe = json.loads(text(ROOT / "tools/visual_assets_recipe.json"))
all_resources = "\n".join(text(p) for p in (PROJECT / "data").rglob("*.tres"))
memory = 0
for spec in recipe["assets"]:
    path = ROOT / spec["destination"]
    check(path.is_file(), f"Processed asset present: {spec['id']}")
    if not path.is_file():
        continue
    check(hashlib.sha256(path.read_bytes()).hexdigest() == approved.get(spec["id"]),
          f"Approved output unchanged: {spec['id']}")
    with Image.open(path) as image:
        check(image.mode == "RGBA", f"RGBA: {spec['id']}")
        alpha = image.convert("RGBA").getchannel("A")
        check(alpha.getextrema() == (0, 255), f"Real transparent and opaque pixels: {spec['id']}")
        bbox = alpha.point(lambda p: 255 if p >= 32 else 0).getbbox()
        check(bbox is not None and bbox[0] > 0 and bbox[1] > 0 and bbox[2] < image.width and bbox[3] < image.height,
              f"Visible silhouette has margins at alpha >=32: {spec['id']}")
        memory += image.width * image.height * 4
    res = "res://"+path.relative_to(PROJECT).as_posix()
    check(res in all_resources, f"Asset assigned in resource: {spec['id']}")

enemy = text(PROJECT / "scripts/enemies/enemy.gd")
loader = text(PROJECT / "scripts/visuals/visual_assets.gd")
check('ResourceLoader.exists(path, "Texture2D")' in loader and "_cache.has(path)" in loader,
      "Optional texture loader checks existence and caches loads/failures (source inspection)")
check("if not _using_frames and not _using_static:" in enemy, "Procedural fallback retained (source inspection)")
check("data.prefer_walk_frames or static_texture == null" in enemy, "SpriteFrames optional (source inspection)")
for path in (PROJECT / "data/enemies").glob("*.tres"):
    check("walk_frames =" not in text(path), f"Rejected sheets not assigned: {path.name}")

report = {"scope": "Static preservation and asset audit only. No GDScript parser/import/runtime.",
          "passed": len(checks), "errors": errors, "processed_asset_count": len(recipe["assets"]),
          "rgba_texture_memory_mib_before_engine_compression": round(memory / 1024**2, 2), "checks": checks}
(ROOT / "docs/validation/etapa3_visual_static.json").write_text(json.dumps(report, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
print(json.dumps({key: value for key, value in report.items() if key != "checks"}, ensure_ascii=True, indent=2))
raise SystemExit(1 if errors else 0)
