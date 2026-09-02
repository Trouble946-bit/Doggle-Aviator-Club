#!/usr/bin/env python3
import os
from PIL import Image

images = [
    "Home.jpg",
    "logo.png.png",
    "site-bg-1920.jpg",
    "site-bg-1366.jpg",
    "site-bg-1024.jpg",
    "site-bg-768.jpg",
    "site-bg-480.jpg",
    "Bar Meal.jpeg",
    "Bar pool 5.jpeg",
    "Bar pool.jpeg",
    "lodge outside.jpeg",
]

sizes = [1600, 800, 480]
outdir = os.path.join(os.path.dirname(__file__), '..', 'assets', 'optimized')
outdir = os.path.abspath(outdir)
os.makedirs(outdir, exist_ok=True)

def process(path):
    try:
        with Image.open(path) as im:
            im = im.convert('RGB')
            base = os.path.splitext(os.path.basename(path))[0]
            for s in sizes:
                im_copy = im.copy()
                im_copy.thumbnail((s, s), Image.Resampling.LANCZOS)
                webp_path = os.path.join(outdir, f"{base}-{s}.webp")
                jpg_path = os.path.join(outdir, f"{base}-{s}.jpg")
                im_copy.save(webp_path, 'WEBP', quality=80, method=6)
                im_copy.save(jpg_path, 'JPEG', quality=75, optimize=True)
            print(f"Processed {path}")
    except Exception as e:
        print(f"Failed {path}: {e}")

if __name__ == '__main__':
    cwd = os.getcwd()
    for img in images:
        full = os.path.join(cwd, img)
        if os.path.isfile(full):
            process(full)
        else:
            print(f"Not found: {img}")
