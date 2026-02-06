"""
Run this to generate a macOS PKG background with
the conda-forge anvil logo in the bottom left corner
"""
# needs 'pillow' package
from PIL import Image, ImageOps

# logo taken from https://github.com/conda-forge/marketing/084d589/main/logo/just_anvil_black.png
logo = Image.open("just_anvil_black.png")  
background = Image.new("RGBA", (1227, 600), (0, 0, 0, 0))
background.paste(ImageOps.contain(logo, (290, 290)), (30, 460))
background.save("osx_pkg_background.png", format="png")
