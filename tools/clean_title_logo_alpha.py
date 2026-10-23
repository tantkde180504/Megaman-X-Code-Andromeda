"""Remove residual magenta matte fringes from imported logo frames.

Only magenta-like pixels connected to transparent edges are removed. Geometry,
frame size, origin, and non-fringe pixels remain unchanged. Original frames are
kept under artifacts/title_logo_cleanup/before for review or recovery.
"""
import json
import re
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
FOLDER = ROOT / "MegamanZ/sprites/spr_logo_andromeda"
OUT = ROOT / "artifacts/title_logo_cleanup"


def adjacent(mask):
    padded = np.pad(mask, 1)
    return np.logical_or.reduce([
        padded[y:y+mask.shape[0], x:x+mask.shape[1]]
        for y in range(3) for x in range(3)
    ])


def clean(image):
    pixels = np.array(image.convert("RGBA"))
    rgb = pixels[:, :, :3].astype(np.int16)
    red, green, blue = rgb[:, :, 0], rgb[:, :, 1], rgb[:, :, 2]
    # A magenta matte has comparable red/blue and much less green. Blue letters,
    # gold trim, white highlights and muted purple outline shades are excluded.
    magenta = ((np.minimum(red, blue) - green > 25)
               & (np.abs(red - blue) <= np.maximum(20, np.maximum(red, blue) * 0.25)))
    transparent = pixels[:, :, 3] == 0
    removed = np.zeros_like(transparent)
    while True:
        fringe = magenta & ~transparent & adjacent(transparent)
        if not fringe.any():
            break
        removed |= fringe
        transparent |= fringe
    pixels[removed, 3] = 0
    # Clear hidden matte RGB too, preventing colour bleed if filtering is enabled.
    pixels[pixels[:, :, 3] == 0, :3] = 0
    original = np.array(image.convert("RGBA"))
    stable = (original[:, :, 3] > 0) & ~removed
    assert np.array_equal(pixels[stable], original[stable])
    return Image.fromarray(pixels), int(removed.sum())


def composite(image, background):
    out = Image.new("RGBA", image.size, background)
    out.alpha_composite(image)
    return out.convert("RGB")


def main():
    meta = json.loads(re.sub(r",\s*([}\]])", r"\1",
        (FOLDER / "spr_logo_andromeda.yy").read_text(encoding="utf-8-sig")))
    assert len(meta["frames"]) == 11 and len(meta["layers"]) == 1
    before_folder = OUT / "before"
    before_folder.mkdir(parents=True, exist_ok=True)
    originals, cleaned = [], []
    total = 0
    for index, frame in enumerate(meta["frames"]):
        path = FOLDER / (frame["name"] + ".png")
        backup = before_folder / (frame["name"] + ".png")
        if not backup.exists():
            backup.write_bytes(path.read_bytes())
        image = Image.open(backup).convert("RGBA")
        result, removed = clean(image)
        result.save(path)
        layer_path = FOLDER / "layers" / frame["name"] / (meta["layers"][0]["name"] + ".png")
        result.save(layer_path)
        assert np.array_equal(np.array(result), np.array(Image.open(layer_path)))
        originals.append(image)
        cleaned.append(result)
        total += removed
        print(f"Frame {index}: removed {removed} opaque matte-fringe pixels")

    width, height = cleaned[0].size
    strip = Image.new("RGBA", (width * 11, height))
    for index, image in enumerate(cleaned):
        strip.paste(image, (index*width, 0))
    strip.save(OUT / "spr_logo_andromeda_strip11.png")
    # Full-family before/after proof on black and light backgrounds.
    proof = Image.new("RGB", (width*4, (height+20)*11), (28,28,28))
    for index, (before, after) in enumerate(zip(originals, cleaned)):
        y = index*(height+20)
        ImageDraw.Draw(proof).text((4,y+3), f"{index}: before / after (black) | before / after (light)", fill="white")
        for column, (image, bg) in enumerate([(before,"black"),(after,"black"),(before,"#b0b0b0"),(after,"#b0b0b0")]):
            proof.paste(composite(image,bg), (column*width,y+20))
    proof.save(OUT / "logo_before_after.png")
    closeup = Image.new("RGB", (width*2,height), "black")
    closeup.paste(composite(originals[0],"black"),(0,0))
    closeup.paste(composite(cleaned[0],"black"),(width,0))
    closeup.resize((width*8,height*4),Image.Resampling.NEAREST).save(OUT / "logo_closeup_4x.png")
    source = ROOT / "artifacts/title_import/MMX_Andromeda_Sprites.zip"
    with ZipFile(source) as original_zip, ZipFile(OUT / "MMX_Andromeda_Sprites.zip", "w", ZIP_DEFLATED) as archive:
        for name in original_zip.namelist():
            if name == "spr_logo_andromeda_strip11.png":
                archive.write(OUT / name, name)
            else:
                archive.writestr(name, original_zip.read(name))
    print(f"Total cleaned: {total}; export: {OUT}")


if __name__ == "__main__":
    main()
