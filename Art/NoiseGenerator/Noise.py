import numpy as np
from PIL import Image

# --- Config ---
WIDTH, HEIGHT = 1080//4, 1920//4
OUTPUT_FILE = "color_noise.png"

# Colors as hex RGBA strings: "#RRGGBBAA"
COLORS = [
    "#5c3841FF",   # Dark Brown
    "#5c3841FF",   # Dark Brown
    "#5c3841FF",   # Dark Brown
    "#945848FF",   # Medium Brown
    "#945848FF",   # Medium Brown
    "#945848FF",   # Medium Brown
    "#d17f6bFF",   # Light Brown
    "#d69a4eFF",   # Light Orange
]

def hex_to_rgba(hex_color: str) -> tuple:
    h = hex_color.lstrip("#")
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4, 6))

# Convert to numpy array for fast indexing: shape (N, 4)
palette = np.array([hex_to_rgba(c) for c in COLORS], dtype=np.uint8)

# Pick random color indices for every pixel in one shot
indices = np.random.randint(0, len(palette), size=(HEIGHT, WIDTH))

# Index into palette to build the full RGBA image: shape (H, W, 4)
pixels = palette[indices]

img = Image.fromarray(pixels, mode="RGBA")
img.save(OUTPUT_FILE)
print(f"Saved {OUTPUT_FILE}  ({WIDTH}x{HEIGHT}, {len(palette)} colors)")
