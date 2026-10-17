"""Static HUD contract checks; intentionally does not invoke Godot."""

from __future__ import annotations

import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game-inicial"
scene = (GAME / "scenes/ui/game_hud.tscn").read_text(encoding="utf-8-sig")
script = (GAME / "scripts/ui/game_hud.gd").read_text(encoding="utf-8-sig")
level = (GAME / "scripts/core/level.gd").read_text(encoding="utf-8-sig")
checks: list[str] = []
errors: list[str] = []


def check(condition: bool, label: str) -> None:
    (checks if condition else errors).append(label)


nodes = set()
for name, parent in re.findall(r'\[node name="([^"]+)" type="[^"]+"(?: parent="([^"]+)")?', scene):
    nodes.add(name if not parent or parent == "." else f"{parent}/{name}")
for path in re.findall(r"@onready var \w+: \w+ = \$([^\s]+)", script):
    check(path in nodes, f"@onready path: {path}")

for signal in (
    "next_wave_requested", "pause_requested", "restart_requested",
    "build_requested", "close_requested", "bell_requested", "ui_interacted",
):
    check(f"signal {signal}" in script, f"HUD signal: {signal}")
    check(f"hud.{signal}.connect(" in level, f"Level connection: {signal}")

for name in ("Archer", "Ice", "Arcane"):
    check(f"BuildPanel/Column/Choices/{name}" in nodes, f"Tower card: {name}")
check(scene.count('parent="BuildPanel/Column/Choices"') == 3, "Exactly three card buttons")
check('mouse_filter = 2' in scene.split('[node name="GameHUD"')[1].split('[node name="Top"')[0], "HUD root passes map clicks")
check('visible = false' in scene.split('[node name="BuildPanel"')[1].split('[node name="Column"')[0], "Build panel hidden initially")
check('visible = false' in scene.split('[node name="Toast"')[1].split('[node name="Text"')[0], "Toast hidden initially")
check('"res://assets/ui/aurora/' not in level, "Level gameplay does not depend on HUD ornaments")
check("AuroraVisualAssets.load_texture(data.texture_path)" in script, "Card art loaded from tower Resource path")
check("button.disabled = not allowed or coins < data.cost" in script, "Affordability gate")
check("next_wave.disabled = not can_start" in script, "Wave button gate")
check("bell_button.disabled = not enabled or remaining > 0.05" in script, "Bell gate")
check("cooldown_bar.value" in script, "Bell cooldown progress")
check("_occupied_info = true" in script and "build_buttons.hide()" in script, "Occupied pad view")
check("img/hud_nova" not in scene and "img/hud_nova" not in script, "No baked reference image in HUD")

for relative in re.findall(r'\[ext_resource type="Texture2D" path="res://([^"]+)"', scene):
    path = GAME / relative
    check(path.is_file(), f"Texture exists: {relative}")
    if path.suffix == ".svg" and path.is_file():
        try:
            root = ET.parse(path).getroot()
            check(root.tag.endswith("svg"), f"SVG parses: {relative}")
        except ET.ParseError:
            check(False, f"SVG parses: {relative}")

with Image.open(ROOT / "img/hud_nova.jpg") as reference:
    check(reference.size == (1024, 572), "Reference dimensions 1024x572")
    check(reference.mode == "RGB", "Reference is opaque composite JPEG")

for relative in ("game_hud.gd", "game_hud.tscn"):
    check((ROOT / ".tools/etapa5_baseline" / relative).is_file(), f"Baseline backup: {relative}")

result = {"scope": "Static Stage 5 checks; no Godot parser, import or gameplay run", "passed": len(checks), "errors": errors}
print(json.dumps(result, ensure_ascii=False, indent=2))
raise SystemExit(1 if errors else 0)
