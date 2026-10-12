import os
import re

spr_dir = r'd:\MZ4\MegamanZ\sprites'
for item in sorted(os.listdir(spr_dir)):
    if item.startswith('spr_nz_'):
        yy_path = os.path.join(spr_dir, item, f'{item}.yy')
        if os.path.exists(yy_path):
            with open(yy_path, 'r', encoding='utf-8') as f:
                c = f.read()
            w = re.search(r'"width":\s*(\d+)', c).group(1)
            h = re.search(r'"height":\s*(\d+)', c).group(1)
            ox = re.search(r'"xorigin":\s*(\d+)', c).group(1)
            oy = re.search(r'"yorigin":\s*(\d+)', c).group(1)
            frames = len(re.findall(r'"\$GMSpriteFrame"', c))
            print(f'{item:22} | frames: {frames:2} | size: {w:>3}x{h:<3} | origin: ({ox:>2}, {oy:<2})')
