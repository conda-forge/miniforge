#!/usr/bin/env python

import re
import requests
from packaging import version

def get_most_recent_version(name):
    request = requests.get(
        "https://api.anaconda.org/package/conda-forge/" + name
    )
    request.raise_for_status()

    pkg = max(
        request.json()["files"], key=lambda x: version.parse(x["version"])
    )
    return pkg["version"]

mamba_version = get_most_recent_version("mamba")
conda_version = get_most_recent_version("conda")

with open("Miniforge3/construct.yaml", "r") as f:
    content = f.read()

# Replace conda version
content = re.sub(r'MINIFORGE_VERSION",\s+"[\d.]+-(\d+)"', f"MINIFORGE_VERSION\", \"{conda_version}-\\1\"", content)

# Replace mamba version
content = re.sub(r"mamba [\d.]+$", f"mamba {mamba_version}", content, flags=re.M)

with open("Miniforge3/construct.yaml", "w") as f:
    f.write(content)
