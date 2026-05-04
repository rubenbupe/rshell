#!/usr/bin/env python3

import colorsys
import subprocess
import sys
import tempfile
import time
from pathlib import Path


def cmd(*args, input=None):
    return subprocess.check_output(args, input=input)


for dep in ("hyprpicker", "magick", "wl-copy", "notify-send"):
    if subprocess.call(["which", dep], stdout=subprocess.DEVNULL) != 0:
        subprocess.call(
            [
                "notify-send",
                "Color Picker",
                f"Missing dependency: {dep}",
                "-u",
                "critical",
            ]
        )
        sys.exit(1)

time.sleep(0.4)

hex_color = cmd("hyprpicker", "-f", "hex").decode().strip()
if not hex_color:
    sys.exit(0)

r, g, b = tuple(int(hex_color.lstrip("#")[index : index + 2], 16) for index in (0, 2, 4))
hex_color = f"#{hex_color.lstrip('#').upper()[:6]}"
rgb_color = f"rgb({r}, {g}, {b})"

rn, gn, bn = r / 255, g / 255, b / 255
h, s, v = colorsys.rgb_to_hsv(rn, gn, bn)
hsv_color = f"hsv({round(h*360)}, {round(s*100)}%, {round(v*100)}%)"

icon = Path(tempfile.gettempdir()) / "color_picker_preview.png"
cmd("magick", "-size", "64x64", f"xc:{hex_color}", str(icon))

subprocess.run(["wl-copy"], input=hex_color.encode())

proc = subprocess.Popen(
    [
        "notify-send",
        "Color Picked",
        f"{hex_color} copied to clipboard",
        "-i",
        str(icon),
        "-a",
        "ColorPicker",
        "-u",
        "normal",
        "--action=hex=Copy HEX",
        "--action=rgb=Copy RGB",
        "--action=hsv=Copy HSV",
    ],
    stdout=subprocess.PIPE,
)

action = proc.communicate()[0].decode().strip()

if action == "rgb":
    subprocess.run(["wl-copy"], input=rgb_color.encode())
    subprocess.call(
        [
            "notify-send",
            "Color Picker",
            f"RGB copied: {rgb_color}",
            "-i",
            str(icon),
            "-u",
            "low",
        ]
    )
elif action == "hsv":
    subprocess.run(["wl-copy"], input=hsv_color.encode())
    subprocess.call(
        [
            "notify-send",
            "Color Picker",
            f"HSV copied: {hsv_color}",
            "-i",
            str(icon),
            "-u",
            "low",
        ]
    )
elif action == "hex":
    subprocess.run(["wl-copy"], input=hex_color.encode())
    subprocess.call(
        [
            "notify-send",
            "Color Picker",
            f"HEX copied: {hex_color}",
            "-i",
            str(icon),
            "-u",
            "low",
        ]
    )
