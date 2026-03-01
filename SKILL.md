---
name: clawvig
description: >-
  Instagram video enhancement and captioning pipeline. Use this skill when 
  the user wants to process, enhance, grade, or caption videos for 
  Instagram — including sharpening, colour grading, warmth adjustments, 
  audio normalisation, or burning animated captions. 
metadata:
  {
    "openclaw":
      {
        "emoji": "🎬",
        "requires": { "bins": ["ffmpeg", "uv"] },
      },
  }
---

# clawvig — Instagram Video Pipeline

Enhances videos (sharpening, colour grading, warmth) and burns in animated captions. Enhancement runs before captioning so filters don't interact with caption rendering.

## Pipeline

```
input video → enhance (ffmpeg filters + -14 LUFS audio) → captions (pycaps) → output/
```

## Presets

| Preset | Sharpness | Saturation | Warmth |
|---|---|---|---|
| `natural` | subtle | +10% | none |
| `cinematic` | strong | +35% | warm (red boost, blue reduce) |
| `vivid` | strong | +40% | none |

## Directory layout

The scripts are bundled at `~/.openclaw/skills/clawvig/scripts/`.
Input videos go in `./input/` relative to the user's working directory.
Output lands in `./output/` relative to the user's working directory.

## How to run

Before the first run, install Python dependencies:

```bash
cd ~/.openclaw/skills/clawvig && uv sync
```

Then process videos:

```bash
cd ~/.openclaw/skills/clawvig && uv run python scripts/caption_service.py \
  --input <path/to/input> \
  --output <path/to/output> \
  [--preset natural|cinematic|vivid] \
  [--css scripts/futuristic.css]
```

The `--input` and `--output` flags accept absolute or relative paths. If the user doesn't specify them, default to `./input` and `./output` relative to their current working directory.

## Common invocations

```bash
# Cinematic preset, default CSS
cd ~/.openclaw/skills/clawvig && uv run python scripts/caption_service.py \
  --input ~/videos/raw --output ~/videos/ready --preset cinematic

# Custom CSS, no enhancement
cd ~/.openclaw/skills/clawvig && uv run python scripts/caption_service.py \
  --input ./input --output ./output

# Vivid + custom style
cd ~/.openclaw/skills/clawvig && uv run python scripts/caption_service.py \
  --input ./input --output ./output --preset vivid --css /path/to/my.css
```

## Edge cases

- If `ffmpeg` is not installed: tell the user to install it (`sudo pacman -S ffmpeg` on Arch/CachyOS, `brew install ffmpeg` on macOS, `sudo apt install ffmpeg` on Ubuntu)
- If `uv` is not installed: direct to https://docs.astral.sh/uv/getting-started/installation/
- If the input directory is empty: report clearly rather than silently exiting
- If an unknown preset is given: list the valid options (natural, cinematic, vivid)
- Audio normalisation may print a warning about dynamic mode for short clips — this is expected and not an error
- The first run will be slow as pycaps downloads the Whisper model for transcription
