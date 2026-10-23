"""Render a silent 320x240 storyboard of the GML timeline (not a runner capture)."""
from pathlib import Path
import argparse
import math

from PIL import Image, ImageDraw


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("--out", type=Path, default=Path("artifacts/title_import"))
    args = parser.parse_args()
    def load(name):
        return Image.open(args.source / name).convert("RGBA")
    bg = load("spr_title_bg.png")
    text = load("spr_megaman_text.png")
    logos = load("spr_logo_andromeda_strip11.png")
    options = load("spr_menu_options_strip3.png")
    press = load("spr_menu_press_start.png")
    logo_width = logos.width // 11
    option_width = options.width // 3
    logos = [logos.crop((i*logo_width, 0, (i+1)*logo_width, logos.height)) for i in range(11)]
    options = [options.crop((i*option_width, 0, (i+1)*option_width, options.height)) for i in range(3)]

    def draw_center(canvas, sprite, xy=(160, 85), sx=1, sy=1, white=False):
        sprite = sprite.copy()
        if white:
            silhouette = Image.new("RGBA", sprite.size, "white")
            silhouette.putalpha(sprite.getchannel("A"))
            sprite = silhouette
        size = (max(1, round(sprite.width*sx)), max(1, round(sprite.height*sy)))
        sprite = sprite.resize(size, Image.Resampling.NEAREST)
        canvas.alpha_composite(sprite, (round(xy[0] - size[0]/2), round(xy[1] - size[1]/2)))

    frames = []
    for frame in range(0, 810, 3):  # sample 60-FPS timeline at 20 FPS for the GIF
        canvas = Image.new("RGBA", (320, 240), (0, 0, 0, 255))
        if frame >= 420:
            background = bg.copy()
            alpha = min(1, (frame-420)/150)
            background.putalpha(background.getchannel("A").point(lambda value: round(value*alpha)))
            canvas.alpha_composite(background)
        if frame < 60:
            t = min(1, frame/59)
            ease = 1-(1-t)**3
            draw_center(canvas, text, sx=3-2*ease, sy=0.05+0.95*ease, white=True)
            beam = max(0, 1-frame/20)
            overlay = Image.new("RGBA", canvas.size)
            ImageDraw.Draw(overlay).line((0,85,320,85), fill=(255,255,255,round(beam*255)), width=2)
            canvas.alpha_composite(overlay)
        elif frame < 300:
            if frame >= 210:
                t = min(1, (frame-210)/12)
                scale = 1+3.5*(1-t)**3
                draw_center(canvas, logos[0], sx=scale, sy=scale, white=True)
            draw_center(canvas, text)
        else:
            cycle = ((frame-300)*0.25) % 20
            index = math.floor(cycle if cycle <= 10 else 20-cycle)
            draw_center(canvas, logos[index])
        flash = 0
        for start in (60, 300):
            if frame >= start:
                flash = max(flash, max(0, 1-(frame-start)*0.07))
        if flash:
            canvas.alpha_composite(Image.new("RGBA", canvas.size, (255,255,255,round(flash*255))))
        if 570 <= frame < 660 and ((frame-570)//30) % 2 == 0:
            draw_center(canvas, press, (160,180))
        elif frame >= 660:
            draw_center(canvas, options[min(2, (frame-660)//50)], (160,180))
        frames.append(canvas.convert("RGB"))
    args.out.mkdir(parents=True, exist_ok=True)
    frames[0].save(args.out / "title_intro_preview.gif", save_all=True,
                   append_images=frames[1:], duration=50, loop=0, optimize=False)
    print("Saved silent preview: " + str(args.out / "title_intro_preview.gif"))


if __name__ == "__main__":
    main()
