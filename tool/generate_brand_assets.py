"""Generate the transparent brand crops, app icon and Linux icon theme.

The original artwork in assets/لوجو.png is never modified. Run from the
project root:

    python3 -m pip install pillow
    python3 tool/generate_brand_assets.py

Only Pillow is needed; the generated PNGs are committed so normal builds do
not require this step.
"""

import os
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
ICON_DIR = ROOT / 'linux' / 'icons' / 'hicolor'
SRC = ROOT / 'assets' / 'لوجو.png'
BRAND = ROOT / 'assets' / 'branding'

ICON_DIR.mkdir(parents=True, exist_ok=True)
BRAND.mkdir(parents=True, exist_ok=True)
im = Image.open(SRC).convert('RGBA')

# Original logo regions (measured from the supplied 3375px artwork).
EMBLEM = (560, 806, 2617, 1857)
HEADER = (382, 806, 3003, 2317)
FULL = (382, 806, 3003, 2570)
CANVAS = 1024
MARGIN = 0.14
RADIUS = 0.22


def trimmed_crop(bbox):
    crop = im.crop(bbox)
    bbox2 = crop.getchannel('A').getbbox()
    return crop.crop(bbox2)


def fit(image, max_w, max_h):
    ratio = min(max_w / image.width, max_h / image.height)
    return image.resize(
        (max(1, round(image.width * ratio)), max(1, round(image.height * ratio))),
        Image.Resampling.LANCZOS,
    )


def rounded_mask(size, radius):
    mask = Image.new('L', (size, size), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, size - 1, size - 1), radius=radius, fill=255
    )
    return mask


def make_icon():
    mask = rounded_mask(CANVAS, int(CANVAS * RADIUS))
    tile = Image.new('RGBA', (CANVAS, CANVAS), (0, 0, 0, 0))
    tile.paste(Image.new('RGBA', (CANVAS, CANVAS), (255, 255, 255, 255)), (0, 0), mask)

    # Subtle brand-blue hairline keeps the tile visible on light launchers.
    ImageDraw.Draw(tile).rounded_rectangle(
        (2, 2, CANVAS - 3, CANVAS - 3),
        radius=int(CANVAS * RADIUS),
        outline=(220, 234, 243, 255),
        width=2,
    )

    inner = int(CANVAS * (1 - 2 * MARGIN))
    art = fit(trimmed_crop(HEADER), inner, inner)
    tile.alpha_composite(art, ((CANVAS - art.width) // 2, (CANVAS - art.height) // 2))
    return tile


# Transparent brand assets (original logo is kept untouched).
mark = trimmed_crop(EMBLEM)
mark.thumbnail((512, 512), Image.Resampling.LANCZOS)
mark.save(os.path.join(BRAND, 'santa_mark.png'), optimize=True)

logo = trimmed_crop(FULL)
logo.thumbnail((900, 900), Image.Resampling.LANCZOS)
logo.save(os.path.join(BRAND, 'santa_logo.png'), optimize=True)

icon = make_icon()
icon.save(os.path.join(BRAND, 'app_icon.png'), optimize=True)
icon.resize((256, 256), Image.Resampling.LANCZOS).save(
    os.path.join(BRAND, 'app_icon_256.png'), optimize=True
)

# Linux hicolor icon theme sizes. Use a light unsharp mask on tiny sizes so
# the supplied logo stays recognizable at 16-48px.
for size in (16, 24, 32, 48, 64, 128, 256, 512, 1024):
    path = os.path.join(ICON_DIR, f'{size}x{size}', 'apps')
    os.makedirs(path, exist_ok=True)
    scaled = icon.resize((size, size), Image.Resampling.LANCZOS)
    scaled.save(os.path.join(path, 'santa.png'), optimize=True)

print('Generated:')
for root, _, files in os.walk(ICON_DIR):
    for f in sorted(files):
        p = os.path.join(root, f)
        print(' ', os.path.relpath(p, ROOT), os.path.getsize(p))
print(' app_icon.png', os.path.getsize(os.path.join(BRAND, 'app_icon.png')))
