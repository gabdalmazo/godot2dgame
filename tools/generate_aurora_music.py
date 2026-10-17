"""Generate a deterministic, seamless provisional fantasy ambience with stdlib only."""

from __future__ import annotations

import math
import struct
import wave
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "game-inicial/assets/audio/music/aurora_fantasy_loop.wav"
RATE = 22050
DURATION = 16.0
CHORDS = [
    (146.83, 174.61, 220.00),  # D minor
    (116.54, 146.83, 174.61),  # B flat major
    (174.61, 220.00, 261.63),  # F major
    (130.81, 164.81, 196.00),  # C major
]


def periodic_frequency(value: float) -> float:
    return round(value * DURATION) / DURATION


def sample(t: float) -> float:
    section = int(t // 4.0)
    inside = t - section * 4.0
    blend = max(0.0, min(1.0, inside - 3.0))
    blend = blend * blend * (3.0 - 2.0 * blend)
    pad = 0.0
    for chord_index, weight in ((section, 1.0 - blend), ((section + 1) % 4, blend)):
        for note, frequency in enumerate(CHORDS[chord_index]):
            f = periodic_frequency(frequency)
            pad += weight * (0.045 / (note + 1)) * math.sin(math.tau * f * t + note * 0.4)
            pad += weight * 0.010 * math.sin(math.tau * f * 2.0 * t + note)
    bell = 0.0
    step = int(t / 0.5)
    for offset in (0, 1, 2):
        trigger = (step - offset) % 32
        age = (t - trigger * 0.5) % DURATION
        if age > 1.5:
            continue
        chord = CHORDS[trigger // 8]
        note = chord[(0, 1, 2, 1, 2, 1, 0, 1)[trigger % 8]] * 2.0
        f = periodic_frequency(note)
        envelope = (1.0 - math.exp(-age * 28.0)) * math.exp(-age * 5.2)
        bell += 0.070 * envelope * math.sin(math.tau * f * t)
    breath = 0.013 * math.sin(math.tau * periodic_frequency(73.42) * t)
    return max(-0.95, min(0.95, pad + bell + breath))


def main() -> None:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    frames = bytearray()
    for index in range(int(DURATION * RATE)):
        frames.extend(struct.pack("<h", round(sample(index / RATE) * 32767)))
    with wave.open(str(OUT), "wb") as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(RATE)
        wav.writeframes(frames)
    print(f"Wrote {OUT.relative_to(ROOT)}: {DURATION:.0f}s, {RATE} Hz mono PCM16")


if __name__ == "__main__":
    main()
