"""Deterministic, original mono PCM prototype cues; no downloads or libraries."""
from pathlib import Path
import math
import struct
import wave

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "game-inicial/assets/audio/prototype"
OUT.mkdir(parents=True, exist_ok=True)
RATE = 22050

# Duration, base note, final/base pitch, character, gain. The sounds are deliberately short.
CUES = {
    "ui": (0.075, 720, 1.22, "bell", .18),
    "build": (0.30, 440, 1.50, "bell", .22),
    "wave": (0.60, 392, 1.50, "bell", .21),
    "arrow": (0.12, 700, .40, "air", .14),
    "ice": (0.22, 780, .72, "glass", .16),
    "arcane": (0.30, 440, 1.70, "glass", .17),
    "impact": (0.13, 120, .55, "noise", .17),
    "kill": (0.20, 330, .66, "glass", .17),
    "escape": (0.42, 280, .45, "bell", .21),
    "pause": (0.15, 580, .83, "bell", .16),
    "victory": (1.15, 523, 1.50, "bell", .23),
    "defeat": (0.90, 261, .50, "bell", .20),
    "bell": (0.90, 523, 1.00, "bell", .24),
}


def synth(name, duration, frequency, end_ratio, character, gain):
    count = round(duration * RATE)
    state = 0xA570A + len(name) * 991
    phase = 0.0
    samples = []
    for index in range(count):
        t = index / RATE
        progress = index / count
        pitch = frequency * (1 + (end_ratio - 1) * progress)
        phase += 2 * math.pi * pitch / RATE
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        noise = (state / 0xFFFFFFFF) * 2 - 1
        if character == "bell":
            value = math.sin(phase) + .36 * math.sin(phase * 2.01) + .17 * math.sin(phase * 3.93)
            release = (1 - progress) ** 2.8
        elif character == "glass":
            value = math.sin(phase) + .32 * math.sin(phase * 2.73) + .12 * noise
            release = (1 - progress) ** 2.2
        elif character == "air":
            value = .55 * math.sin(phase) + .55 * noise
            release = (1 - progress) ** 2.0
        else:
            value = .8 * noise + .5 * math.sin(phase)
            release = (1 - progress) ** 3.5
        attack = min(1.0, t / .006)
        samples.append(max(-1, min(1, value * gain * attack * release)))
    return struct.pack("<" + "h" * count, *(round(sample * 32767) for sample in samples))


def main():
    for name, spec in CUES.items():
        target = OUT / f"{name}.wav"
        pcm = synth(name, *spec)
        with wave.open(str(target), "wb") as output:
            output.setnchannels(1)
            output.setsampwidth(2)
            output.setframerate(RATE)
            output.writeframes(pcm)
        print(f"{target.relative_to(ROOT).as_posix()}: {len(pcm) // 2} frames")


if __name__ == "__main__":
    main()
