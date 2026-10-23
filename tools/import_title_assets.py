"""Import prepared RGBA title sprites into GameMaker without resampling source pixels."""
import argparse
import copy
import json
import re
import uuid
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

from PIL import Image


def read_gm(path):
    return json.loads(re.sub(r",\s*([}\]])", r"\1", path.read_text(encoding="utf-8-sig")))


def guid():
    return str(uuid.uuid4())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    project = root / "MegamanZ"
    template = read_gm(project / "sprites/sX_Victory/sX_Victory.yy")
    specs = [
        ("spr_title_bg", "spr_title_bg.png", 1, False),
        ("spr_megaman_text", "spr_megaman_text.png", 1, True),
        ("spr_logo_andromeda", "spr_logo_andromeda_strip11.png", 11, True),
        ("spr_menu_press_start", "spr_menu_press_start.png", 1, True),
        ("spr_menu_options", "spr_menu_options_strip3.png", 3, True),
    ]
    prepared = []
    # Validate everything before any project writes.
    for name, filename, count, centered in specs:
        image = Image.open(args.source / filename).convert("RGBA")
        if image.width % count:
            raise ValueError(f"{filename}: width must divide by {count}")
        if name == "spr_title_bg" and image.size != (320, 240):
            raise ValueError("Background must be 320x240")
        destination = project / "sprites" / name
        if destination.exists():
            raise FileExistsError(f"Refusing to overwrite existing sprite: {destination}")
        width, height = image.width // count, image.height
        frames = [image.crop((i * width, 0, (i + 1) * width, height)) for i in range(count)]
        prepared.append((name, filename, centered, destination, frames))

    for name, filename, centered, destination, images in prepared:
        width, height = images[0].size
        meta = copy.deepcopy(template)
        meta["%Name"] = meta["name"] = name
        meta["width"], meta["height"] = width, height
        meta["origin"] = 4 if centered else 0
        meta["bbox_left"], meta["bbox_top"] = 0, 0
        meta["bbox_right"], meta["bbox_bottom"] = width - 1, height - 1
        layer_id = guid()
        meta["layers"][0]["%Name"] = layer_id
        meta["layers"][0]["name"] = layer_id
        meta["frames"] = []
        sequence = meta["sequence"]
        sequence["%Name"] = sequence["name"] = name
        sequence["length"] = float(len(images))
        sequence["xorigin"] = width // 2 if centered else 0
        sequence["yorigin"] = height // 2 if centered else 0
        keys = sequence["tracks"][0]["keyframes"]["Keyframes"]
        sample_key = copy.deepcopy(keys[0])
        keys.clear()
        destination.mkdir(parents=True)
        for index, image in enumerate(images):
            frame_id = guid()
            meta["frames"].append({"$GMSpriteFrame": "v1", "%Name": frame_id,
                                   "name": frame_id, "resourceType": "GMSpriteFrame",
                                   "resourceVersion": "2.0"})
            key = copy.deepcopy(sample_key)
            key["id"], key["Key"] = guid(), float(index)
            key["Channels"]["0"]["Id"] = {
                "name": frame_id, "path": f"sprites/{name}/{name}.yy"}
            keys.append(key)
            image.save(destination / f"{frame_id}.png")
            layer_path = destination / "layers" / frame_id
            layer_path.mkdir(parents=True)
            image.save(layer_path / f"{layer_id}.png")
        (destination / f"{name}.yy").write_text(
            json.dumps(meta, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"Imported {name}: {width}x{height}, {len(images)} frame(s), "
              f"origin={sequence['xorigin']},{sequence['yorigin']}")

    manifest_path = project / "MegamanZ.yyp"
    text = manifest_path.read_text(encoding="utf-8-sig")
    registered = {entry["id"]["name"] for entry in read_gm(manifest_path)["resources"]}
    additions = "".join(
        '    {"id":{"name":"' + name + '","path":"sprites/' + name + '/' + name + '.yy",},},\n'
        for name, *_ in specs if name not in registered)
    text, replacements = re.subn(r'("resources"\s*:\s*\[\s*\n)',
                                lambda match: match[0] + additions, text, count=1)
    if replacements != 1:
        raise ValueError("Project resource list not found")
    manifest_path.write_text(text, encoding="utf-8", newline="\n")

    output = root / "artifacts/title_import"
    output.mkdir(parents=True, exist_ok=True)
    with ZipFile(output / "MMX_Andromeda_Sprites.zip", "w", ZIP_DEFLATED) as archive:
        for _, filename, *_ in specs:
            archive.write(args.source / filename, filename)

    # Preview actual alpha over black, as drawn by the title intro.
    background = Image.open(args.source / "spr_title_bg.png").convert("RGBA")
    preview = Image.new("RGBA", (320, 240), (0, 0, 0, 255))
    preview.alpha_composite(background)
    for filename, count, cx, cy in [
        ("spr_logo_andromeda_strip11.png", 11, 160, 85),
        ("spr_menu_press_start.png", 1, 160, 180),
    ]:
        image = Image.open(args.source / filename).convert("RGBA")
        image = image.crop((0, 0, image.width // count, image.height))
        preview.alpha_composite(image, (cx - image.width // 2, cy - image.height // 2))
    preview.save(output / "title_preview.png")


if __name__ == "__main__":
    main()
