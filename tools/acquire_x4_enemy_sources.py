"""Archive the enemy sheets explicitly linked on the supplied Sprites INC page."""
from concurrent.futures import ThreadPoolExecutor
from hashlib import sha256
from html import unescape
import json
from pathlib import Path
import re
import time
from urllib.request import Request, urlopen

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
DEST = ROOT / "art/enemies/x4"
PAGE = "https://sprites-inc.com/sprite.php?local=X/X4/Enemy/"


def fetch(url, referer=PAGE):
    for attempt in range(4):
        try:
            with urlopen(Request(url, headers={"User-Agent": "Mozilla/5.0", "Referer": referer}), timeout=25) as response:
                return response.read()
        except OSError:
            if attempt == 3:
                raise
            time.sleep(attempt + 1)


def main():
    sources = DEST / "source"
    sources.mkdir(parents=True, exist_ok=True)
    html = fetch(PAGE).decode("utf-8", errors="replace")
    urls = list(dict.fromkeys("https://sprites-inc.com" + unescape(p) for p in
        re.findall(r'<img[^>]+src=["\'](/files/X/X4/Enemy/[^"\']+)', html)))
    if not urls:
        raise RuntimeError("No enemy sheets found; inspect the source page before importing")

    def archive(url):
        path = sources / url.rsplit("/", 1)[-1]
        if not path.exists():
            path.write_bytes(fetch(url))
        with Image.open(path) as image:
            record = {"file": path.name, "url": url, "width": image.width,
                      "height": image.height, "frames": getattr(image, "n_frames", 1),
                      "sha256": sha256(path.read_bytes()).hexdigest()}
        return record

    with ThreadPoolExecutor(max_workers=2) as pool:
        records = list(pool.map(archive, urls))
    (DEST / "sources.json").write_text(json.dumps({"page": PAGE, "sheets": records,
        "provenance": "Mega Man X4 game art (Capcom), sheets hosted by Sprites INC; "
                      "retain embedded ripper credits in the original source files. "
                      "The source page does not specify an independent reuse licence."},
        indent=2) + "\n", encoding="utf-8")
    for start in range(0, len(records), 12):
        batch = records[start:start + 12]
        preview = Image.new("RGB", (1280, 3 * 260), "#252a32")
        draw = ImageDraw.Draw(preview)
        for index, record in enumerate(batch):
            x, y = index % 4 * 320, index // 4 * 260
            draw.text((x + 4, y + 4), record["file"], fill="white")
            with Image.open(sources / record["file"]) as source:
                image = source.convert("RGBA")
                image.thumbnail((312, 230), Image.Resampling.NEAREST)
                preview.paste(image, (x + 4, y + 24), image)
        preview.save(DEST / f"source-preview-{start // 12 + 1}.png")
    print(f"Archived {len(records)} sheets in {sources}")
    for record in records:
        print(record["file"], record["width"], record["height"])


if __name__ == "__main__":
    main()
