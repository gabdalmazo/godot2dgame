"""Build the optional extended scene from the preserved base scene."""

from __future__ import annotations

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "game-inicial/scenes/world/aurora_level.tscn"
OUTPUT = ROOT / "game-inicial/scenes/world/aurora_level_extended.tscn"

# Hand-traced center of the lower, longer branch on the 1024x572 unannotated map.
POINTS = [
    (-12, 275), (48, 292), (106, 336), (158, 353), (204, 340),
    (230, 304), (251, 264), (283, 241), (310, 241), (330, 257),
    (343, 287), (365, 329), (400, 360), (445, 383), (495, 400),
    (548, 406), (599, 394), (642, 367), (672, 335), (690, 293),
    (706, 298), (721, 311), (761, 325), (800, 318), (827, 297),
    (846, 265), (869, 232), (893, 214), (915, 205),
]


def curve_values() -> str:
    values: list[float] = []
    for index, (x, y) in enumerate(POINTS):
        before = POINTS[max(0, index - 1)]
        after = POINTS[min(len(POINTS) - 1, index + 1)]
        tx = (after[0] - before[0]) * 0.23
        ty = (after[1] - before[1]) * 0.23
        values.extend((-tx, -ty, tx, ty, x, y))
    return ", ".join(f"{value:.3f}".rstrip("0").rstrip(".") for value in values)


def replace_once(body: str, old: str, new: str) -> str:
    if body.count(old) != 1:
        raise ValueError(f"Expected exactly one occurrence: {old[:80]}")
    return body.replace(old, new)


def main() -> None:
    body = SOURCE.read_text(encoding="utf-8-sig")
    body = replace_once(body, "[gd_scene load_steps=19 format=3]", "[gd_scene load_steps=23 format=3]")
    body = replace_once(body, '[node name="AuroraLevel" type="Node2D"]', '[node name="AuroraLevelExtended" type="Node2D"]')
    for number in range(1, 6):
        old = f'res://data/waves/wave_{number:02}.tres'
        body = replace_once(body, old, f'res://data/extended/waves/wave_{number:02}.tres')
    anchor = '[ext_resource type="Script" path="res://scripts/audio/aurora_audio.gd" id="audio"]'
    body = replace_once(body, anchor, '\n'.join([
        '[ext_resource type="Resource" path="res://data/extended/waves/wave_06.tres" id="wave6"]',
        '[ext_resource type="Resource" path="res://data/extended/waves/wave_07.tres" id="wave7"]',
        '[ext_resource type="Script" path="res://scripts/world/final_base.gd" id="final_base"]',
        '[ext_resource type="AudioStream" path="res://assets/audio/music/aurora_fantasy_loop.wav" id="music"]',
        anchor,
    ]))
    body, count = re.subn(r'"points": PackedVector2Array\([^)]+\)',
                          lambda _match: f'"points": PackedVector2Array({curve_values()})', body)
    if count != 1:
        raise ValueError("Could not replace original Curve2D")
    pad8 = '[node name="Pad8" parent="World/TowerPads" instance=ExtResource("pad")]\nposition = Vector2(735, 371)\npad_id = 8'
    body = replace_once(body, pad8, pad8 + '\n\n[node name="Pad9" parent="World/TowerPads" instance=ExtResource("pad")]\nposition = Vector2(455, 315)\npad_id = 9')
    bell = '[node name="BellPulse" type="Node2D" parent="World"]\nposition = Vector2(915, 205)\nz_index = 3200\nscript = ExtResource("bell_pulse")'
    body = replace_once(body, bell, bell + '\n\n[node name="FinalBase" type="Node2D" parent="World"]\nposition = Vector2(915, 205)\nz_index = 900\nscript = ExtResource("final_base")')
    waves = 'waves = Array[ExtResource("wave_type")]([ExtResource("wave1"), ExtResource("wave2"), ExtResource("wave3"), ExtResource("wave4"), ExtResource("wave5")])'
    body = replace_once(body, waves, 'waves = Array[ExtResource("wave_type")]([ExtResource("wave1"), ExtResource("wave2"), ExtResource("wave3"), ExtResource("wave4"), ExtResource("wave5"), ExtResource("wave6"), ExtResource("wave7")])')
    audio = '[node name="Audio" type="Node" parent="."]\nprocess_mode = 3\nscript = ExtResource("audio")'
    body = replace_once(body, audio, audio + '\nmusic_stream = ExtResource("music")\nmusic_volume_db = -11.0')
    OUTPUT.write_text(body, encoding="utf-8", newline="\n")
    print(f"Wrote {OUTPUT.relative_to(ROOT)} with {len(POINTS)} route points and 7 waves")


if __name__ == "__main__":
    main()
