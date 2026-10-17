"""Static resource/scene/data checks. Does NOT parse or execute GDScript."""
from pathlib import Path
import argparse
import hashlib
import json
import math
import re
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "game-inicial"
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--output", default="docs/validation/etapa2_static.json")
parser.add_argument("--preview", default="docs/assets/route_validation.png")
args = parser.parse_args()
errors = []
checks = []


def check(condition, message):
    (checks if condition else errors).append(message)


def text(path):
    return path.read_text(encoding="utf-8-sig")


resource_files = sorted(p for p in PROJECT.rglob("*")
                        if p.suffix in {".gd", ".tscn", ".tres", ".godot", ".import"}
                        and ".godot" not in p.parts)
references = 0
classes = {}
scene_nodes = {}
for path in resource_files:
    body = text(path)
    for ref in re.findall(r'res://[^"\s)]+', body):
        if ref.startswith("res://.godot/") or "%" in ref:
            # Formatted paths are validated by the subsystem-specific checker.
            continue
        references += 1
        check((PROJECT / ref[6:]).is_file(), f"Reference exists: {ref}")
    if path.suffix == ".gd":
        match = re.search(r"^class_name (\w+)", body, re.M)
        if match:
            check(match[1] not in classes, f"Unique class: {match[1]}")
            classes[match[1]] = path
    if path.suffix in {".tscn", ".tres"}:
        for kind, definition in (("ExtResource", "ext_resource"), ("SubResource", "sub_resource")):
            identifiers = re.findall(r'\[' + definition + r' [^\]]*\bid="([^"]+)"', body)
            check(len(identifiers) == len(set(identifiers)), f"Unique {kind} IDs: {path.name}")
            for ref in re.findall(kind + r'\("([^"]+)"\)', body):
                check(ref in identifiers, f"Declared {kind}: {path.name}:{ref}")
    if path.suffix == ".tscn":
        nodes = {"."}
        for declaration in re.findall(r"\[node [^\]]+\]", body):
            name = re.search(r'name="([^"]+)"', declaration)[1]
            parent = re.search(r'parent="([^"]+)"', declaration)
            if parent:
                check(parent[1] in nodes, f"Parent exists: {path.name}:{parent[1]}")
                full_path = name if parent[1] == "." else parent[1] + "/" + name
                check(full_path not in nodes, f"Unique node: {path.name}:{full_path}")
                nodes.add(full_path)
        scene_nodes[path.name] = nodes

bindings = {"core/level.gd": "aurora_level.tscn", "ui/game_hud.gd": "game_hud.tscn",
            "enemies/enemy.gd": "gremlin.tscn", "towers/tower_pad.gd": "tower_pad.tscn"}
for script, scene in bindings.items():
    for node_path in re.findall(r'\$([A-Za-z_][A-Za-z_0-9/]*)', text(PROJECT / "scripts" / script)):
        check(node_path in scene_nodes[scene], f"Node binding: {script}:${node_path}")

level = text(PROJECT / "scenes/world/aurora_level.tscn")
check('process_mode = 3' in level.split('[node name="World"')[0], "Controller processes while paused")
for name in ("World", "Waves"):
    section = re.search(r'\[node name="' + name + r'"[^\]]*\]([^\[]+)', level)[1]
    check("process_mode = 1" in section, f"{name} pauses with SceneTree")
main_scene_match = re.search(r'run/main_scene="res://([^"]+)"', text(PROJECT / "project.godot"))
check(main_scene_match is not None and (PROJECT / main_scene_match[1]).is_file(), "Active main scene exists")
check('mapa_rotas' not in level, "Annotated map absent from gameplay")

waves = []
for path in sorted((PROJECT / "data/waves").glob("*.tres")):
    body = text(path)
    counts = [int(x) for x in re.search(r'counts = Array\[int\]\(\[([^\]]+)\]', body)[1].split(',')]
    interval = float(re.search(r'spawn_interval = ([\d.]+)', body)[1])
    scene_count = len(re.search(r'enemy_scenes = Array\[PackedScene\]\(\[([^\]]+)\]', body)[1].split(','))
    check(len(counts) == scene_count and min(counts) > 0 and interval > 0, f"Valid wave data: {path.name}")
    waves.append(sum(counts))
check(len(waves) == 5 and waves == sorted(waves), "Five progressive waves")

# Sample serialized Bezier segments to measure geometry in source-map coordinates.
numbers = [float(x) for x in re.search(r'"points": PackedVector2Array\(([^)]+)\)', level)[1].split(',')]
control = [numbers[i:i + 6] for i in range(0, len(numbers), 6)]
samples = []
for left, right in zip(control, control[1:]):
    a, b = left[4:6], [left[4] + left[2], left[5] + left[3]]
    c, d = [right[4] + right[0], right[5] + right[1]], right[4:6]
    for step in range(40):
        t = step / 40
        samples.append(tuple((1-t)**3*a[k] + 3*(1-t)**2*t*b[k] + 3*(1-t)*t*t*c[k] + t**3*d[k] for k in (0, 1)))
samples.append(tuple(control[-1][4:6]))
length = sum(math.dist(a, b) for a, b in zip(samples, samples[1:]))
check(900 < length < 1500, "Route length within expected map scale")
pads = []
for match in re.finditer(r'\[node name="Pad(\d+)"[^\]]*\]\s*position = Vector2\(([^,]+), ([^)]+)\)\s*pad_id = (\d+)', level):
    pads.append((int(match[1]), float(match[2]), float(match[3])))
check(len(pads) == 7 and len(set(p[0] for p in pads)) == 7, "Seven unique valid pads")
check(3 not in [p[0] for p in pads], "Rock location 3 excluded")
ranges = {}
for path in sorted((PROJECT / "data/towers").glob("*.tres")):
    body = text(path)
    ranges[path.stem] = float(re.search(r'attack_range = ([\d.]+)', body)[1])
    for key in ("cost", "damage", "attack_interval", "projectile_speed"):
        check(float(re.search(key + r' = ([\d.]+)', body)[1]) > 0, f"Positive {key}: {path.stem}")

geometry = []
for pad_id, x, y in pads:
    nearest = min(math.dist((x, y), sample) for sample in samples)
    check(nearest > 31, f"Pad {pad_id} footprint clear of active route")
    coverage = {kind: round(sum(math.dist((x, y), p) <= radius for p in samples) / len(samples), 3)
                for kind, radius in ranges.items()}
    for kind, coverage_ratio in coverage.items():
        check(coverage_ratio > 0, f"{kind} reaches route from pad {pad_id}")
    geometry.append({"pad": pad_id, "position": [x, y], "nearest_route": round(nearest, 2), "coverage_sample_ratio": coverage})

# An annotation for engineering review, not a gameplay screenshot or edited asset.
with Image.open(PROJECT / "assets/maps/aurora_valley/aurora_valley.png") as source:
    preview = source.convert("RGB")
draw = ImageDraw.Draw(preview)
draw.line(samples, fill="#ff574c", width=3)
for pad_id, x, y in pads:
    draw.ellipse((x-27, y-17, x+27, y+17), outline="#87ffdd", width=3)
    draw.text((x-5, y-6), str(pad_id), fill="white", stroke_width=2, stroke_fill="black")
preview.save(ROOT / args.preview)

audit = json.loads(text(ROOT / "docs/assets/pixel_audit.json"))
for image in audit:
    current = hashlib.sha256((ROOT / image["source"]).read_bytes()).hexdigest()
    check(current == image["sha256"], f"Original unchanged: {image['source']}")
check((ROOT / "img/mapa.png").read_bytes() == (PROJECT / "assets/maps/aurora_valley/aurora_valley.png").read_bytes(), "Map copy identical")
report = {"scope": "Static only; no GDScript parser, import or runtime execution.",
          "passed": len(checks), "errors": errors, "reference_count": references,
          "route_length_source_pixels": round(length, 2), "wave_totals": waves,
          "unimpeded_travel_seconds": {"gremlin": round(length / 48, 2), "golem": round(length / 26.4, 2)},
          "pads": geometry, "checks": checks}
destination = ROOT / args.output
destination.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(json.dumps({k: v for k, v in report.items() if k not in {"checks", "pads"}}, ensure_ascii=True, indent=2))
raise SystemExit(1 if errors else 0)
