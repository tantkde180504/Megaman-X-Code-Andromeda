"""Native-asset layout previews; these are Pillow composites, not runner captures."""
import json
import re
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "MegamanZ"
OUT = ROOT / "artifacts/ps1_layouts"


def load_sprite(name, index=0):
    folder = PROJECT / "sprites" / name
    meta = json.loads(re.sub(r",\s*([}\]])", r"\1", (folder / (name + ".yy")).read_text(encoding="utf-8-sig")))
    return Image.open(folder / (meta["frames"][index]["name"] + ".png")).convert("RGBA")


font_source = (PROJECT / "scripts/scr_mmx_font/scr_mmx_font.gml").read_text(encoding="utf-8")
GLYPHS = {int(code): tuple(map(int, (x, y, w, h))) for code, x, y, w, h in
          re.findall(r"global\.mmx_font_small\[(\d+)\] = \[(\d+), (\d+), (\d+), (\d+)\]", font_source)}
GLYPHS[32] = (0, 0, 4, 16)
FONT = load_sprite("fonts")


def width(text):
    return sum(GLYPHS.get(ord(c.upper()), (0, 0, 3, 16))[2] + 1 for c in text)


def wrap(text, available):
    lines = []
    for paragraph in text.split("\n"):
        line = ""
        for word in paragraph.split(" "):
            candidate = word if not line else line + " " + word
            if line and width(candidate) > available:
                lines.append(line)
                line = word
            else:
                line = candidate
        lines.append(line)
    return lines


def text(image, x, y, value, available=288, colour=(255, 255, 255)):
    for line in wrap(value, available):
        assert x >= 0 and x + width(line) <= 320 and y >= 0 and y + 16 <= 240, (x, y, line)
        dx = x
        for c in line.upper():
            sx, sy, w, h = GLYPHS.get(ord(c), (0, 0, 3, 16))
            if c != " " and ord(c) in GLYPHS:
                glyph = FONT.crop((sx, sy, sx+w, sy+h))
                glyph = ImageChops.multiply(glyph, Image.new("RGBA", glyph.size, (*colour, 255)))
                image.alpha_composite(glyph, (dx, y))
            dx += w+1
        y += 16


def centered(image, y, value, colour=(255, 255, 0)):
    text(image, (320-width(value))//2, y, value, colour=colour)


def panel(image, x, y, w, h):
    assert 0 <= x <= x+w <= 320 and 0 <= y <= y+h <= 240
    ImageDraw.Draw(image).rectangle((x,y,x+w-1,y+h-1), fill=(6,18,42,255), outline=(0,255,255,255))


def part(canvas, image, box, position, alpha=1):
    crop = image.crop(box)
    if alpha != 1:
        crop.putalpha(crop.getchannel("A").point(lambda a: round(a*alpha)))
    canvas.alpha_composite(crop, position)


def characters(selected):
    sheet = load_sprite("PlayerSelect")
    image = sheet.crop((6,5,326,245))
    part(image, sheet, (337,25,534,43), (61,6))
    for who in (1-selected, selected):
        x = 12 if who == 0 else 120
        sx = 8 if who == 0 else 202
        part(image,sheet,(sx,267,sx+188,424),(x,35),1 if selected == who else 0.5)
        if selected == who:
            sy = 624 if who == 0 else 450
            lx,rx,lw,rw,offset = (6,118,27,88,112) if who == 0 else (2,175,88,27,173)
            part(image,sheet,(lx,sy,lx+lw,sy+169),(x-6,29))
            part(image,sheet,(rx,sy,rx+rw,sy+169),(x-6+offset,29))
    part(image,sheet,(347,60,465,79),(16,196))
    part(image,sheet,(373,95,427,114),(242,196))
    centered(image,222,"LEFT/RIGHT Z:OK X:BACK")
    return image


def dialogue(prologue=False):
    image = Image.new("RGBA",(320,240),(4,10,24,255))
    if prologue:
        centered(image,24,"MISSION BRIEFING",(0,255,255))
        panel(image,8,64,304,152)
        body = "Following the fierce battles against Sigma, X continues the perilous duty of a Maverick Hunter, purging rogue Reploids infected by the Maverick virus and wiping out the remnants of Sigma's forces."
        text(image,16,76,body)
    else:
        sheet = load_sprite("Mugshots")
        part(image,sheet,(196,0,290,112),(16,8))
        part(image,sheet,(98,0,192,112),(210,8))
        text(image,59,122,"X",available=100,colour=(0,255,255))
        text(image,243,122,"ALIA",available=70,colour=(255,0,255))
        text(image,154,28,"HQ",available=80,colour=(0,255,255))
        panel(image,8,144,304,80)
        text(image,16,148,"ALIA",colour=(255,255,0))
        text(image,16,168,"X! X! Can you hear me?")
    centered(image,224,"Z:NEXT S:SKIP")
    return image


def stage_select(briefing=False):
    image = load_sprite("StageSelectBkGrd").crop((5,277,325,517))
    sheet = load_sprite("StageX")
    part(image,sheet,(3,3,55,96),(12,52))
    panel(image,96,8,216,136)
    panel(image,8,152,304,72)
    if briefing:
        text(image,144,16,"TACTICAL FEED",available=168,colour=(0,255,255))
        draw = ImageDraw.Draw(image)
        for b in range(18):
            h = 4+(b*7)%17
            draw.rectangle((108+b*10,72-h,113+b*10,72+h),fill=(0,255,255,255))
        text(image,104,104,"MAVERICKS DETECTED\nPRIORITY: S-RANK",available=200,colour=(255,255,0))
        text(image,16,156,"COMMAND HQ",colour=(255,255,0))
        text(image,16,176,"SENSORS DETECTED MAVERICK DISTURBANCES ACROSS KEY SECTORS.")
        centered(image,224,"ENTER: NEXT",(0,255,255))
    else:
        text(image,152,12,"STAGE SELECT",available=160,colour=(0,255,255))
        for i,name in enumerate(("JUNGLE SECTOR","CENTRAL HIGHWAY","TRAINING FACILITY","BOSS CLASH ARENA")):
            text(image,106,36+i*22,name,available=196,colour=(255,255,0) if i==0 else (255,255,255))
        text(image,104,126,"AREA 54",available=200,colour=(0,255,255))
        text(image,16,156,"NIGHTMARE ZERO",colour=(255,0,0))
        text(image,16,172,"EXTREME (S-RANK)",colour=(255,255,0))
        text(image,16,190,"DEEP FOREST RUINS OVERRUN BY ROGUE REPLOIDS. VIRAL PHANTOM DETECTED.")
        centered(image,224,"ARROWS: SELECT Z:LAUNCH",(0,255,255))
    return image


def main():
    OUT.mkdir(parents=True,exist_ok=True)
    shots = [("character_x",characters(0)),("character_zero",characters(1)),
             ("dialogue",dialogue()),("prologue",dialogue(True)),
             ("stage_briefing",stage_select(True)),("stage_select",stage_select())]
    contact = Image.new("RGB",(960,528),(18,18,18))
    for i,(name,image) in enumerate(shots):
        image.save(OUT/(name+".png"))
        x,y=(i%3)*320,(i//3)*264
        ImageDraw.Draw(contact).text((x+4,y+4),name,fill="white")
        contact.paste(image.convert("RGB"),(x,y+24))
    contact.save(OUT/"layout_contact_sheet.png")
    print("OK: six native 320x240 previews; panel and text bounds checked")


if __name__ == "__main__":
    main()
