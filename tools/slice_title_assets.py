"""Slice the two title sheets for Megaman X Andromeda.

Usage: python tools/slice_title_assets.py [original.png] [andromeda.png] [--out artifacts/title]
Requires Pillow, OpenCV and NumPy.
"""
from __future__ import annotations

import argparse
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

import cv2
import numpy as np
from PIL import Image


def process_title_assets(original_path: Path, andromeda_path: Path, out_dir: Path) -> Path:
    out_dir.mkdir(parents=True, exist_ok=True)

    # 1. Load images
    img1 = Image.open(original_path).convert("RGBA")
    arr1 = np.array(img1)

    img2 = Image.open(andromeda_path).convert("RGBA")
    arr2 = np.array(img2)

    # ==========================================
    # Sprite 1: spr_title_bg.png (from img1)
    # ==========================================
    bg = img1.crop((0, 0, 320, 240)).convert("RGBA")
    bg_arr = np.array(bg)
    # Save TM area: x in 284..299, y in 123..129
    tm = bg_arr[123:130, 284:300].copy()
    # Black out old logo: y in 0..128
    bg_arr[0:129, :] = [0, 0, 0, 255]
    # Restore TM
    bg_arr[123:130, 284:300] = tm
    spr_title_bg = Image.fromarray(bg_arr)
    spr_title_bg.save(out_dir / "spr_title_bg.png")

    # ==========================================
    # Sprite 2: spr_megaman_text.png (from img1)
    # ==========================================
    # MEGAMAN text at pos=(352, 23), size=(209, 42)
    spr_megaman_text = img1.crop((352, 23, 352 + 209, 23 + 42))
    spr_megaman_text.save(out_dir / "spr_megaman_text.png")

    # ==========================================
    # Sprite 3: spr_menu_press_start.png (from img1)
    # ==========================================
    # PRESS START or ENTER at pos=(650, 20), size=(144, 12)
    spr_menu_press_start = img1.crop((650, 20, 650 + 144, 20 + 12))
    spr_menu_press_start.save(out_dir / "spr_menu_press_start.png")

    # ==========================================
    # Sprite 4: spr_menu_options_strip3.png (from img1)
    # ==========================================
    # 3 menu states: GAME START (617, 48), CONTINUE (739, 48), OPTION (661, 110)
    g1 = img1.crop((617, 48, 617 + 87, 48 + 42))
    g2 = img1.crop((739, 48, 739 + 87, 48 + 42))
    g3 = img1.crop((661, 110, 661 + 87, 110 + 42))

    spr_menu_options = Image.new("RGBA", (87 * 3, 42), (0, 0, 0, 0))
    spr_menu_options.paste(g1, (0, 0))
    spr_menu_options.paste(g2, (87, 0))
    spr_menu_options.paste(g3, (87 * 2, 0))
    spr_menu_options.save(out_dir / "spr_menu_options_strip3.png")

    # ==========================================
    # Sprite 5: spr_logo_andromeda_strip11.png (from img2)
    # ==========================================
    # Key out magenta background
    dist = np.sqrt(np.sum((arr2[:, :, :3].astype(np.float32) - np.array([255, 0, 255])) ** 2, axis=2))
    is_bg = dist < 60
    arr2_clean = arr2.copy()
    arr2_clean[is_bg, 3] = 0
    arr2_clean[is_bg, :3] = 0

    # Locate the 11 connected components in lower 4 rows (y > 350)
    mask_bottom = (~is_bg).astype(np.uint8)
    mask_bottom[:350, :] = 0
    num, labels, stats, centroids = cv2.connectedComponentsWithStats(mask_bottom)

    items = []
    for i in range(1, num):
        if stats[i, cv2.CC_STAT_AREA] > 10000:
            items.append((stats[i], centroids[i]))

    # Group into 4 rows by Y centroid
    items.sort(key=lambda it: it[1][1])
    rows = []
    curr_row = [items[0]]
    for it in items[1:]:
        if abs(it[1][1] - curr_row[0][1][1]) < 50:
            curr_row.append(it)
        else:
            curr_row.sort(key=lambda it: it[1][0])
            rows.append(curr_row)
            curr_row = [it]
    curr_row.sort(key=lambda it: it[1][0])
    rows.append(curr_row)

    raw_crops = []
    for row in rows:
        for it in row:
            x, y, w, h, a = it[0]
            crop = arr2_clean[y : y + h, x : x + w].copy()
            raw_crops.append(crop)

    # Frame 9 padding if needed (if bottom edge truncated)
    if raw_crops[9].shape[0] < 156:
        pad_h = 156 - raw_crops[9].shape[0]
        padded_f9 = np.zeros((156, raw_crops[9].shape[1], 4), dtype=np.uint8)
        padded_f9[: raw_crops[9].shape[0], :] = raw_crops[9]
        padded_f9[raw_crops[9].shape[0] :, :] = raw_crops[10][-pad_h :, : raw_crops[9].shape[1]]
        raw_crops[9] = padded_f9

    # Downscale each crop by 0.5 using NEAREST
    frames_1x = []
    for crop in raw_crops:
        im = Image.fromarray(crop)
        w_1x = crop.shape[1] // 2
        h_1x = crop.shape[0] // 2
        im_1x = im.resize((w_1x, h_1x), Image.Resampling.NEAREST)
        frames_1x.append(im_1x)

    max_w = max(f.width for f in frames_1x)
    max_h = max(f.height for f in frames_1x)

    # Center each frame in common (max_w, max_h)
    centered_frames = []
    for f in frames_1x:
        c = Image.new("RGBA", (max_w, max_h), (0, 0, 0, 0))
        paste_x = (max_w - f.width) // 2
        paste_y = (max_h - f.height) // 2
        c.paste(f, (paste_x, paste_y))
        centered_frames.append(c)

    # Build strip11
    spr_logo_andromeda = Image.new("RGBA", (max_w * 11, max_h), (0, 0, 0, 0))
    for i, cf in enumerate(centered_frames):
        spr_logo_andromeda.paste(cf, (i * max_w, 0))
    spr_logo_andromeda.save(out_dir / "spr_logo_andromeda_strip11.png")

    # ==========================================
    # Package ZIP
    # ==========================================
    zip_path = out_dir / "MMX_Andromeda_Sprites.zip"
    sprite_files = [
        "spr_title_bg.png",
        "spr_megaman_text.png",
        "spr_logo_andromeda_strip11.png",
        "spr_menu_press_start.png",
        "spr_menu_options_strip3.png",
    ]
    with ZipFile(zip_path, "w", ZIP_DEFLATED) as zf:
        for name in sprite_files:
            zf.write(out_dir / name, name)

    print(f"Processed 5 sprites into {out_dir}")
    print(f"Logo frame size: ({max_w}x{max_h}), Menu frame size: (87x42)")
    print(f"Archive created at: {zip_path}")
    return zip_path


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "original",
        nargs="?",
        type=Path,
        default=Path(r"D:\MZ4\MegamanZ\sprites\X4_TitleScreen\ee41b15d-c491-4282-abc4-7c3821e06a0c.png"),
    )
    parser.add_argument(
        "andromeda",
        nargs="?",
        type=Path,
        default=Path(r"D:\MZ4\MegamanZ\sprites\X_Andromeda\bb1971a7-a038-4271-b7c8-e8a4018e1007.png"),
    )
    parser.add_argument("--out", type=Path, default=Path(r"D:\MZ4\artifacts\title"))
    args = parser.parse_args()

    process_title_assets(args.original, args.andromeda, args.out)


if __name__ == "__main__":
    main()
