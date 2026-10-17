"""Static stage-4 regression checks; does not parse or execute GDScript/Godot."""
from pathlib import Path
import importlib.util
import json
import re
import subprocess
import wave

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "game-inicial"
passed, errors = [], []


def check(ok, description):
    (passed if ok else errors).append(description)


def source(path):
    return (ROOT / path).read_text(encoding="utf-8-sig")


def previous(path):
    result = subprocess.run(["git", "show", f"HEAD:{path}"], cwd=ROOT, capture_output=True, check=True)
    return result.stdout.decode("utf-8-sig")


def fields(body):
    return dict(re.findall(r"^(\w+) = (.+)$", body, re.M))


for path in ["game-inicial/assets/maps/aurora_valley/aurora_valley.png"]:
    current = (ROOT / path).read_bytes()
    old = subprocess.run(["git", "show", f"HEAD:{path}"], cwd=ROOT, capture_output=True, check=True).stdout
    check(current == old, f"Project/map unchanged: {path}")
project_current = source("game-inicial/project.godot")
project_original = previous("game-inicial/project.godot")
check(project_current.replace("aurora_level_extended.tscn", "aurora_level.tscn") == project_original,
      "Project settings retained except Stage 6 main scene")
for path in sorted((PROJECT / "data/waves").glob("*.tres")):
    relative = path.relative_to(ROOT).as_posix()
    check(source(relative) == previous(relative), f"Wave unchanged: {relative}")
legacy_enemies = [PROJECT / "data/enemies/gremlin.tres", PROJECT / "data/enemies/golem.tres"]
for path in sorted((PROJECT / "data/towers").glob("*.tres")) + legacy_enemies:
    relative = path.relative_to(ROOT).as_posix()
    old, now = fields(previous(relative)), fields(source(relative))
    for key, value in old.items():
        if key not in {"bob_amplitude", "sway_degrees"}:
            check(now.get(key) == value, f"Existing gameplay/data preserved: {relative}:{key}")
    check(set(old).issubset(set(now)), f"Original fields retained: {relative}")

level_path = "game-inicial/scenes/world/aurora_level.tscn"
level_old, level_now = previous(level_path), source(level_path)
for pattern, label in [(r'"points": PackedVector2Array\([^)]+\)', "Path2D curve"),
                       (r'\[node name="Pad\d+"[^\]]*\]\s*position = Vector2\([^)]+\)\s*pad_id = \d+', "Seven pads")]:
    check(re.findall(pattern, level_old) == re.findall(pattern, level_now), f"Unchanged {label}")
check('process_mode = 1' in level_now, "Pausable World retained")
check('path="res://scripts/audio/aurora_audio.gd"' in level_now and '[node name="Audio"' in level_now,
      "Audio system attached to main scene")
check('path="res://scripts/effects/bell_pulse.gd"' in level_now and '[node name="BellPulse"' in level_now,
      "Bell pulse attached to world")

enemy = source("game-inicial/scripts/enemies/enemy.gd")
enemy_data = source("game-inicial/scripts/data/enemy_data.gd")
check('progress += data.speed * speed_multiplier * _slow_multiplier * delta' in enemy and
      'var speed_multiplier: float = 1.0' in enemy, "PathFollow movement retained with legacy default speed")
check('_static_sprite.position = Vector2(step * data.lateral_sway, cos(phase * 2.0) * data.bob_amplitude)' in enemy,
      "Static sprite uses bounded sway, not absolute upward bounce")
for name in ("stride_frequency", "lateral_sway", "squash_ratio", "lean_degrees"):
    check(f"@export var {name}:" in enemy_data, f"Tunable walk parameter: {name}")
gremlin = fields(source("game-inicial/data/enemies/gremlin.tres"))
golem = fields(source("game-inicial/data/enemies/golem.tres"))
for name, data in (("gremlin", gremlin), ("golem", golem)):
    check(0 < float(data["bob_amplitude"]) <= 0.4, f"Low bob: {name}")
    check(0 < float(data["squash_ratio"]) <= 0.005, f"Subtle squash: {name}")
    check("static_texture_path" in data and "walk_frames" not in data, f"Real static art remains active: {name}")
check(float(golem["bob_amplitude"]) < float(gremlin["bob_amplitude"]), "Golem is visually heavier")
check(float(golem["visual_height"]) > float(gremlin["visual_height"]), "Golem is visually larger")

hud_scene = source("game-inicial/scenes/ui/game_hud.tscn")
hud_script = source("game-inicial/scripts/ui/game_hud.gd")
for name in ("Top", "Lives", "Coins", "Wave", "Pause", "Toast", "BuildPanel", "Bell", "NextWave", "Restart", "Overlay"):
    check(f'[node name="{name}"' in hud_scene, f"HUD element: {name}")
check('visible = false' in hud_scene.split('[node name="Toast"')[1].split('[node name="Text"')[0], "Toast hidden initially")
check('mouse_filter = 2' in hud_scene.split('[node name="GameHUD"')[1].split('[node name="Top"')[0], "HUD root does not block map clicks")
check(hud_scene.count('parent="BuildPanel/Column/Choices"') == 3, "Three build choices retained")
for signal in ("next_wave_requested", "pause_requested", "restart_requested", "build_requested", "close_requested", "bell_requested"):
    check(f"signal {signal}" in hud_script, f"HUD signal: {signal}")
check("bell_button.disabled = not enabled or remaining > 0.05" in hud_script, "Bell disabled during cooldown/unavailable")

level = source("game-inicial/scripts/core/level.gd")
for guard in ("state != State.WAVE_ACTIVE", "_bell_remaining > 0.0", "_living.is_empty()"):
    check(guard in level.split("func _activate_bell()")[1].split("func _toggle_pause()")[0], f"Bell guard: {guard}")
check("enemy.apply_slow(bell_slow_multiplier, bell_slow_seconds)" in level, "Bell uses existing nonstacking slow")
check("if state in [State.PAUSED, State.VICTORY, State.DEFEAT]" in level, "Cooldown freezes on pause/end")

module_spec = importlib.util.spec_from_file_location("proto_audio", ROOT / "tools/generate_proto_audio.py")
module = importlib.util.module_from_spec(module_spec)
module_spec.loader.exec_module(module)
audio_script = source("game-inicial/scripts/audio/aurora_audio.gd")
declared = set(re.findall(r'&"([a-z_]+)"', audio_script.split("const CUES = [", 1)[1].split("]", 1)[0]))
check(declared == set(module.CUES), "Generated and registered cue names match")
check(len(list(module.OUT.glob("*.wav"))) == len(module.CUES), "No missing or redundant cue files")
for name, spec in module.CUES.items():
    path = module.OUT / f"{name}.wav"
    if not path.is_file():
        check(False, f"WAV exists: {name}")
        continue
    with wave.open(str(path), "rb") as wav:
        check((wav.getnchannels(), wav.getsampwidth(), wav.getframerate()) == (1, 2, module.RATE),
              f"WAV format: {name}")
        payload = wav.readframes(wav.getnframes())
        check(payload == module.synth(name, *spec), f"WAV exactly reproducible from local recipe: {name}")
        check(0.05 <= wav.getnframes() / wav.getframerate() <= 1.2, f"Short cue: {name}")
for cue in ("ui", "build", "wave", "arrow", "ice", "arcane", "impact", "kill", "escape", "pause", "victory", "defeat", "bell"):
    check(f'play_cue(&"{cue}")' in level + source("game-inicial/scripts/projectiles/projectile.gd") or cue == "impact" and 'play_cue(&"impact")' in source("game-inicial/scripts/projectiles/projectile.gd"), f"Cue wired: {cue}")

report = {"scope": "Static stage-4 validation; no Godot parser, import, input, gameplay or listening test.",
          "passed": len(passed), "errors": errors, "wav_count": len(module.CUES), "checks": passed}
out = ROOT / "docs/validation/etapa4_static_checks.json"
out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(json.dumps({k: v for k, v in report.items() if k != "checks"}, ensure_ascii=False, indent=2))
raise SystemExit(1 if errors else 0)
