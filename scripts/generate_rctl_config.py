#!/usr/bin/env python3
import argparse
import json
import os
from pathlib import Path


def xdg_config_home() -> Path:
    return Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))


def xdg_data_home() -> Path:
    return Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local" / "share"))


def load_json(path: Path, fallback_path: Path | None = None) -> dict:
    source = path if path.exists() else fallback_path
    if source is None or not source.exists():
        return {}
    with source.open("r", encoding="utf-8") as file:
        return json.load(file)


def calculate_ignore_alpha(theme: dict, compositor: dict) -> str:
    if compositor.get("blurExplicitIgnoreAlpha"):
        value = compositor.get("blurIgnoreAlphaValue", 0.2)
    else:
        bar_bg = theme.get("srBarBg") or {}
        bg = theme.get("srBg") or {}
        bar_opacity = bar_bg.get("opacity", 0)
        bg_opacity = bg.get("opacity", 1.0)
        value = min(bar_opacity, bg_opacity) if bar_opacity > 0 else bg_opacity
    return f"{float(value):.2f}"


def generate_toml(theme: dict, compositor: dict) -> str:
    ignore_alpha = calculate_ignore_alpha(theme, compositor)
    return f"""[startup]
exec-once = "rshell"

[[layer_rules]]
namespace = "quickshell"
no_anim = true

[[layer_rules]]
namespace = "quickshell"
blur = true

[[layer_rules]]
namespace = "quickshell"
blur_popups = true

[[layer_rules]]
namespace = "quickshell"
ignore_alpha = true
ignore_alpha_value = {ignore_alpha}

[[layer_rules]]
namespace = "selection"
no_anim = true

[[layer_rules]]
namespace = "fabric"
blur = true
ignore_alpha_value = 0.4

[[layer_rules]]
namespace = "rshell"
blur = true
blur_popups = true
no_anim = true
ignore_alpha_value = 0.5

[[layer_rules]]
namespace = "overview"
blur = true
blur_popups = true
no_anim = true

[[layer_rules]]
namespace = "presets"
blur = true
blur_popups = true
no_anim = true

[input]
[input.keyboard]
layouts = ""
variants = ""
"""


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate rshell's rctl TOML config.")
    parser.add_argument("--repo", default=str(Path(__file__).resolve().parents[1]))
    parser.add_argument("--output", default=str(xdg_data_home() / "rshell" / "rctl.toml"))
    args = parser.parse_args()

    repo = Path(args.repo)
    config_dir = xdg_config_home() / "rshell" / "config"
    preset_dir = repo / "assets" / "presets" / "rshell Default"

    theme = load_json(config_dir / "theme.json", preset_dir / "theme.json")
    compositor = load_json(config_dir / "compositor.json", preset_dir / "compositor.json")
    toml = generate_toml(theme, compositor)

    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(toml, encoding="utf-8")
    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
