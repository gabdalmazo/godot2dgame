"""Engineering-only composition of actual resource scales; not a Godot screenshot.

Never modifies game art. Pillow resizing/compositing is only for inspection outputs.
"""
from pathlib import Path
import json
import re
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "game-inicial"
OUT = ROOT / "docs/assets"


def resource(kind, name):
    body = (PROJECT / f"data/{kind}/{name}.tres").read_text(encoding="utf-8")
    return dict(re.findall(r"^(\w+) = (.+)$", body, re.M))


def vector(value):
    return tuple(float(x) for x in value.removeprefix("Vector2(").removesuffix(")").split(","))


def artwork(data, field):
    path = data[field].strip('"').removeprefix("res://")
    return Image.open(PROJECT / path).convert("RGBA")


canvas = Image.open(PROJECT / "assets/maps/aurora_valley/aurora_valley.png").convert("RGBA")
actors = [(165, 301, "towers", "archer"), (311, 286, "towers", "ice"),
          (357, 190, "towers", "arcane"), (536, 229, "towers", "archer"),
          (550, 357, "towers", "ice"), (766, 267, "towers", "arcane"),
          (735, 371, "towers", "archer"), (158, 353, "enemies", "gremlin"),
          (251, 264, "enemies", "golem"), (432, 211, "enemies", "gremlin"),
          (571, 178, "enemies", "golem"), (694, 284, "enemies", "gremlin"),
          (827, 297, "enemies", "golem")]
for x, y, kind, name in sorted(actors, key=lambda actor: actor[1]):
    data = resource(kind, name)
    if kind == "towers":
        art = artwork(data, "texture_path")
        scale = vector(data["texture_scale"])[0]
        offset = vector(data["texture_offset"])
        origin = (x + offset[0] - art.width * scale / 2, y + offset[1] - art.height * scale / 2)
    else:
        art = artwork(data, "static_texture_path")
        scale = float(data["static_scale"])
        pivot = vector(data["static_pivot"])
        origin = (x - pivot[0] * scale, y - pivot[1] * scale)
        draw = ImageDraw.Draw(canvas)
        width = float(data["health_bar_width"])
        top = y - float(data["visual_height"]) - 10
        draw.ellipse((x-15, y-5, x+15, y+5), fill=(20, 32, 40, 100))
        draw.rectangle((x-width/2, top, x+width/2, top+5), fill="#162636")
        draw.rectangle((x-width/2+1, top+1, x+width/4, top+4), fill="#91efb5")
    art = art.resize((round(art.width*scale), round(art.height*scale)), Image.Resampling.LANCZOS)
    canvas.alpha_composite(art, (round(origin[0]), round(origin[1])))

for name, x, y in [("archer", 480, 194), ("ice", 300, 244), ("arcane", 789, 282)]:
    data = resource("towers", name)
    art = artwork(data, "projectile_texture_path")
    scale = float(data["projectile_texture_scale"])
    art = art.resize((round(art.width*scale), round(art.height*scale)), Image.Resampling.LANCZOS)
    art = art.rotate(-float(data.get("projectile_texture_rotation_degrees", 0)), expand=True)
    canvas.alpha_composite(art, (x-art.width//2, y-art.height//2))

preview = Image.new("RGB", (1280, 765), "#12212f")
preview.paste(canvas.convert("RGB").resize((1280, 715), Image.Resampling.LANCZOS), (0, 50))
ImageDraw.Draw(preview).text((18, 17), "ETAPA 3 | Composicao tecnica de escala e pivos - NAO e captura do Godot / HUD omitida", fill="white")
preview.save(OUT / "etapa3_scene_preview.png")

# Each approved output on both bright and dark flat backgrounds, for alpha-edge review.
recipe = json.loads((ROOT / "tools/visual_assets_recipe.json").read_text(encoding="utf-8-sig"))
sheet = Image.new("RGB", (1080, 3*410), "#152332")
draw = ImageDraw.Draw(sheet)
for i, spec in enumerate(recipe["assets"]):
    x, y = (i % 3)*360, (i // 3)*410
    art = Image.open(ROOT / spec["destination"]).convert("RGBA")
    bbox = art.getchannel("A").point(lambda p: 255 if p >= 32 else 0).getbbox()
    # Crop only this inspection tile; the installed PNG remains unchanged.
    art = art.crop(bbox)
    art.thumbnail((160, 350), Image.Resampling.LANCZOS)
    for shift, color in [(0, "#e9f3f6"), (180, "#183447")]:
        draw.rectangle((x+shift, y+30, x+shift+179, y+409), fill=color)
        sheet.paste(art, (x+shift+(180-art.width)//2, y+50+(350-art.height)//2), art)
    draw.text((x+10, y+10), spec["id"], fill="white")
sheet.save(OUT / "etapa3_alpha_review.png")
print("Created engineering scene composition and two-background alpha contact sheet.")
