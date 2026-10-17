"""Check expanded-phase data and old-scene preservation without launching Godot."""

from __future__ import annotations

import hashlib
import json
import math
import re
import wave
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game-inicial"
checks: list[str] = []
errors: list[str] = []


def check(condition: bool, label: str) -> None:
    (checks if condition else errors).append(label)


def body(path: str) -> str:
    return (GAME / path).read_text(encoding="utf-8-sig")


def field(text: str, name: str, default: str = "") -> str:
    found = re.search(rf"^{re.escape(name)} = (.+)$", text, re.M)
    return found[1] if found else default


def route_length(scene: str) -> float:
    numbers = [float(value) for value in re.search(r'"points": PackedVector2Array\(([^)]+)\)', scene)[1].split(",")]
    control = [numbers[i:i + 6] for i in range(0, len(numbers), 6)]
    samples = []
    for left, right in zip(control, control[1:]):
        a = left[4:6]
        b = [left[4] + left[2], left[5] + left[3]]
        c = [right[4] + right[0], right[5] + right[1]]
        d = right[4:6]
        for step in range(40):
            t = step / 40
            samples.append(tuple((1-t)**3*a[k] + 3*(1-t)**2*t*b[k] + 3*(1-t)*t*t*c[k] + t**3*d[k] for k in (0, 1)))
    samples.append(tuple(control[-1][4:6]))
    check(len(control) >= 20, "Extended route has multiple manually traced points")
    check(all(-25 <= x <= 1024 and 0 <= y <= 572 for x, y in samples), "Extended route stays on map bounds")
    check(math.dist(control[-1][4:6], (915, 205)) < 1, "Route ends at bell tower")
    return sum(math.dist(a, b) for a, b in zip(samples, samples[1:]))


base_scene = body("scenes/world/aurora_level.tscn")
extended = body("scenes/world/aurora_level_extended.tscn")
base_length = route_length(base_scene)
extended_length = route_length(extended)
check(extended_length > base_length * 1.04, "Extended branch is measurably longer")
check('run/main_scene="res://scenes/world/aurora_level_extended.tscn"' in body("project.godot"), "F5 opens extended phase")
check('[node name="Pad9" parent="World/TowerPads"' in extended and 'pad_id = 9' in extended, "Eighth tactical pad")
check('[node name="FinalBase" type="Node2D" parent="World"]' in extended, "Final-base damage overlay attached")
check('path="res://assets/audio/music/aurora_fantasy_loop.wav"' in extended, "Music attached to extended scene")
check('path="res://scenes/ui/game_hud.tscn"' in extended, "Stage 5 HUD reused")
backup = ROOT / ".tools/etapa6_baseline/game-inicial/scenes/world/aurora_level.tscn"
check(backup.is_file() and hashlib.sha256(backup.read_bytes()).digest() == hashlib.sha256((GAME / "scenes/world/aurora_level.tscn").read_bytes()).digest(), "Original level preserved byte for byte")

wave_files = sorted((GAME / "data/extended/waves").glob("wave_*.tres"))
check(len(wave_files) == 7, "Seven extended waves")
totals = []
health = []
speed = []
for index, path in enumerate(wave_files):
    wave_text = path.read_text(encoding="utf-8-sig")
    counts = [int(value) for value in re.search(r'counts = Array\[int\]\(\[([^]]+)\]\)', wave_text)[1].split(",")]
    scene_count = len(re.search(r'enemy_scenes = Array\[PackedScene\]\(\[([^]]+)\]\)', wave_text)[1].split(","))
    has_boss = bool(field(wave_text, "boss_scene"))
    totals.append(sum(counts) + int(has_boss))
    health.append(float(field(wave_text, "health_multiplier", "1.0")))
    speed.append(float(field(wave_text, "speed_multiplier", "1.0")))
    check(len(counts) == scene_count and all(count > 0 for count in counts), f"Wave {index+1} species/counts")
    check(has_boss == (index == 6), f"Boss only on final wave {index+1}")
    check(float(field(wave_text, "spawn_interval")) > 0, f"Wave {index+1} interval")
check(totals[:6] == sorted(totals[:6]) and totals[0] < totals[-1], "Support pressure grows through waves")
check(health == sorted(health) and speed == sorted(speed), "Health/speed scale gradually")
check('if waves.wave_index + 1 == waves.waves.size():' in body("scripts/core/level.gd") and
      'waves.spawning or not _living.is_empty()' in body("scripts/core/level.gd"), "Victory waits for boss resolution")
check('_queue.append(wave.boss_scene)' in body("scripts/systems/wave_manager.gd"), "Boss spawns after support queue")

boss_data = body("data/enemies/boss.tres")
check('path="res://data/enemies/boss.tres"' in body("scenes/enemies/boss.tscn"), "Boss scene loads boss Resource")
check(float(field(boss_data, "max_health")) >= 5 * float(field(body("data/enemies/golem.tres"), "max_health")), "Boss has high health")
check(float(field(boss_data, "speed")) < float(field(body("data/enemies/golem.tres"), "speed")), "Boss advances slowly")
check(int(field(boss_data, "reward")) > int(field(body("data/enemies/golem.tres"), "reward")), "Boss rewards more coins")
check(float(field(boss_data, "damage_reduction")) > 0 and float(field(boss_data, "slow_resistance_floor")) > 0.55, "Boss armor and slow resistance")

upgrades: dict[str, list[dict[str, str]]] = {}
for kind in ("archer", "ice", "arcane"):
    chain = [body(f"data/towers/{kind}.tres"), body(f"data/upgrades/{kind}_2.tres"), body(f"data/upgrades/{kind}_3.tres")]
    values = [{name: field(resource, name) for name in ("level", "cost", "damage", "attack_range", "attack_interval", "slow_multiplier", "splash_radius", "texture_path", "next_level")} for resource in chain]
    upgrades[kind] = values
    check(values[0]["level"] == "" and values[1]["level"] == "2" and values[2]["level"] == "3", f"{kind}: levels 1-3")
    check(bool(values[0]["next_level"]) and bool(values[1]["next_level"]) and not values[2]["next_level"], f"{kind}: finite upgrade chain")
    check(all(int(level["cost"]) > 0 for level in values), f"{kind}: positive costs")
    check(all(float(a["damage"]) < float(b["damage"]) for a, b in zip(values, values[1:])), f"{kind}: rising damage")
    check(all(float(a["attack_range"]) < float(b["attack_range"]) for a, b in zip(values, values[1:])), f"{kind}: rising range")
    check(all(float(a["attack_interval"]) >= float(b["attack_interval"]) for a, b in zip(values, values[1:])), f"{kind}: cadence does not regress")
    check(all((GAME / level["texture_path"].strip('"').removeprefix("res://")).is_file() for level in values), f"{kind}: all level artwork fallbacks exist")
check(float(upgrades["ice"][0]["slow_multiplier"]) > float(upgrades["ice"][1]["slow_multiplier"]) > float(upgrades["ice"][2]["slow_multiplier"]), "Ice slow strengthens")
check(float(upgrades["arcane"][0]["splash_radius"]) < float(upgrades["arcane"][1]["splash_radius"]) < float(upgrades["arcane"][2]["splash_radius"]), "Arcane blast expands")

level = body("scripts/core/level.gd")
hud = body("scripts/ui/game_hud.gd")
check("hud.upgrade_requested.connect(_upgrade_selected_tower)" in level and "signal upgrade_requested" in hud, "Upgrade HUD signal connected")
check("coins -= next_data.cost" in level and "tower.upgrade_to(next_data)" in level, "Upgrade transaction")
check("upgrade_button.disabled = next_data == null or not allowed or coins < next_data.cost" in hud, "Upgrade affordability gate")
check("set_boss_wave" in hud and "ONDA DE CHEFE" in level, "Boss HUD announcement")
check("update_integrity(lives, starting_lives)" in level and "damage_stage" in body("scripts/world/final_base.gd"), "Base degradation connected to lives")

music_path = GAME / "assets/audio/music/aurora_fantasy_loop.wav"
with wave.open(str(music_path), "rb") as wav:
    check((wav.getnchannels(), wav.getsampwidth(), wav.getframerate()) == (1, 2, 22050), "Music PCM mono format")
    check(wav.getnframes() == 16 * 22050, "Music 16-second loop")
    samples = wav.readframes(wav.getnframes())
    first = int.from_bytes(samples[:2], "little", signed=True)
    last = int.from_bytes(samples[-2:], "little", signed=True)
    check(abs(first - last) < 400, "Loop boundary has small sample discontinuity")
check("set_music_paused(state == State.PAUSED)" in level and "sfx_volume_db" in body("scripts/audio/aurora_audio.gd"), "Music pause and separate SFX gain")

result = {"scope": "Static Stage 6 checks; Godot parser/import/runtime not run", "passed": len(checks), "errors": errors,
          "route_length_original": round(base_length, 2), "route_length_extended": round(extended_length, 2),
          "extended_wave_totals": totals}
output = ROOT / "docs/validation/etapa6_static.json"
output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(json.dumps(result, ensure_ascii=False, indent=2))
raise SystemExit(1 if errors else 0)
